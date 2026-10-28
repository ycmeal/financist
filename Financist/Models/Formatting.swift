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

enum Fmt {
    private static var cache: [String: NumberFormatter] = [:]

    static func number(_ value: Decimal, minFraction: Int, maxFraction: Int, grouping: Bool = true) -> String {
        let key = "\(minFraction)-\(maxFraction)-\(grouping)"
        let formatter: NumberFormatter
        if let cached = cache[key] {
            formatter = cached
        } else {
            formatter = NumberFormatter()
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

    static func dayTitle(_ day: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(day) { return "Сегодня" }
        if calendar.isDateInYesterday(day) { return "Вчера" }
        if calendar.isDate(day, equalTo: .now, toGranularity: .year) {
            return day.formatted(.dateTime.weekday(.abbreviated).day().month(.wide))
        }
        return day.formatted(.dateTime.day().month(.wide).year())
    }
}
