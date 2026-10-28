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

// Чтение старых и будущих файлов. В расширениях — чтобы у структур остались обычные инициализаторы.
extension Expense {
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        date = try c.decode(Date.self, forKey: .date)
        amount = try c.decode(Decimal.self, forKey: .amount)
        currency = try c.decode(Currency.self, forKey: .currency)
        categoryID = try c.decode(UUID.self, forKey: .categoryID)
        note = try c.decodeIfPresent(String.self, forKey: .note) ?? ""
        rates = try c.decodeRates(forKey: .rates) ?? [:]
        recurringID = try c.decodeIfPresent(UUID.self, forKey: .recurringID)
    }
}

extension RateTable {
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        fetched = try c.decodeRates(forKey: .fetched) ?? Currency.fallbackPerUSD
        manual = try c.decodeRates(forKey: .manual) ?? [:]
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
}

extension KeyedDecodingContainer {
    /// Курсы по кодам валют. Неизвестные коды пропускаем: без курса трата посчитается по запасному.
    func decodeRates(forKey key: Key) throws -> [Currency: Decimal]? {
        guard let raw = try decodeIfPresent([String: Decimal].self, forKey: key) else { return nil }
        var result: [Currency: Decimal] = [:]
        for (code, value) in raw {
            if let currency = Currency(code: code), value > 0 { result[currency] = value }
        }
        return result
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

/// Удалённая трата. 30 дней лежит в «Недавно удалённых», её можно вернуть.
struct DeletedExpense: Identifiable, Codable, Hashable {
    var expense: Expense
    var deletedAt: Date
    var id: UUID { expense.id }

    static let keepDays = 30
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

/// Всё, что хранит приложение. Целиком шифруется и пишется в один файл.
///
/// ПРАВИЛА ДЛЯ ОБНОВЛЕНИЙ (иначе у пользователя не откроются или потеряются данные):
/// - ЛЮБОЕ изменение сохраняемых полей (даже новое необязательное поле) — увеличить `currentSchema`.
///   Тогда более старая сборка не откроет файл и не сможет молча выбросить новые поля при сохранении,
///   а покажет «обновите приложение»;
/// - новые поля читать только через `decodeIfPresent` со значением по умолчанию;
/// - не переименовывать поля и не менять их типы; не удалять случаи у `Currency` и `Palette` —
///   старые коды переводить в новые (см. `Currency(code:)`).
struct Vault: Codable {
    /// Версия формата, которую понимает эта сборка.
    static let currentSchema = 1

    var schemaVersion = Vault.currentSchema
    var expenses: [Expense] = []
    /// «Недавно удалённые» — 30 дней.
    var trash: [DeletedExpense] = []
    var categories: [ExpenseCategory] = ExpenseCategory.defaults
    var rates = RateTable()
    /// Последняя выбранная при вводе валюта — подставляется в новую трату.
    var inputCurrency: Currency = .lira
    /// Недавние валюты ввода (первая — самая свежая), показываются кнопками.
    var recentCurrencies: [Currency] = [.lira, .usd]
    var displayCurrency: Currency = .usd
    var lockEnabled = false
    var autoUpdateRates = true
    var recurring: [RecurringPayment] = []
    /// Пропущенные в этом месяце регулярные платежи: "<id>|<год>-<месяц>".
    var skippedRecurring: [String] = []
    var eveningReminder = false
    /// Время вечернего напоминания в минутах от полуночи, не позже 21:00.
    var eveningMinutes = 20 * 60 + 30
    var palette: Palette = .sage
    /// Когда последний раз сохраняли файл переноса — чтобы мягко напомнить.
    var lastTransferFileAt: Date?

    init() {}

    // Новые поля добавлять через decodeIfPresent, чтобы старые файлы читались.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        schemaVersion = try c.decodeIfPresent(Int.self, forKey: .schemaVersion) ?? 1
        // Файл из более новой версии не открываем: иначе при сохранении пропадут поля,
        // о которых эта версия не знает.
        guard schemaVersion <= Vault.currentSchema else { throw VaultError.newerFormat }
        // Траты и категории читаем строго: если что-то не так, лучше не открыть файл
        // (он останется нетронутым), чем молча потерять траты.
        expenses = try c.decodeIfPresent([Expense].self, forKey: .expenses) ?? []
        trash = try c.decodeIfPresent([DeletedExpense].self, forKey: .trash) ?? []
        categories = try c.decodeIfPresent([ExpenseCategory].self, forKey: .categories) ?? ExpenseCategory.defaults
        rates = try c.decodeIfPresent(RateTable.self, forKey: .rates) ?? RateTable()
        inputCurrency = (try? c.decodeIfPresent(Currency.self, forKey: .inputCurrency)) ?? .lira
        recentCurrencies = (try? c.decodeIfPresent([Currency].self, forKey: .recentCurrencies)) ?? [.lira, .usd]
        displayCurrency = (try? c.decodeIfPresent(Currency.self, forKey: .displayCurrency)) ?? .usd
        lockEnabled = try c.decodeIfPresent(Bool.self, forKey: .lockEnabled) ?? false
        autoUpdateRates = try c.decodeIfPresent(Bool.self, forKey: .autoUpdateRates) ?? true
        recurring = try c.decodeIfPresent([RecurringPayment].self, forKey: .recurring) ?? []
        skippedRecurring = try c.decodeIfPresent([String].self, forKey: .skippedRecurring) ?? []
        eveningReminder = try c.decodeIfPresent(Bool.self, forKey: .eveningReminder) ?? false
        palette = (try? c.decodeIfPresent(Palette.self, forKey: .palette)) ?? .sage
        lastTransferFileAt = try c.decodeIfPresent(Date.self, forKey: .lastTransferFileAt)
        eveningMinutes = try min(21 * 60, c.decodeIfPresent(Int.self, forKey: .eveningMinutes) ?? 20 * 60 + 30)
    }
}
