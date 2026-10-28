import Foundation
import Observation
import SwiftUI

/// Файл резервной копии, который нужно восстановить (выбран в «Файлах» или пришёл по AirDrop).
struct PendingRestore: Identifiable {
    let id = UUID()
    let data: Data
}

@Observable
@MainActor
final class AppStore {
    private(set) var vault = Vault()
    var loadError: String?
    var saveError: String?
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
    /// false, если файл не удалось расшифровать — чтобы не затереть его пустыми данными.
    private var canSave = true

    init() {
        do {
            if let loaded = try store.load() { vault = loaded }
        } catch {
            loadError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            canSave = false
        }
    }

    private func persist() {
        guard canSave else { return }
        do {
            try store.save(vault)
            saveError = nil
        } catch {
            saveError = error.localizedDescription
        }
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

    func deleteExpenses(ids: [UUID]) {
        let set = Set(ids)
        vault.expenses.removeAll { set.contains($0.id) }
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

    // MARK: Бюджет

    var budget: MonthlyBudget? {
        get { vault.budget }
        set { vault.budget = newValue; persist() }
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
        set { vault.eveningReminder = newValue; persist(); Reminders.scheduleEvening(newValue) }
    }

    // MARK: Курсы

    func refreshRates(force: Bool) async {
        guard vault.autoUpdateRates else { return }
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

    /// Заменяет все данные на этом iPhone данными из файла.
    func restore(from data: Data, password: String) throws {
        var restored = try BackupCrypto.decrypt(data, password: password)
        restored.lockEnabled = vault.lockEnabled
        vault = restored
        canSave = true
        loadError = nil
        persist()
    }

    func resetAll() {
        store.wipe()
        vault = Vault()
        canSave = true
        loadError = nil
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
