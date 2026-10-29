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
    /// Курс пока примерный: курсы этого дня ещё не загружены. Как только загрузятся — пересчитается сам.
    var ratesPending = false
    /// Картой или наличными. У старых трат, регулярных платежей и подписок не указано.
    var payment: PaymentMethod?

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
        ratesPending = try c.decodeIfPresent(Bool.self, forKey: .ratesPending) ?? false
        // Незнакомый способ оплаты (из будущей версии) — просто «не указано», трата читается.
        payment = (try? c.decodeIfPresent(String.self, forKey: .payment)).flatMap { $0 }.flatMap(PaymentMethod.init(rawValue:))
    }
}

/// Чем заплатили за трату.
enum PaymentMethod: String, Codable, CaseIterable, Identifiable, Hashable {
    case card, cash

    var id: Self { self }
    /// «Картой», «Наличными» — на кнопках выбора.
    var title: String { self == .card ? "Картой" : "Наличными" }
    /// «картой», «наличными» — в строке траты.
    var phrase: String { self == .card ? "картой" : "наличными" }
    var symbol: String { self == .card ? "creditcard" : "banknote" }
}

/// Лимит трат на месяц. Хранится в своей валюте: траты в других валютах пересчитываются по их курсам.
struct MonthlyLimit: Codable, Hashable {
    var amount: Decimal
    var currency: Currency
}

/// Как идут дела с лимитом месяца: сколько потрачено, сколько осталось и сколько можно в день.
struct LimitProgress: Equatable {
    let limit: MonthlyLimit
    /// Потрачено за месяц в валюте лимита.
    let spent: Decimal
    /// Сколько дней месяца осталось, считая сегодняшний.
    let daysLeft: Int

    init(limit: MonthlyLimit, spent: Decimal, now: Date = .now, calendar: Calendar = .current) {
        self.limit = limit
        self.spent = spent
        let days = calendar.range(of: .day, in: .month, for: now)?.count ?? 30
        daysLeft = max(1, days - calendar.component(.day, from: now) + 1)
    }

    /// Доля лимита: 0,81 — потрачено 81%. Больше 1 — лимит превышен.
    var share: Double { limit.amount > 0 ? (spent / limit.amount).doubleValue : 0 }
    var remaining: Decimal { limit.amount - spent }
    var isOver: Bool { spent > limit.amount }
    /// Осталось меньше 15% — пора притормозить.
    var isNear: Bool { !isOver && share >= 0.85 }
    /// Сколько можно тратить в день до конца месяца, чтобы уложиться.
    var perDay: Decimal? { isOver ? nil : remaining / Decimal(daysLeft) }

    /// «973 из 1 200 $».
    var spentText: String {
        "\(Fmt.number(spent.rounded(scale: 0), minFraction: 0, maxFraction: 0)) из \(limit.currency.format(limit.amount))"
    }

    /// «Осталось 227 $ · примерно 15 $ в день», «Лимит превышен на 50 $».
    var statusText: String {
        let currency = limit.currency
        if isOver { return "Лимит превышен на \(currency.format((spent - limit.amount).rounded(scale: 0)))" }
        let left = "Осталось \(currency.format(remaining.rounded(scale: 0)))"
        guard let perDay, daysLeft > 1 else { return left }
        return "\(left) · примерно \(currency.format(perDay.rounded(scale: 0))) в день"
    }
}

