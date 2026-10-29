import Foundation

/// Страна для шапки «Трат» — по часовому поясу iPhone. В поездке iOS сам переводит часы,
/// поэтому приложению не нужны ни геолокация, ни интернет.
struct Place: Equatable {
    let country: String
    /// Двухбуквенный код страны: «TR».
    let code: String
    /// Местная валюта, если она есть в приложении.
    let currency: Currency?

    var flag: String { Self.flag(code) }

    static func from(timeZone: TimeZone) -> Place? {
        byZone[timeZone.identifier]
    }

    /// Если страны нет в списке — город из названия пояса: «America/Sao_Paulo» → «Sao Paulo».
    static func city(of timeZone: TimeZone) -> String {
        let last = timeZone.identifier.split(separator: "/").last.map(String.init) ?? timeZone.identifier
        return last.replacingOccurrences(of: "_", with: " ")
    }

    /// Флаг из кода страны: «TR» → 🇹🇷.
    static func flag(_ code: String) -> String {
        String(String.UnicodeScalarView(code.uppercased().unicodeScalars.compactMap { Unicode.Scalar(127_397 + $0.value) }))
    }

    private static let byZone: [String: Place] = {
        var result: [String: Place] = [:]
        for (country, code, currency, zones) in countries {
            for zone in zones { result[zone] = Place(country: country, code: code, currency: currency) }
        }
        return result
    }()

