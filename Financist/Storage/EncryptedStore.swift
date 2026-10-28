import CommonCrypto
import CryptoKit
import Foundation
import Security

enum VaultError: LocalizedError {
    case keychain(OSStatus)
    case keyMissing
    case badBackup
    case wrongPassword
    case newerFormat
    case notReady

    var errorDescription: String? {
        switch self {
        case .keychain(let status): "Связка ключей iPhone сейчас недоступна (\(status)). Попробуйте чуть позже."
        case .keyMissing: "Ключ шифрования не найден на этом iPhone."
        case .badBackup: "Это не файл переноса Financist."
        case .wrongPassword: "Неверный пароль или файл повреждён."
        case .newerFormat: "Данные записаны более новой версией Financist. Обновите приложение в TestFlight — ничего не потеряется."
        case .notReady: "Разблокируйте iPhone и попробуйте ещё раз."
        }
    }
}

/// Ключ шифрования (AES-256) хранится в связке ключей iOS.
/// `WhenUnlockedThisDeviceOnly`: доступен только при разблокированном iPhone,
/// не синхронизируется через iCloud Keychain и не переносится в бэкапы.
enum KeyStore {
    private static let service = "financist.vault-key"
    private static let account = "vault"

    private static var baseQuery: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: service,
         kSecAttrAccount as String: account]
    }

    /// nil — только если связка ключей уверенно ответила «такого ключа нет».
    /// Любой другой ответ (iPhone заблокирован, сбой) — ошибка, а не повод создавать новый ключ.
    static func existing() throws -> SymmetricKey? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess, let data = item as? Data, data.count == 32 else {
            throw VaultError.keychain(status)
        }
        return SymmetricKey(data: data)
    }

    /// Создаёт новый ключ. Если ключ на самом деле есть (сбой при чтении), iOS ответит
    /// «дубликат», и мы ничего не тронем.
    static func create() throws -> SymmetricKey {
        let key = SymmetricKey(size: .bits256)
        var attributes = baseQuery
        attributes[kSecValueData as String] = key.withUnsafeBytes { Data($0) }
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else { throw VaultError.keychain(status) }
        return key
    }

    static func delete() {
        SecItemDelete(baseQuery as CFDictionary)
    }
}

/// Хранилище на диске. Все файлы — в папке `Application Support/Financist`, зашифрованы одним ключом,
/// защищены `.completeFileProtection` и не попадают в резервные копии iCloud/компьютера.
///
/// - `main.sealed` — текущие данные. Запись атомарная: сначала временный файл, потом подмена.
/// - `copy-launch.sealed` — копия при открытии (не чаще раза в сутки).
/// - `copy-weekly.sealed` — копия раз в неделю.
/// - `copy-build-<версия>.sealed` — копия перед первым запуском новой сборки (хранятся 3 последние).
/// - `copy-displaced-….sealed` — нечитаемый файл, который пришлось заменить. Никогда не удаляется сам:
///   как только он снова читается (например, после обновления), траты из него автоматически добавляются обратно.
///
/// Правило: файлы удаляются только по явной команде «Удалить все данные».
struct EncryptedStore {
    static let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("Financist", isDirectory: true)

    let mainURL = EncryptedStore.directory.appendingPathComponent("main.sealed")
    let launchCopyURL = EncryptedStore.directory.appendingPathComponent("copy-launch.sealed")
    let weeklyCopyURL = EncryptedStore.directory.appendingPathComponent("copy-weekly.sealed")

    private var manager: FileManager { .default }

    var mainExists: Bool { manager.fileExists(atPath: mainURL.path) }

    /// Все файлы с данными в папке (основной и копии).
    var allVaultFiles: [URL] {
        let files = (try? manager.contentsOfDirectory(at: Self.directory, includingPropertiesForKeys: [.contentModificationDateKey])) ?? []
        return files.filter { $0.pathExtension == "sealed" }
    }

    /// Копии от новых к старым: при открытии, недельная, перед обновлениями, вытесненные.
    var copies: [URL] {
        let files = allVaultFiles.filter { $0 != mainURL }
        func rank(_ url: URL) -> Int {
            switch url.lastPathComponent {
            case launchCopyURL.lastPathComponent: 0
            case weeklyCopyURL.lastPathComponent: 1
            default: url.lastPathComponent.hasPrefix("copy-build-") ? 2 : 3
            }
        }
        return files.sorted { a, b in
            rank(a) != rank(b) ? rank(a) < rank(b) : modificationDate(a) > modificationDate(b)
        }
    }

    var displacedCopies: [URL] {
        allVaultFiles.filter { $0.lastPathComponent.hasPrefix("copy-displaced-") }
    }

