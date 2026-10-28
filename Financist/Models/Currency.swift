import Foundation

/// Валюты приложения. Базовая — доллар: все курсы хранятся как «сколько единиц валюты за 1 USD».
enum Currency: String, Codable, CaseIterable, Identifiable, Hashable, CodingKeyRepresentable {
    case usd = "USD"
    case lira = "TRY"
    case eur = "EUR"
    case rub = "RUB"
    case uzs = "UZS"
    case aed = "AED"

    static let base: Currency = .usd

    /// Код из сохранённых данных. Старые коды переводим в нынешние (USDT ≈ доллар).
    init?(code: String) {
        if code == "USDT" { self = .usd; return }
        self.init(rawValue: code)
    }

    init(from decoder: Decoder) throws {
        let code = try decoder.singleValueContainer().decode(String.self)
        guard let currency = Currency(code: code) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                    debugDescription: "Неизвестная валюта \(code)"))
        }
        self = currency
    }

    var id: String { rawValue }
    var code: String { rawValue }

    var name: String {
        switch self {
        case .usd: "Доллар США"
        case .lira: "Турецкая лира"
        case .eur: "Евро"
        case .rub: "Российский рубль"
        case .uzs: "Узбекский сум"
        case .aed: "Дирхам ОАЭ"
        }
    }

    var flag: String {
        switch self {
        case .usd: "🇺🇸"
        case .lira: "🇹🇷"
        case .eur: "🇪🇺"
        case .rub: "🇷🇺"
        case .uzs: "🇺🇿"
        case .aed: "🇦🇪"
        }
    }

    var symbol: String {
        switch self {
        case .usd: "$"
        case .lira: "₺"
        case .eur: "€"
        case .rub: "₽"
        case .uzs: "сум"
        case .aed: "AED"
        }
    }

    /// Для статистики «где тратили».
    var placeName: String {
        switch self {
        case .usd: "В долларах"
        case .lira: "Турция"
        case .eur: "Европа"
        case .rub: "Россия"
        case .uzs: "Узбекистан"
        case .aed: "ОАЭ"
        }
    }

    var fractionDigits: Int { self == .uzs ? 0 : 2 }

    /// Примерные курсы на случай, если интернета ещё не было ни разу.
    static let fallbackPerUSD: [Currency: Decimal] = [
        .usd: 1,
        .eur: Decimal(string: "0.86")!,
        .lira: 42,
        .rub: 80,
        .uzs: 12_000,
        .aed: Decimal(string: "3.6725")!,
    ]

    /// «1 234,50 ₺» — целые суммы без копеек.
    func format(_ amount: Decimal) -> String {
        let isWhole = amount == amount.rounded(scale: 0)
        let digits = isWhole ? 0 : fractionDigits
        return Fmt.number(amount, minFraction: digits, maxFraction: digits) + "\u{00A0}" + symbol
    }
}
