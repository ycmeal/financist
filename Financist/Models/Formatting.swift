import Foundation

extension Decimal {
    var doubleValue: Double { NSDecimalNumber(decimal: self).doubleValue }

    func rounded(scale: Int) -> Decimal {
        var value = self
        var result = Decimal()
        NSDecimalRound(&result, &value, scale, .plain)
        return result
    }

    /// Разбирает ввод пользователя: допускает и запятую, и точку, пробелы игнорирует.
    static func parse(_ text: String) -> Decimal? {
        let cleaned = text
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\u{00A0}", with: "")
            .replacingOccurrences(of: ",", with: ".")
        guard !cleaned.isEmpty, cleaned != ".",
              cleaned.range(of: #"^\d*\.?\d*$"#, options: .regularExpression) != nil
        else { return nil }
        return Decimal(string: cleaned, locale: Locale(identifier: "en_US_POSIX"))
    }

    /// Строка для подстановки в текстовое поле (без разделителей тысяч).
    var inputString: String {
        Fmt.number(self, minFraction: 0, maxFraction: 6, grouping: false)
    }
}

extension Sequence where Element == Expense {
    func total(in currency: Currency) -> Decimal {
        reduce(Decimal(0)) { $0 + $1.amount(in: currency) }
    }
}

enum Fmt {
    private static var cache: [String: NumberFormatter] = [:]

    static func number(_ value: Decimal, minFraction: Int, maxFraction: Int, grouping: Bool = true) -> String {
        let key = "\(minFraction)-\(maxFraction)-\(grouping)"
        let formatter: NumberFormatter
        if let cached = cache[key] {
            formatter = cached
        } else {
            formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = minFraction
            formatter.maximumFractionDigits = maxFraction
            formatter.usesGroupingSeparator = grouping
            cache[key] = formatter
        }
        return formatter.string(from: value as NSDecimalNumber) ?? "\(value)"
    }

    /// Курс: мелкие числа с 4 знаками (0,8612), крупные — с 2.
    static func rate(_ value: Decimal) -> String {
        number(value, minFraction: 0, maxFraction: value < 10 ? 4 : 2)
    }

    static func percent(_ share: Double) -> String {
        "\(Int((share * 100).rounded()))%"
    }

    /// Русское склонение: plural(3, "раз", "раза", "раз").
    static func plural(_ n: Int, _ one: String, _ few: String, _ many: String) -> String {
        let mod10 = n % 10, mod100 = n % 100
        if mod10 == 1 && mod100 != 11 { return one }
        if (2...4).contains(mod10) && !(12...14).contains(mod100) { return few }
        return many
    }

    static func count(_ n: Int, _ one: String, _ few: String, _ many: String) -> String {
        "\(n) \(plural(n, one, few, many))"
    }
}

/// Даты всегда по-русски, независимо от региона телефона.
enum RuDate {
    static let monthsNominative = ["январь", "февраль", "март", "апрель", "май", "июнь",
                                   "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"]
    static let monthsGenitive = ["января", "февраля", "марта", "апреля", "мая", "июня",
                                 "июля", "августа", "сентября", "октября", "ноября", "декабря"]
    /// Индекс как у Calendar.weekday: 1 — воскресенье.
    static let weekdaysShort = ["", "Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
    static let weekdays = ["", "воскресенье", "понедельник", "вторник", "среда", "четверг", "пятница", "суббота"]
    static let weekdaysDative = ["", "воскресеньям", "понедельникам", "вторникам", "средам",
                                 "четвергам", "пятницам", "субботам"]

    private static var calendar: Calendar { .current }

    /// «Октябрь 2026» (год опускается для текущего).
    static func month(_ date: Date, alwaysYear: Bool = false) -> String {
        let c = calendar.dateComponents([.year, .month], from: date)
        let name = monthsNominative[(c.month ?? 1) - 1].capitalized
        let sameYear = calendar.isDate(date, equalTo: .now, toGranularity: .year)
        return sameYear && !alwaysYear ? name : "\(name) \(c.year ?? 0)"
    }

    static func monthNominative(_ date: Date) -> String {
        monthsNominative[(calendar.component(.month, from: date)) - 1]
    }

    static func monthGenitive(_ date: Date) -> String {
        monthsGenitive[(calendar.component(.month, from: date)) - 1]
    }

    static let monthsPrepositional = ["январе", "феврале", "марте", "апреле", "мае", "июне",
                                      "июле", "августе", "сентябре", "октябре", "ноябре", "декабре"]

    /// «октябре» — для «в октябре».
    static func monthPrepositional(_ date: Date) -> String {
        monthsPrepositional[(calendar.component(.month, from: date)) - 1]
    }

    /// «28 октября»
    static func day(_ date: Date) -> String {
        "\(calendar.component(.day, from: date)) \(monthGenitive(date))"
    }

    /// «Сегодня», «Вчера», «Пн, 26 октября», «3 марта 2025»
    static func dayTitle(_ date: Date) -> String {
        if calendar.isDateInToday(date) { return "Сегодня" }
        if calendar.isDateInYesterday(date) { return "Вчера" }
        if calendar.isDate(date, equalTo: .now, toGranularity: .year) {
            return "\(weekdaysShort[calendar.component(.weekday, from: date)]), \(day(date))"
        }
        return "\(day(date)) \(calendar.component(.year, from: date))"
    }

    /// «Среда, 29 октября»
    static func weekdayAndDay(_ date: Date) -> String {
        "\(weekdays[calendar.component(.weekday, from: date)].capitalized), \(day(date))"
    }

    static func time(_ date: Date) -> String {
        let c = calendar.dateComponents([.hour, .minute], from: date)
        return String(format: "%d:%02d", c.hour ?? 0, c.minute ?? 0)
    }

    static func greeting(_ date: Date = .now) -> String {
        switch calendar.component(.hour, from: date) {
        case 5..<12: "Доброе утро"
        case 12..<18: "Добрый день"
        case 18..<23: "Добрый вечер"
        default: "Доброй ночи"
        }
    }
}
