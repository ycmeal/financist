import Foundation
import Observation
import SwiftUI
import UIKit

/// Файл резервной копии, который нужно восстановить (выбран в «Файлах» или пришёл по AirDrop).
struct PendingRestore: Identifiable {
    let id = UUID()
    let data: Data
}

/// Почему данные не открылись. В обоих случаях файлы остаются нетронутыми.
enum LoadFailure: Equatable {
    /// Файл записан более новой сборкой — нужно обновить приложение.
    case newerVersion
    /// Файл не читается (нет ключа, сбой, ошибка в версии). Подробности — для разработчика.
    case unreadable(String)
}

/// Состояние данных: ждём разблокировки, всё открыто или открыть не удалось.
enum LoadState: Equatable {
    case waiting
    case ready
    case failed(LoadFailure)
}

/// Не получилось сохранить — показываем, а не молчим.
enum SaveProblem: Equatable {
    case outOfSpace
    case other(String)
}

@Observable
@MainActor
final class AppStore {
    private(set) var vault = Vault()
    private(set) var loadState: LoadState = .waiting
    /// Основной файл был повреждён, данные открыты из копии.
    var recoveredFromBackup = false
    /// Сколько трат вернулось из ранее нечитаемых файлов.
    var recoveredExpenses: Int?
    /// Последнее сохранение не удалось; изменения пока только в памяти.
    var saveProblem: SaveProblem?
    private(set) var hasUnsavedChanges = false
    var ratesError: String?
    private(set) var isRefreshingRates = false

    // Навигация: виджет открывает ввод траты, AirDrop — восстановление.
    var selectedTab: AppTab = .expenses
    var isAddingExpense = false
    var pendingRestore: PendingRestore?
    /// Открыть «Итоги» на нужном месяце (из карточки «месяц закрыт»).
    var statsJump: Date?
    /// Приложение закрыто замком Face ID.
    var isLocked = false

    private let store = EncryptedStore()
    /// Сохраняем только после успешного открытия — иначе можно затереть настоящие данные пустыми.
    private var canSave = false

    init() {}

