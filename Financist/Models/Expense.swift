import Foundation

struct Expense: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var amount: Decimal
    var currency: Currency
    var categoryID: UUID
    var note: String
    /// Снимок курсов на момент траты (единиц валюты за 1 USD),
    /// чтобы старые траты пересчитывались по тогдашнему курсу.
    var rates: [Currency: Decimal]
    /// Если трата записана из регулярного платежа — его id.
    var recurringID: UUID?

    func rate(_ currency: Currency) -> Decimal {
        if currency == .base { return 1 }
        return rates[currency] ?? Currency.fallbackPerUSD[currency] ?? 1
    }

    var amountUSD: Decimal { amount / rate(currency) }

    func amount(in target: Currency) -> Decimal {
        target == currency ? amount : amountUSD * rate(target)
    }
}

/// Текущие курсы: автоматически загруженные + ручные правки.
struct RateTable: Codable, Hashable {
    var fetched: [Currency: Decimal] = Currency.fallbackPerUSD
    var manual: [Currency: Decimal] = [:]
    var updatedAt: Date?

    func rate(_ currency: Currency) -> Decimal {
        if currency == .base { return 1 }
        return manual[currency] ?? fetched[currency] ?? Currency.fallbackPerUSD[currency] ?? 1
    }

    var effective: [Currency: Decimal] {
        Dictionary(uniqueKeysWithValues: Currency.allCases.map { ($0, rate($0)) })
    }

    func convert(_ amount: Decimal, from: Currency, to: Currency) -> Decimal {
        from == to ? amount : amount / rate(from) * rate(to)
    }
}

/// Регулярный платёж: аренда, связь, подписки. В нужный день появляется
/// карточка «Пора оплатить» — одно касание, и трата записана.
struct RecurringPayment: Identifiable, Codable, Hashable {
    var id = UUID()
    var note: String
    var amount: Decimal
    var currency: Currency
    var categoryID: UUID
    /// День месяца, 1–28.
    var day: Int
}

/// Бюджет на месяц в выбранной валюте.
struct MonthlyBudget: Codable, Hashable {
    var amount: Decimal
    var currency: Currency
}

/// Всё, что хранит приложение. Целиком шифруется и пишется в один файл.
struct Vault: Codable {
    var expenses: [Expense] = []
    var categories: [ExpenseCategory] = ExpenseCategory.defaults
    var rates = RateTable()
    /// Последняя выбранная при вводе валюта — подставляется в новую трату.
    var inputCurrency: Currency = .lira
    /// Недавние валюты ввода (первая — самая свежая), показываются кнопками.
    var recentCurrencies: [Currency] = [.lira, .usd]
    var displayCurrency: Currency = .usd
    var lockEnabled = false
    var autoUpdateRates = true
    var budget: MonthlyBudget?
    var recurring: [RecurringPayment] = []
    /// Пропущенные в этом месяце регулярные платежи: "<id>|<год>-<месяц>".
    var skippedRecurring: [String] = []
    var eveningReminder = false

    init() {}

    // Новые поля добавлять через decodeIfPresent, чтобы старые файлы читались.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        expenses = try c.decodeIfPresent([Expense].self, forKey: .expenses) ?? []
        categories = try c.decodeIfPresent([ExpenseCategory].self, forKey: .categories) ?? ExpenseCategory.defaults
        rates = try c.decodeIfPresent(RateTable.self, forKey: .rates) ?? RateTable()
        inputCurrency = try c.decodeIfPresent(Currency.self, forKey: .inputCurrency) ?? .lira
        recentCurrencies = try c.decodeIfPresent([Currency].self, forKey: .recentCurrencies) ?? [.lira, .usd]
        displayCurrency = try c.decodeIfPresent(Currency.self, forKey: .displayCurrency) ?? .usd
        lockEnabled = try c.decodeIfPresent(Bool.self, forKey: .lockEnabled) ?? false
        autoUpdateRates = try c.decodeIfPresent(Bool.self, forKey: .autoUpdateRates) ?? true
        budget = try c.decodeIfPresent(MonthlyBudget.self, forKey: .budget)
        recurring = try c.decodeIfPresent([RecurringPayment].self, forKey: .recurring) ?? []
        skippedRecurring = try c.decodeIfPresent([String].self, forKey: .skippedRecurring) ?? []
        eveningReminder = try c.decodeIfPresent(Bool.self, forKey: .eveningReminder) ?? false
    }
}
