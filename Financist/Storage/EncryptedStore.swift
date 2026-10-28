import CommonCrypto
import CryptoKit
import Foundation
import Security

enum VaultError: LocalizedError {
    case keychain(OSStatus)
    case keyMissing
    case badBackup
    case wrongPassword

    var errorDescription: String? {
        switch self {
        case .keychain(let status): "Ошибка связки ключей (\(status))."
        case .keyMissing: "Ключ шифрования не найден на этом устройстве. Данные невозможно расшифровать."
        case .badBackup: "Это не файл резервной копии Financist."
        case .wrongPassword: "Неверный пароль или файл повреждён."
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

    static func existing() throws -> SymmetricKey? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess, let data = item as? Data else { throw VaultError.keychain(status) }
        return SymmetricKey(data: data)
    }

    static func loadOrCreate() throws -> SymmetricKey {
        if let key = try existing() { return key }
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

/// Файл с данными: JSON → AES-256-GCM → файл с защитой `.completeFileProtection`
/// (iOS дополнительно шифрует его ключом устройства, пока iPhone заблокирован).
struct EncryptedStore {
    let url: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("vault.sealed")
    }()

    var fileExists: Bool { FileManager.default.fileExists(atPath: url.path) }

    func load() throws -> Vault? {
        guard fileExists else { return nil }
        guard let key = try KeyStore.existing() else { throw VaultError.keyMissing }
        let sealed = try Data(contentsOf: url)
        let json = try AES.GCM.open(AES.GCM.SealedBox(combined: sealed), using: key)
        return try JSONDecoder().decode(Vault.self, from: json)
    }

    func save(_ vault: Vault) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        let key = try KeyStore.loadOrCreate()
        let json = try JSONEncoder().encode(vault)
        guard let sealed = try AES.GCM.seal(json, using: key).combined else { throw VaultError.badBackup }
        try sealed.write(to: url, options: [.atomic, .completeFileProtection])
        // Без iCloud: файл не попадает в резервные копии iCloud/iTunes.
        var fileURL = url
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try? fileURL.setResourceValues(values)
    }

    func wipe() {
        try? FileManager.default.removeItem(at: url)
        KeyStore.delete()
    }
}

/// Резервная копия, защищённая паролем: PBKDF2-SHA256 → AES-256-GCM.
/// Формат: "FNST1" | соль (16 байт) | число итераций (UInt32 BE) | AES-GCM combined.
enum BackupCrypto {
    private static let magic = Data("FNST1".utf8)
    private static let iterations: UInt32 = 310_000

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
        do {
            let json = try AES.GCM.open(AES.GCM.SealedBox(combined: Data(bytes[header...])), using: key)
            return try JSONDecoder().decode(Vault.self, from: json)
        } catch {
            throw VaultError.wrongPassword
        }
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