extension Sequence where Element == Expense {
    /// Сколько заплачено картой и сколько наличными (траты без отметки не считаются).
    func totalsByPayment(in currency: Currency) -> [(method: PaymentMethod, total: Decimal)] {
        PaymentMethod.allCases.compactMap { method in
            let items = filter { $0.payment == method }
            return items.isEmpty ? nil : (method, items.total(in: currency))
        }
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
    /// Архив курсов: неизвестные коды валют пропускаем.
    func decodeRateHistory(forKey key: Key) throws -> [String: [Currency: Decimal]] {
        guard let raw = try decodeIfPresent([String: [String: Decimal]].self, forKey: key) else { return [:] }
        var result: [String: [Currency: Decimal]] = [:]
        for (day, values) in raw {
            var rates: [Currency: Decimal] = [:]
            for (code, value) in values {
                if let currency = Currency(code: code), value > 0 { rates[currency] = value }
            }
            result[day] = rates
        }
        return result
    }

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
    /// 1 — первая; 2 — архив курсов по дням и отметка «курс примерный» у трат;
    /// 3 — пробные подписки и особая категория «Подписка»; 4 — лимит на месяц и «картой / наличными» у трат.
    static let currentSchema = 4

    var schemaVersion = Vault.currentSchema
    var expenses: [Expense] = []
    /// «Недавно удалённые» — 30 дней.
    var trash: [DeletedExpense] = []
    var categories: [ExpenseCategory] = ExpenseCategory.defaults
    var rates = RateTable()
    /// Курсы по дням («2026-10-28» → курсы к 1 USD). Хранятся последние 120 дней.
    var rateHistory: [String: [Currency: Decimal]] = [:]
    /// Последняя выбранная при вводе валюта — подставляется в новую трату.
    var inputCurrency: Currency = .lira
    /// Недавние валюты ввода (первая — самая свежая), показываются кнопками.
    var recentCurrencies: [Currency] = [.lira, .usd]
    var displayCurrency: Currency = .usd
    var lockEnabled = false
    /// Больше не используется: курсы обновляются всегда. Поле оставлено, чтобы читались старые файлы.
    var autoUpdateRates = true
    var recurring: [RecurringPayment] = []
    /// Пробные подписки вместе с решениями по ним: отменённая не вернётся из старого файла переноса.
    var trials: [Trial] = []
    /// Пропущенные в этом месяце регулярные платежи: "<id>|<год>-<месяц>".
    var skippedRecurring: [String] = []
    var eveningReminder = false
    /// Время вечернего напоминания в минутах от полуночи, не позже 21:00.
    var eveningMinutes = 20 * 60 + 30
    var palette: Palette = .sage
    /// Когда последний раз сохраняли файл переноса — чтобы мягко напомнить.
    var lastTransferFileAt: Date?
    /// Лимит трат на месяц; nil — без лимита.
    var monthlyLimit: MonthlyLimit?
    /// Чем платили в последний раз — подставляется в новую трату.
    var lastPayment: PaymentMethod = .card

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
        // Курсы — не траты: если архив почему-то не читается, просто загрузим заново.
        rateHistory = (try? c.decodeRateHistory(forKey: .rateHistory)) ?? [:]
        inputCurrency = (try? c.decodeIfPresent(Currency.self, forKey: .inputCurrency)) ?? .lira
        recentCurrencies = (try? c.decodeIfPresent([Currency].self, forKey: .recentCurrencies)) ?? [.lira, .usd]
        displayCurrency = (try? c.decodeIfPresent(Currency.self, forKey: .displayCurrency)) ?? .usd
        lockEnabled = try c.decodeIfPresent(Bool.self, forKey: .lockEnabled) ?? false
        autoUpdateRates = try c.decodeIfPresent(Bool.self, forKey: .autoUpdateRates) ?? true
        recurring = try c.decodeIfPresent([RecurringPayment].self, forKey: .recurring) ?? []
        trials = try c.decodeIfPresent([Trial].self, forKey: .trials) ?? []
        skippedRecurring = try c.decodeIfPresent([String].self, forKey: .skippedRecurring) ?? []
        eveningReminder = try c.decodeIfPresent(Bool.self, forKey: .eveningReminder) ?? false
        palette = (try? c.decodeIfPresent(Palette.self, forKey: .palette)) ?? .sage
        lastTransferFileAt = try c.decodeIfPresent(Date.self, forKey: .lastTransferFileAt)
        eveningMinutes = try min(21 * 60, c.decodeIfPresent(Int.self, forKey: .eveningMinutes) ?? 20 * 60 + 30)
        // Лимит и способ оплаты — настройки: если не читаются, просто без них.
        monthlyLimit = (try? c.decodeIfPresent(MonthlyLimit.self, forKey: .monthlyLimit)).flatMap { $0 }
            .flatMap { $0.amount > 0 ? $0 : nil }
        lastPayment = (try? c.decodeIfPresent(PaymentMethod.self, forKey: .lastPayment)).flatMap { $0 } ?? .card
    }
}
