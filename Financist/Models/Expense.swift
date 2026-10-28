import Foundation

struct Expense: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var amount: Decimal
    var currency: Currency
    var categoryID: UUID
    var note: String
    /// Снимок курсов на момент траты (единиц валюты за 1 USDT),
    /// чтобы старые траты пересчитывались по тогдашнему курсу.
    var rates: [Currency: Decimal]

    func rate(_ currency: Currency) -> Decimal {
        if currency == .usdt { return 1 }
        return rates[currency] ?? Currency.fallbackPerUSDT[currency] ?? 1
    }

    var amountUSDT: Decimal { amount / rate(currency) }

    func amount(in target: Currency) -> Decimal {
        target == currency ? amount : amountUSDT * rate(target)
    }
}

/// Текущие курсы: автоматически загруженные + ручные правки.
struct RateTable: Codable, Hashable {
    var fetched: [Currency: Decimal] = Currency.fallbackPerUSDT
    var manual: [Currency: Decimal] = [:]
    var updatedAt: Date?

    func rate(_ currency: Currency) -> Decimal {
        if currency == .usdt { return 1 }
        return manual[currency] ?? fetched[currency] ?? Currency.fallbackPerUSDT[currency] ?? 1
    }

    var effective: [Currency: Decimal] {
        Dictionary(uniqueKeysWithValues: Currency.allCases.map { ($0, rate($0)) })
    }

    func convert(_ amount: Decimal, from: Currency, to: Currency) -> Decimal {
        from == to ? amount : amount / rate(from) * rate(to)
    }
}

/// Всё, что хранит приложение. Целиком шифруется и пишется в один файл.
struct Vault: Codable {
    var expenses: [Expense] = []
    var categories: [ExpenseCategory] = ExpenseCategory.defaults
    var rates = RateTable()
    /// Последняя выбранная при вводе валюта — подставляется в новую трату.
    var inputCurrency: Currency = .usdt
    /// Недавние валюты ввода (первая — самая свежая), показываются кнопками.
    var recentCurrencies: [Currency] = [.usdt, .lira]
    var displayCurrency: Currency = .usdt
    var lockEnabled = false
    var autoUpdateRates = true

    init() {}

    // Новые поля добавлять через decodeIfPresent, чтобы старые файлы читались.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        expenses = try c.decodeIfPresent([Expense].self, forKey: .expenses) ?? []
        categories = try c.decodeIfPresent([ExpenseCategory].self, forKey: .categories) ?? ExpenseCategory.defaults
        rates = try c.decodeIfPresent(RateTable.self, forKey: .rates) ?? RateTable()
        inputCurrency = try c.decodeIfPresent(Currency.self, forKey: .inputCurrency) ?? .usdt
        recentCurrencies = try c.decodeIfPresent([Currency].self, forKey: .recentCurrencies) ?? [.usdt, .lira]
        displayCurrency = try c.decodeIfPresent(Currency.self, forKey: .displayCurrency) ?? .usdt
        lockEnabled = try c.decodeIfPresent(Bool.self, forKey: .lockEnabled) ?? false
        autoUpdateRates = try c.decodeIfPresent(Bool.self, forKey: .autoUpdateRates) ?? true
    }
}
