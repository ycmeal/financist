import Foundation

/// Страна для шапки «Трат» — только те, чьи валюты есть в приложении: Турция, Узбекистан, ОАЭ, Россия,
/// Европа (евро) и США. Берётся по валюте последней траты, иначе — по часовому поясу iPhone.
/// Ни геолокация, ни интернет для этого не нужны.
struct Place: Equatable {
    let currency: Currency

    /// «Турция»; для евро — «Европа».
    var country: String {
        switch currency {
        case .usd: "США"
        case .lira: "Турция"
        case .eur: "Европа"
        case .rub: "Россия"
        case .uzs: "Узбекистан"
        case .aed: "ОАЭ"
        }
    }

    /// Код для картинки и флага: «TR»; для евро — «EU».
    var code: String {
        switch currency {
        case .usd: "US"
        case .lira: "TR"
        case .eur: "EU"
        case .rub: "RU"
        case .uzs: "UZ"
        case .aed: "AE"
        }
    }

    static func from(timeZone: TimeZone) -> Place? {
        zones.first { $0.value.contains(timeZone.identifier) }.map { Place(currency: $0.key) }
    }

    /// Страна по валюте траты. Доллар — не страна: им платят везде.
    static func spent(in currency: Currency) -> Place? {
        currency == .usd ? nil : Place(currency: currency)
    }

    /// Где тратили в последний раз — по самой поздней трате не в долларах.
    static func lastSpent(in expenses: [Expense]) -> Place? {
        expenses.filter { $0.currency != .usd }.max { $0.date < $1.date }.flatMap { spent(in: $0.currency) }
    }

    /// Часовые пояса этих стран; для евро — вся еврозона.
    static let zones: [Currency: [String]] = [
        .lira: ["Europe/Istanbul", "Asia/Istanbul"],
        .uzs: ["Asia/Tashkent", "Asia/Samarkand"],
        .aed: ["Asia/Dubai"],
        .rub: ["Europe/Moscow", "Europe/Kaliningrad", "Europe/Samara", "Europe/Volgograd", "Europe/Saratov",
               "Europe/Ulyanovsk", "Europe/Astrakhan", "Europe/Kirov", "Asia/Yekaterinburg", "Asia/Omsk",
               "Asia/Novosibirsk", "Asia/Barnaul", "Asia/Tomsk", "Asia/Novokuznetsk", "Asia/Krasnoyarsk",
               "Asia/Irkutsk", "Asia/Chita", "Asia/Yakutsk", "Asia/Khandyga", "Asia/Vladivostok", "Asia/Ust-Nera",
               "Asia/Magadan", "Asia/Sakhalin", "Asia/Srednekolymsk", "Asia/Kamchatka", "Asia/Anadyr"],
        .eur: ["Europe/Berlin", "Europe/Paris", "Europe/Rome", "Europe/Madrid", "Atlantic/Canary", "Europe/Lisbon",
               "Europe/Athens", "Asia/Nicosia", "Asia/Famagusta", "Europe/Nicosia", "Europe/Vienna", "Europe/Amsterdam",
               "Europe/Brussels", "Europe/Luxembourg", "Europe/Dublin", "Europe/Helsinki", "Europe/Tallinn",
               "Europe/Riga", "Europe/Vilnius", "Europe/Bratislava", "Europe/Ljubljana", "Europe/Zagreb",
               "Europe/Podgorica", "Europe/Malta"],
        .usd: ["America/New_York", "America/Chicago", "America/Denver", "America/Phoenix", "America/Los_Angeles",
               "America/Anchorage", "Pacific/Honolulu", "America/Detroit", "America/Indiana/Indianapolis",
               "America/Boise"],
    ]
}

/// Время суток — для неба в шапке «Трат»: рассвет, день, закат, ночь.
enum DayPart: Equatable {
    case dawn, day, dusk, night

    init(_ date: Date, calendar: Calendar = .current) {
        switch calendar.component(.hour, from: date) {
        case 5..<8: self = .dawn
        case 8..<17: self = .day
        case 17..<21: self = .dusk
        default: self = .night
        }
    }

    /// Где солнце на дуге: 0 — 6:00, 1 — 20:00. В остальное время его нет — на небе луна.
    static func sunProgress(_ date: Date, calendar: Calendar = .current) -> Double? {
        let c = calendar.dateComponents([.hour, .minute], from: date)
        let minutes = Double((c.hour ?? 0) * 60 + (c.minute ?? 0))
        guard (360...1200).contains(minutes) else { return nil }
        return (minutes - 360) / 840
    }
}