    func modificationDate(_ url: URL) -> Date {
        (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
    }

    // MARK: Чтение

    /// Расшифровывает и разбирает файл. Возвращает и размер — для проверки «подозрительно пусто».
    func read(_ file: URL) throws -> (vault: Vault, size: Int) {
        guard let key = try KeyStore.existing() else { throw VaultError.keyMissing }
        let sealed = try Data(contentsOf: file)
        let json = try AES.GCM.open(AES.GCM.SealedBox(combined: sealed), using: key)
        return (try JSONDecoder().decode(Vault.self, from: json), sealed.count)
    }

    // MARK: Запись

    /// `allowNewKey` — только при явном действии пользователя (загрузка файла переноса, «начать заново»).
    /// Без него новый ключ создаётся лишь при самом первом запуске, когда файлов с данными нет вообще.
    func write(_ vault: Vault, allowNewKey: Bool = false) throws {
        try prepareDirectory()
        let key: SymmetricKey
        if let existing = try KeyStore.existing() {
            key = existing
        } else if allowNewKey || allVaultFiles.isEmpty {
            key = try KeyStore.create()
        } else {
            // Файлы есть, а ключа нет — ни в коем случае не создаём новый ключ поверх.
            throw VaultError.keyMissing
        }
        let json = try JSONEncoder().encode(vault)
        guard let sealed = try AES.GCM.seal(json, using: key).combined else { throw VaultError.badBackup }
        try sealed.write(to: mainURL, options: [.atomic, .completeFileProtection])
        excludeFromBackup(mainURL)
    }

    /// Побайтовая копия основного файла (тем же ключом). Основной файл не трогается.
    /// Запись атомарная, с той же защитой, что у основного файла; дата копии — момент копирования.
    func copyMain(to target: URL) throws {
        guard mainExists else { return }
        try prepareDirectory()
        let bytes = try Data(contentsOf: mainURL)
        try bytes.write(to: target, options: [.atomic, .completeFileProtection])
        excludeFromBackup(target)
    }

    /// Копия основного файла, который сейчас придётся заменить. Если копия не удалась —
    /// ошибка, и замены не будет.
    func displaceMain() throws {
        guard mainExists else { return }
        let stamp = Int(Date.now.timeIntervalSince1970)
        try copyMain(to: Self.directory.appendingPathComponent("copy-displaced-\(stamp)-\(UUID().uuidString.prefix(8)).sealed"))
    }

    /// Копии при открытии (раз в сутки) и раз в неделю.
    func refreshRoutineCopies() {
        let now = Date.now
        if !manager.fileExists(atPath: launchCopyURL.path) || now.timeIntervalSince(modificationDate(launchCopyURL)) > 86_400 {
            try? copyMain(to: launchCopyURL)
        }
        if !manager.fileExists(atPath: weeklyCopyURL.path) || now.timeIntervalSince(modificationDate(weeklyCopyURL)) > 7 * 86_400 {
            try? copyMain(to: weeklyCopyURL)
        }
    }

    /// Перед первым запуском новой сборки сохраняем файл таким, каким его оставила прошлая.
    func snapshotBeforeUpdate(tag: String) {
        let target = Self.directory.appendingPathComponent("copy-build-\(tag).sealed")
        guard mainExists, !manager.fileExists(atPath: target.path) else { return }
        try? copyMain(to: target)
        let builds = allVaultFiles
            .filter { $0.lastPathComponent.hasPrefix("copy-build-") }
            .sorted { modificationDate($0) > modificationDate($1) }
        for old in builds.dropFirst(3) { try? manager.removeItem(at: old) }
    }

    /// Файлы прошлых тестовых версий лежали прямо в Application Support — переносим в папку.
    func migrateLegacyLocation() {
        let legacy = Self.directory.deletingLastPathComponent()
        let oldMain = legacy.appendingPathComponent("vault.sealed")
        let oldCopy = legacy.appendingPathComponent("vault.backup.sealed")
        guard manager.fileExists(atPath: oldMain.path) || manager.fileExists(atPath: oldCopy.path) else { return }
        try? prepareDirectory()
        if manager.fileExists(atPath: oldMain.path) && !mainExists { try? manager.moveItem(at: oldMain, to: mainURL) }
        if manager.fileExists(atPath: oldCopy.path) && !manager.fileExists(atPath: launchCopyURL.path) {
            try? manager.moveItem(at: oldCopy, to: launchCopyURL)
        }
    }

    func remove(_ file: URL) {
        try? manager.removeItem(at: file)
    }

    /// Только для «Удалить все данные»: стирает все файлы и ключ.
    func wipe() {
        try? manager.removeItem(at: Self.directory)
        KeyStore.delete()
    }

    private func prepareDirectory() throws {
        try manager.createDirectory(at: Self.directory, withIntermediateDirectories: true)
        excludeFromBackup(Self.directory)
    }

    /// Без iCloud: файлы не попадают в резервные копии iCloud/компьютера.
    private func excludeFromBackup(_ file: URL) {
        var fileURL = file
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try? fileURL.setResourceValues(values)
    }
}

extension Error {
    /// iPhone заблокирован, и iOS пока не даёт читать защищённые данные. Проходит само.
    var isProtectedDataUnavailable: Bool {
        if let vaultError = self as? VaultError, case .keychain(let status) = vaultError {
            return status == errSecInteractionNotAllowed
        }
        let ns = self as NSError
        return ns.domain == NSCocoaErrorDomain
            && (ns.code == NSFileReadNoPermissionError || ns.code == NSFileWriteNoPermissionError)
    }