    /// Страны, где отец бывает или может оказаться, и их часовые пояса.
    static let countries: [(String, String, Currency?, [String])] = [
        ("Турция", "TR", .lira, ["Europe/Istanbul", "Asia/Istanbul"]),
        ("Узбекистан", "UZ", .uzs, ["Asia/Tashkent", "Asia/Samarkand"]),
        ("ОАЭ", "AE", .aed, ["Asia/Dubai"]),
        ("Россия", "RU", .rub, ["Europe/Moscow", "Europe/Kaliningrad", "Europe/Samara", "Europe/Volgograd",
                                "Europe/Saratov", "Europe/Ulyanovsk", "Europe/Astrakhan", "Europe/Kirov",
                                "Asia/Yekaterinburg", "Asia/Omsk", "Asia/Novosibirsk", "Asia/Barnaul", "Asia/Tomsk",
                                "Asia/Novokuznetsk", "Asia/Krasnoyarsk", "Asia/Irkutsk", "Asia/Chita", "Asia/Yakutsk",
                                "Asia/Khandyga", "Asia/Vladivostok", "Asia/Ust-Nera", "Asia/Magadan", "Asia/Sakhalin",
                                "Asia/Srednekolymsk", "Asia/Kamchatka", "Asia/Anadyr"]),
        ("США", "US", .usd, ["America/New_York", "America/Chicago", "America/Denver", "America/Phoenix",
                             "America/Los_Angeles", "America/Anchorage", "Pacific/Honolulu", "America/Detroit",
                             "America/Indiana/Indianapolis", "America/Boise"]),
        ("Казахстан", "KZ", nil, ["Asia/Almaty", "Asia/Qostanay", "Asia/Aqtobe", "Asia/Aqtau", "Asia/Atyrau",
                                  "Asia/Oral", "Asia/Qyzylorda"]),
        ("Кыргызстан", "KG", nil, ["Asia/Bishkek"]),
        ("Таджикистан", "TJ", nil, ["Asia/Dushanbe"]),
        ("Туркменистан", "TM", nil, ["Asia/Ashgabat"]),
        ("Азербайджан", "AZ", nil, ["Asia/Baku"]),
        ("Грузия", "GE", nil, ["Asia/Tbilisi"]),
        ("Армения", "AM", nil, ["Asia/Yerevan"]),
        ("Беларусь", "BY", nil, ["Europe/Minsk"]),
        ("Украина", "UA", nil, ["Europe/Kyiv", "Europe/Kiev"]),
        ("Молдова", "MD", nil, ["Europe/Chisinau"]),
        ("Германия", "DE", .eur, ["Europe/Berlin"]),
        ("Франция", "FR", .eur, ["Europe/Paris"]),
        ("Италия", "IT", .eur, ["Europe/Rome"]),
        ("Испания", "ES", .eur, ["Europe/Madrid", "Atlantic/Canary"]),
        ("Португалия", "PT", .eur, ["Europe/Lisbon"]),
        ("Греция", "GR", .eur, ["Europe/Athens"]),
        ("Кипр", "CY", .eur, ["Asia/Nicosia", "Asia/Famagusta", "Europe/Nicosia"]),
        ("Австрия", "AT", .eur, ["Europe/Vienna"]),
        ("Нидерланды", "NL", .eur, ["Europe/Amsterdam"]),
        ("Бельгия", "BE", .eur, ["Europe/Brussels"]),
        ("Ирландия", "IE", .eur, ["Europe/Dublin"]),
        ("Финляндия", "FI", .eur, ["Europe/Helsinki"]),
        ("Эстония", "EE", .eur, ["Europe/Tallinn"]),
        ("Латвия", "LV", .eur, ["Europe/Riga"]),
        ("Литва", "LT", .eur, ["Europe/Vilnius"]),
        ("Словакия", "SK", .eur, ["Europe/Bratislava"]),
        ("Словения", "SI", .eur, ["Europe/Ljubljana"]),
        ("Хорватия", "HR", .eur, ["Europe/Zagreb"]),
        ("Черногория", "ME", .eur, ["Europe/Podgorica"]),
        ("Мальта", "MT", .eur, ["Europe/Malta"]),
        ("Великобритания", "GB", nil, ["Europe/London"]),
        ("Швейцария", "CH", nil, ["Europe/Zurich"]),
        ("Чехия", "CZ", nil, ["Europe/Prague"]),
        ("Польша", "PL", nil, ["Europe/Warsaw"]),
        ("Венгрия", "HU", nil, ["Europe/Budapest"]),
        ("Сербия", "RS", nil, ["Europe/Belgrade"]),
        ("Болгария", "BG", nil, ["Europe/Sofia"]),
        ("Румыния", "RO", nil, ["Europe/Bucharest"]),
        ("Швеция", "SE", nil, ["Europe/Stockholm"]),
        ("Норвегия", "NO", nil, ["Europe/Oslo"]),
        ("Дания", "DK", nil, ["Europe/Copenhagen"]),
        ("Израиль", "IL", nil, ["Asia/Jerusalem", "Asia/Tel_Aviv"]),
        ("Египет", "EG", nil, ["Africa/Cairo"]),
        ("Иордания", "JO", nil, ["Asia/Amman"]),
        ("Катар", "QA", nil, ["Asia/Qatar"]),
        ("Саудовская Аравия", "SA", nil, ["Asia/Riyadh"]),
        ("Оман", "OM", nil, ["Asia/Muscat"]),
        ("Бахрейн", "BH", nil, ["Asia/Bahrain"]),
        ("Кувейт", "KW", nil, ["Asia/Kuwait"]),
        ("Индия", "IN", nil, ["Asia/Kolkata", "Asia/Calcutta"]),
        ("Шри-Ланка", "LK", nil, ["Asia/Colombo"]),
        ("Мальдивы", "MV", nil, ["Indian/Maldives"]),
        ("Таиланд", "TH", nil, ["Asia/Bangkok"]),
        ("Вьетнам", "VN", nil, ["Asia/Ho_Chi_Minh", "Asia/Saigon"]),
        ("Индонезия", "ID", nil, ["Asia/Jakarta", "Asia/Makassar", "Asia/Jayapura", "Asia/Pontianak"]),
        ("Малайзия", "MY", nil, ["Asia/Kuala_Lumpur"]),
        ("Сингапур", "SG", nil, ["Asia/Singapore"]),
        ("Китай", "CN", nil, ["Asia/Shanghai", "Asia/Urumqi"]),
        ("Япония", "JP", nil, ["Asia/Tokyo"]),
        ("Южная Корея", "KR", nil, ["Asia/Seoul"]),
        ("Монголия", "MN", nil, ["Asia/Ulaanbaatar"]),
        ("Канада", "CA", nil, ["America/Toronto", "America/Vancouver", "America/Edmonton", "America/Winnipeg",
                               "America/Halifax", "America/St_Johns", "America/Regina"]),
        ("Мексика", "MX", nil, ["America/Mexico_City", "America/Cancun", "America/Tijuana"]),
        ("Марокко", "MA", nil, ["Africa/Casablanca"]),
        ("Тунис", "TN", nil, ["Africa/Tunis"]),
    ]
}

/// Время суток — для неба в шапке «Трат».
enum DayPart: Equatable {
    case night, morning, day, evening

    init(_ date: Date, calendar: Calendar = .current) {
        switch calendar.component(.hour, from: date) {
        case 5..<11: self = .morning
        case 11..<17: self = .day
        case 17..<22: self = .evening
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
