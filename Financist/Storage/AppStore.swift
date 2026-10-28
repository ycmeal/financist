import Foundation
import Observation

@Observable
@MainActor
final class AppStore {
    private(set) var vault = Vault()
    var loadError: String?
    var saveError: String?
    var ratesError: String?
    private(set) var isRefreshingRates = false

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

    // MARK: Настройки

    var displayCurrency: Currency {
        get { vault.displayCurrency }
        set { vault.displayCurrency = newValue; persist() }
    }

    var inputCurrency: Currency {
        get { vault.inputCurrency }
        set { vault.inputCurrency = newValue; persist() }
    }

    var lockEnabled: Bool {
        get { vault.lockEnabled }
        set { vault.lockEnabled = newValue; persist() }
    }

    // MARK: Траты

    func upsert(_ expense: Expense) {
        if let index = vault.expenses.firstIndex(where: { $0.id == expense.id }) {
            vault.expenses[index] = expense
        } else {
            vault.expenses.append(expense)
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
        let fallback: ExpenseCategory
        if let other = vault.categories.first(where: { $0.name == ExpenseCategory.otherName }) {
            fallback = other
        } else if vault.expenses.contains(where: { removing.contains($0.categoryID) }) {
            fallback = ExpenseCategory.defaults.last!
            vault.categories.append(fallback)
        } else {
            persist()
            return
        }
        for index in vault.expenses.indices where removing.contains(vault.expenses[index].categoryID) {
            vault.expenses[index].categoryID = fallback.id
        }
        persist()
    }

    func expenseCount(in categoryID: UUID) -> Int {
        vault.expenses.filter { $0.categoryID == categoryID }.count
    }

    // MARK: Курсы

    func refreshRates(force: Bool) async {
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
            ratesError = "Не удалось обновить курсы. Проверь интернет."
        }
    }

    func setManualRate(_ rate: Decimal?, for currency: Currency) {
        vault.rates.manual[currency] = rate
        persist()
    }

    // MARK: Данные

    func backup(password: String) throws -> Data {
        try BackupCrypto.encrypt(vault, password: password)
    }

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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        func esc(_ s: String) -> String { "\"" + s.replacingOccurrences(of: "\"", with: "\"\"") + "\"" }
        func num(_ d: Decimal) -> String { Fmt.number(d, minFraction: 0, maxFraction: 6, grouping: false) }

        var lines = ["Дата;Сумма;Валюта;Категория;Заметка;Сумма в USDT;Курс за 1 USDT"]
        for e in vault.expenses.sorted(by: { $0.date < $1.date }) {
            lines.append([
                dateFormatter.string(from: e.date),
                num(e.amount),
                e.currency.code,
                esc(category(for: e.categoryID).name),
                esc(e.note),
                num(e.amountUSDT.rounded(scale: 4)),
                num(e.rate(e.currency)),
            ].joined(separator: ";"))
        }
        // BOM, чтобы Excel открыл кириллицу правильно.
        return Data("\u{FEFF}".utf8) + Data(lines.joined(separator: "\n").utf8)
    }
}