    private static var buildTag: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "0"
        let build = info?["CFBundleVersion"] as? String ?? "0"
        return "\(version)-\(build)"
    }

    // MARK: Открытие

    /// Открывает данные. Безопасно вызывать сколько угодно раз: при запуске, при возврате
    /// в приложение и когда iPhone разблокировали.
    ///
    /// Правила, которые нельзя нарушать:
    /// - пока телефон заблокирован (iOS может запустить приложение заранее), ничего не читаем и не пишем;
    /// - «первый запуск» — только если в папке нет вообще ни одного файла с данными;
    /// - копию открываем, только если основной файл повреждён; при любой другой ошибке файлы не трогаем;
    /// - ничего не перезаписываем, пока не прочитали.
    func loadIfNeeded() {
        guard loadState != .ready, UIApplication.shared.isProtectedDataAvailable else { return }
        store.migrateLegacyLocation()
        store.snapshotBeforeUpdate(tag: Self.buildTag)

        guard store.mainExists else {
            if store.allVaultFiles.isEmpty {
                // Действительно первый запуск: файлов нет.
                vault = Vault()
                finishLoading()
            } else {
                // Основного файла нет, а копии есть (например, сбой посреди замены) — открываем копию.
                openFromCopies(reason: "Основной файл не найден.")
            }
            return
        }

        do {
            let (loaded, size) = try store.read(store.mainURL)
            if Self.looksWronglyEmpty(loaded, size: size) {
                // Файл большой, а трат ноль — скорее всего, ошибка в этой версии. Ничего не трогаем.
                loadState = .failed(.unreadable("Файл не пустой, но траты не прочитались."))
                return
            }
            vault = loaded
            finishLoading()
            store.refreshRoutineCopies()
            recoverDisplacedCopies()
        } catch where error.isProtectedDataUnavailable {
            return
        } catch VaultError.newerFormat {
            loadState = .failed(.newerVersion)
        } catch where error.isCorruptedFile {
            openFromCopies(reason: "Основной файл повреждён.")
        } catch {
            // Нет ключа, сбой связки ключей, ошибка чтения или разбора: файл цел — не трогаем, ждём.
            loadState = .failed(.unreadable(Self.describe(error)))
        }
    }

    /// Основной файл не открылся: берём самую свежую читаемую копию. Основной файл (если есть)
    /// сначала копируется в сторону и только потом заменяется.
    private func openFromCopies(reason: String) {
        var candidate: Vault?
        for copy in store.copies {
            do {
                let (copyVault, size) = try store.read(copy)
                if Self.looksWronglyEmpty(copyVault, size: size) { continue }
                candidate = copyVault
                break
            } catch VaultError.newerFormat {
                loadState = .failed(.newerVersion)
                return
            } catch where error.isProtectedDataUnavailable {
                return
            } catch {
                continue
            }
        }
        guard let candidate else {
            loadState = .failed(.unreadable(reason))
            return
        }
        do {
            try store.displaceMain()
            try commit(candidate)
        } catch {
            // Не вышло записать (например, кончилось место) — ничего не меняем, попробуем позже.
            loadState = .failed(.unreadable(error.isOutOfSpace
                ? "На iPhone закончилось место. Освободите немного места и попробуйте ещё раз."
                : Self.describe(error)))
            return
        }
        recoveredFromBackup = true
        finishLoading()
    }

    /// Файлы, которые когда-то пришлось заменить, потому что они не читались. Если теперь
    /// читаются (например, после обновления), их траты возвращаются, а файл убирается.
    private func recoverDisplacedCopies() {
        var added = 0
        for file in store.displacedCopies {
            guard let other = (try? store.read(file))?.vault else { continue }
            var merged = vault
            let count = merged.merge(other)
            if count > 0 {
                do { try commit(merged) } catch { continue }
                added += count
            }
            store.remove(file)
        }
        if added > 0 { recoveredExpenses = added }
    }

    /// Защита от ошибок в будущих версиях: если файл больше 32 КБ, а трат и удалённых нет совсем,
    /// это не пустые данные, а ошибка чтения.
    private static func looksWronglyEmpty(_ vault: Vault, size: Int) -> Bool {
        vault.expenses.isEmpty && vault.trash.isEmpty && size > 32_768
    }

    private static func describe(_ error: Error) -> String {
        (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
    }

    private func finishLoading() {
        loadState = .ready
        canSave = true
        if vault.purgeOldTrash() { persist() }
        refreshReminders()
    }

    // MARK: Сохранение

    private func persist() {
        guard canSave else { return }
        hasUnsavedChanges = true
        vault.schemaVersion = Vault.currentSchema
        do {
            try store.write(vault)
            hasUnsavedChanges = false
            saveProblem = nil
            refreshReminders()
        } catch where error.isProtectedDataUnavailable && !UIApplication.shared.isProtectedDataAvailable {
            // iPhone заблокировался — сохраним при следующем открытии, пугать не нужно.
        } catch {
            saveProblem = error.isOutOfSpace ? .outOfSpace : .other(Self.describe(error))
        }
    }

    /// Записывает новые данные на диск и только после успеха показывает их в приложении.
    /// Если запись не удалась — в памяти остаётся прежнее, ничего не теряется.
    private func commit(_ newVault: Vault, allowNewKey: Bool = false) throws {
        var updated = newVault
        updated.schemaVersion = Vault.currentSchema
        try store.write(updated, allowNewKey: allowNewKey)
        vault = updated
        hasUnsavedChanges = false
        saveProblem = nil
    }

    /// Повторная попытка, если прошлое сохранение не удалось (например, кончилось место).
    func retryUnsavedChanges() {
        if hasUnsavedChanges { persist() }
    }

    /// При возврате в приложение: досохранить и обновить копии, если пора.
    func appBecameActive() {
        loadIfNeeded()
        guard loadState == .ready else { return }
        retryUnsavedChanges()
        if !hasUnsavedChanges { store.refreshRoutineCopies() }
        if vault.purgeOldTrash() { persist() }
        refreshReminders()
    }

    // MARK: Ссылки

    func consumeAddRequest() {
        guard AddRequest.pending else { return }
        AddRequest.pending = false
        selectedTab = .expenses
        isAddingExpense = true
    }

    func handle(url: URL) {
        if url.isFileURL {
            let scoped = url.startAccessingSecurityScopedResource()
            defer { if scoped { url.stopAccessingSecurityScopedResource() } }
            if let data = try? Data(contentsOf: url) { pendingRestore = PendingRestore(data: data) }
            // Копию из AirDrop (папка Inbox) больше не храним.
            if url.path.contains("/Inbox/") { try? FileManager.default.removeItem(at: url) }
        } else if url.scheme == "financist" && url.host == "add" {
            selectedTab = .expenses
            isAddingExpense = true
        }
    }

    // MARK: Настройки

    var displayCurrency: Currency {
        get { vault.displayCurrency }
        set { vault.displayCurrency = newValue; persist() }
    }

    var palette: Palette {
        get { vault.palette }
        set { vault.palette = newValue; persist() }
    }

    var lockEnabled: Bool {
        get { vault.lockEnabled }
        set { vault.lockEnabled = newValue; persist() }
    }

    var autoUpdateRates: Bool {
        get { vault.autoUpdateRates }
        set { vault.autoUpdateRates = newValue; persist() }
    }

    /// Валюты для быстрого выбора: последние использованные + валюта итогов.
    var quickCurrencies: [Currency] {
        var list = vault.recentCurrencies
        if !list.contains(vault.displayCurrency) { list.append(vault.displayCurrency) }
        return Array(list.prefix(4))
    }

    // MARK: Траты

    func upsert(_ expense: Expense) {
        if let index = vault.expenses.firstIndex(where: { $0.id == expense.id }) {
            vault.expenses[index] = expense
        } else {
            vault.expenses.append(expense)
            // Запоминаем выбор валюты для следующей траты.
            vault.inputCurrency = expense.currency
            vault.recentCurrencies.removeAll { $0 == expense.currency }
            vault.recentCurrencies.insert(expense.currency, at: 0)
            vault.recentCurrencies = Array(vault.recentCurrencies.prefix(4))
        }
        persist()
    }

    /// Удаление не навсегда: трата 30 дней лежит в «Недавно удалённых».
    func deleteExpenses(ids: [UUID]) {
        let set = Set(ids)
        let now = Date.now
        let removed = vault.expenses.filter { set.contains($0.id) }
        vault.expenses.removeAll { set.contains($0.id) }
        vault.trash.append(contentsOf: removed.map { DeletedExpense(expense: $0, deletedAt: now) })
        persist()
    }

    func restoreFromTrash(ids: [UUID]) {
        let set = Set(ids)
        let returning = vault.trash.filter { set.contains($0.id) }.map(\.expense)
        vault.trash.removeAll { set.contains($0.id) }
        vault.expenses.append(contentsOf: returning)
        persist()
    }

    var suggestions: [Suggestion] {
        SuggestionEngine.build(expenses: vault.expenses, categories: vault.categories)
    }

    // MARK: Категории

    func category(for id: UUID) -> ExpenseCategory {
        vault.categories.first { $0.id == id } ?? .unknown
    }

    /// Категории по частоте: свежие траты (последние 2 месяца) весят втрое больше старых,
    /// поэтому список подстраивается под то, на что тратите сейчас.
    var categoriesByUsage: [ExpenseCategory] {
        let recent = Date.now.addingTimeInterval(-60 * 86_400)
        var score: [UUID: Double] = [:]
        for e in vault.expenses { score[e.categoryID, default: 0] += e.date >= recent ? 3 : 1 }
        return vault.categories.enumerated()
            .sorted { a, b in
                let sa = score[a.element.id] ?? 0, sb = score[b.element.id] ?? 0
                return sa != sb ? sa > sb : a.offset < b.offset
            }
            .map(\.element)
    }

    /// Недавние разные траты (по месту и категории) — чтобы повторить одним касанием.
    var recentTemplates: [Expense] {
        var seen = Set<String>()
        var result: [Expense] = []
        for e in vault.expenses.sorted(by: { $0.date > $1.date }) where !e.note.isEmpty {
            let key = SuggestionEngine.normalize(e.note) + "|" + e.categoryID.uuidString
            if seen.insert(key).inserted { result.append(e) }
            if result.count == 6 { break }
        }
        return result
    }

    func upsert(_ category: ExpenseCategory) {
        if let index = vault.categories.firstIndex(where: { $0.id == category.id }) {
            vault.categories[index] = category
        } else {
            vault.categories.append(category)
        }
        persist()
    }

    func moveCategories(from source: IndexSet, to destination: Int) {
        vault.categories.move(fromOffsets: source, toOffset: destination)
        persist()
    }

    /// Траты удалённой категории переезжают в «Другое».
    func deleteCategories(ids: [UUID]) {
        let removing = Set(ids)
        guard vault.categories.count > removing.count else { return }
        vault.categories.removeAll { removing.contains($0.id) }
        if vault.expenses.contains(where: { removing.contains($0.categoryID) }) {
            let fallback: ExpenseCategory
            if let other = vault.categories.first(where: { $0.name == ExpenseCategory.otherName }) {
                fallback = other
            } else {
                fallback = ExpenseCategory.defaults.last!
                vault.categories.append(fallback)
            }
            for index in vault.expenses.indices where removing.contains(vault.expenses[index].categoryID) {
                vault.expenses[index].categoryID = fallback.id
            }
        }
        persist()
    }

    func expenseCount(in categoryID: UUID) -> Int {
        vault.expenses.filter { $0.categoryID == categoryID }.count
    }

    /// Сколько потрачено в этом месяце в валюте бюджета.
    func spentThisMonth(in currency: Currency) -> Decimal {
        vault.expenses
            .filter { Calendar.current.isDate($0.date, equalTo: .now, toGranularity: .month) }
            .total(in: currency)
    }

    // MARK: Регулярные платежи

    private func monthKey(_ id: UUID, _ date: Date = .now) -> String {
        let c = Calendar.current.dateComponents([.year, .month], from: date)
        return "\(id.uuidString)|\(c.year ?? 0)-\(c.month ?? 0)"
    }

    /// Платежи, у которых уже наступил день в этом месяце, но они ещё не записаны и не пропущены.
    var dueRecurring: [RecurringPayment] {
        let calendar = Calendar.current
        let today = calendar.component(.day, from: .now)
        let paidIDs = Set(vault.expenses
            .filter { calendar.isDate($0.date, equalTo: .now, toGranularity: .month) }
            .compactMap(\.recurringID))
        return vault.recurring.filter {
            $0.day <= today && !paidIDs.contains($0.id) && !vault.skippedRecurring.contains(monthKey($0.id))
        }
    }

    func upsert(_ payment: RecurringPayment) {
        if let index = vault.recurring.firstIndex(where: { $0.id == payment.id }) {
            vault.recurring[index] = payment
        } else {
            vault.recurring.append(payment)
        }
        persist()
        Reminders.scheduleRecurring(vault.recurring)
    }

    func deleteRecurring(ids: [UUID]) {
        vault.recurring.removeAll { ids.contains($0.id) }
        persist()
        Reminders.scheduleRecurring(vault.recurring)
    }

    func pay(_ payment: RecurringPayment) {
        upsert(Expense(date: .now, amount: payment.amount, currency: payment.currency,
                       categoryID: payment.categoryID, note: payment.note,
                       rates: vault.rates.effective, recurringID: payment.id))
    }

    func skip(_ payment: RecurringPayment) {
        vault.skippedRecurring.append(monthKey(payment.id))
        // Старые отметки больше не нужны — храним только последние.
        vault.skippedRecurring = Array(vault.skippedRecurring.suffix(100))
        persist()
    }

    // MARK: Напоминания

    var eveningReminder: Bool {
        get { vault.eveningReminder }
        set { vault.eveningReminder = newValue; persist() }
    }

    /// Время напоминания; позже 21:00 поставить нельзя.
    var eveningTime: Date {
        get { Calendar.current.date(bySettingHour: vault.eveningMinutes / 60, minute: vault.eveningMinutes % 60, second: 0, of: .now) ?? .now }
        set {
            let c = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            vault.eveningMinutes = min(21 * 60, (c.hour ?? 20) * 60 + (c.minute ?? 30))
            persist()
        }
    }

    /// Пересобирает вечерние напоминания на неделю вперёд. Текст на сегодня зависит
    /// от того, записаны ли уже траты, поэтому вызывается после каждого изменения.
    func refreshReminders() {
        // Пока данные не открыты, не трогаем напоминания (иначе они бы отменились).
        guard loadState == .ready else { return }
        let hasToday = vault.expenses.contains { Calendar.current.isDateInToday($0.date) }
        Reminders.scheduleEvening(vault.eveningReminder, minutes: vault.eveningMinutes, hasExpensesToday: hasToday)
    }

    // MARK: Курсы

    func refreshRates(force: Bool) async {
        guard loadState == .ready, vault.autoUpdateRates else { return }
        if !force, let updated = vault.rates.updatedAt, Date.now.timeIntervalSince(updated) < 6 * 3600 { return }
        guard !isRefreshingRates else { return }
        isRefreshingRates = true
        defer { isRefreshingRates = false }
        do {
            let fetched = try await RatesService.fetch()
            vault.rates.fetched.merge(fetched) { _, new in new }
            vault.rates.updatedAt = .now
            ratesError = nil
            persist()
        } catch {
            ratesError = "Нет интернета — курсы не обновились."
        }
    }

    func setManualRate(_ rate: Decimal?, for currency: Currency) {
        vault.rates.manual[currency] = rate
        persist()
    }

    // MARK: Перенос данных

    func backup(password: String) throws -> Data {
        try BackupCrypto.encrypt(vault, password: password)
    }

    /// Вызывается, когда файл переноса действительно отправили или сохранили.
    func markTransferFileSaved() {
        vault.lastTransferFileAt = .now
        persist()
    }

    /// Траты из файла переноса добавляются к текущим — ничего не заменяется и не пропадает.
    /// Возвращает, сколько трат добавилось.
    @discardableResult
    func restore(from data: Data, password: String) throws -> Int {
        if loadState == .waiting { loadIfNeeded() }
        let incoming = try BackupCrypto.decrypt(data, password: password)
        switch loadState {
        case .waiting:
            throw VaultError.notReady
        case .failed(.newerVersion):
            throw VaultError.newerFormat
        case .ready:
            var merged = vault
            let added = merged.merge(incoming)
            try commit(merged)
            refreshReminders()
            return added
        case .failed(.unreadable):
            // Текущий файл не читается: кладём его копию в сторону (вернётся сам, если когда-нибудь
            // прочитается), и только потом записываем данные из файла переноса.
            var fresh = Vault()
            fresh.lockEnabled = vault.lockEnabled
            let added = fresh.merge(incoming)
            try store.displaceMain()
            try commit(fresh, allowNewKey: true)
            finishLoading()
            return added
        }
    }

    /// Выход из тупика, если данные не читаются: начать с чистого листа, но старые файлы сохранить.
    /// Как только они снова прочитаются, траты из них вернутся сами.
    func startFreshKeepingOldFiles() throws {
        loadIfNeeded()
        guard case .failed(.unreadable) = loadState else { return }
        var fresh = Vault()
        fresh.lockEnabled = vault.lockEnabled
        try store.displaceMain()
        try commit(fresh, allowNewKey: true)
        finishLoading()
    }

    // MARK: Копии на телефоне

    struct SafetyCopy: Identifiable {
        let url: URL
        let date: Date
        let title: String
        var id: URL { url }
    }

    var safetyCopies: [SafetyCopy] {
        store.copies.map { url in
            let name = url.lastPathComponent
            let title: String
            if name == store.launchCopyURL.lastPathComponent {
                title = "Ежедневная копия"
            } else if name == store.weeklyCopyURL.lastPathComponent {
                title = "Еженедельная копия"
            } else if name.hasPrefix("copy-build-") {
                title = "Перед обновлением"
            } else {
                title = "Нечитаемый файл"
            }
            return SafetyCopy(url: url, date: store.modificationDate(url), title: title)
        }
    }

    /// Сколько трат в копии (nil — не читается).
    func expenseCount(in copy: SafetyCopy) -> Int? {
        (try? store.read(copy.url))?.vault.expenses.count
    }

    /// Добавляет траты из копии к текущим. Ничего не удаляет.
    func mergeCopy(_ copy: SafetyCopy) throws -> Int {
        let other = try store.read(copy.url).vault
        var merged = vault
        let added = merged.merge(other)
        if added > 0 { try commit(merged) }
        return added
    }

    /// «Удалить все данные»: стирает траты, все копии на телефоне и ключ шифрования.
    func resetAll() {
        store.wipe()
        vault = Vault()
        canSave = true
        loadState = .ready
        hasUnsavedChanges = false
        saveProblem = nil
        try? store.write(vault, allowNewKey: true)
        refreshReminders()
    }

    func csv() -> Data {
        func esc(_ s: String) -> String { "\"" + s.replacingOccurrences(of: "\"", with: "\"\"") + "\"" }
        func num(_ d: Decimal) -> String { Fmt.number(d, minFraction: 0, maxFraction: 6, grouping: false) }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        var lines = ["Дата;Сумма;Валюта;Категория;Заметка;Сумма в USD;Курс за 1 USD"]
        for e in vault.expenses.sorted(by: { $0.date < $1.date }) {
            lines.append([
                dateFormatter.string(from: e.date),
                num(e.amount),
                e.currency.code,
                esc(category(for: e.categoryID).name),
                esc(e.note),
                num(e.amountUSD.rounded(scale: 4)),
                num(e.rate(e.currency)),
            ].joined(separator: ";"))
        }
        // BOM, чтобы Excel открыл кириллицу правильно.
        return Data("\u{FEFF}".utf8) + Data(lines.joined(separator: "\n").utf8)
    }
}

enum AppTab: Hashable {
    case expenses, stats, settings
}