    /// Содержимое файла повреждено (не сходится проверка шифра). Только в этом случае
    /// имеет смысл открывать копию — во всех остальных файл цел, и его нельзя трогать.
    var isCorruptedFile: Bool {
        if self is CryptoKitError { return true }
        let ns = self as NSError
        return ns.domain == NSCocoaErrorDomain && ns.code == NSFileReadCorruptFileError
    }

    var isOutOfSpace: Bool {
        let ns = self as NSError
        if ns.domain == NSCocoaErrorDomain && ns.code == NSFileWriteOutOfSpaceError { return true }
        if ns.domain == NSPOSIXErrorDomain && ns.code == Int(ENOSPC) { return true }
        if let underlying = ns.userInfo[NSUnderlyingErrorKey] as? NSError {
            return underlying.domain == NSPOSIXErrorDomain && underlying.code == Int(ENOSPC)
        }
        return false
    }
}

/// Резервная копия, защищённая паролем: PBKDF2-SHA256 → AES-256-GCM.
/// Формат: "FNST1" | соль (16 байт) | число итераций (UInt32 BE) | AES-GCM combined.
enum BackupCrypto {
    private static let magic = Data("FNST1".utf8)
    private static let iterations: UInt32 = 310_000
    static let minimumPasswordLength = 8

    /// Короткий пароль из одних цифр подбирается за минуты, поэтому требуем длину и хотя бы одну букву.
    /// Повтор нужен, чтобы опечатка не сделала файл бесполезным. nil — пароль подходит.
    static func passwordProblem(_ password: String, repeated: String) -> String? {
        if password.count < minimumPasswordLength {
            return "Пароль слишком короткий — нужно хотя бы \(minimumPasswordLength) символов. Подойдёт фраза из нескольких слов."
        }
        if !password.contains(where: \.isLetter) {
            return "В пароле нужна хотя бы одна буква — одни цифры легко подобрать."
        }
        if password != repeated {
            return "Пароли не совпали. Попробуйте ещё раз."
        }
        return nil
    }

    static func encrypt(_ vault: Vault, password: String) throws -> Data {
        var salt = Data(count: 16)
        let status = salt.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 16, $0.baseAddress!) }
        guard status == errSecSuccess else { throw VaultError.keychain(status) }
        let key = try deriveKey(password: password, salt: salt, rounds: iterations)
        let json = try JSONEncoder().encode(vault)
        guard let sealed = try AES.GCM.seal(json, using: key).combined else { throw VaultError.badBackup }
        var rounds = iterations.bigEndian
        return magic + salt + Data(bytes: &rounds, count: 4) + sealed
    }

    static func decrypt(_ data: Data, password: String) throws -> Vault {
        let header = magic.count + 16 + 4
        guard data.count > header, data.prefix(magic.count) == magic else { throw VaultError.badBackup }
        let bytes = [UInt8](data)
        let salt = Data(bytes[magic.count..<(magic.count + 16)])
        let r = bytes[(magic.count + 16)..<header]
        let rounds = r.reduce(UInt32(0)) { $0 << 8 | UInt32($1) }
        let key = try deriveKey(password: password, salt: salt, rounds: rounds)
        let json: Data
        do {
            json = try AES.GCM.open(AES.GCM.SealedBox(combined: Data(bytes[header...])), using: key)
        } catch {
            throw VaultError.wrongPassword
        }
        // Пароль верный. Если файл из более новой версии — так и скажем, а не «неверный пароль».
        return try JSONDecoder().decode(Vault.self, from: json)
    }

    private static func deriveKey(password: String, salt: Data, rounds: UInt32) throws -> SymmetricKey {
        let passwordBytes = Array(password.utf8).map { Int8(bitPattern: $0) }
        var derived = [UInt8](repeating: 0, count: 32)
        let saltBytes = [UInt8](salt)
        let status = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            passwordBytes, passwordBytes.count,
            saltBytes, saltBytes.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
            rounds,
            &derived, derived.count
        )
        guard Int(status) == kCCSuccess else { throw VaultError.badBackup }
        return SymmetricKey(data: derived)
    }
}
