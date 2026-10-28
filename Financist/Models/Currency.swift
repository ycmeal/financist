import Foundation

/// Валюты приложения. Все курсы хранятся как «сколько единиц валюты за 1 USDT».
enum Currency: String, Codable, CaseIterable, Identifiable, Hashable, CodingKeyRepresentable {
    case usdt = "USDT"
    case lira = "TRY"
    case usd = "USD"
    case eur = "EUR"
    case rub = "RUB"
    case uzs = "UZS"
    case aed = "AED"

    var id: String { rawValue }
    var code: String { rawValue }

    var name: String {
        switch self {
        case .usdt: "Tether"
        case .lira: "Турецкая лира"
        case .usd: "Доллар США"
        case .eur: "Евро"
        case .rub: "Российский рубль"
        case .uzs: "Узбекский сум"
        case .aed: "Дирхам ОАЭ"
        }
    }

    var flag: String {
        switch self {
        case .usdt: "💠"
        case .lira: "🇹🇷"
        case .usd: "🇺🇸"
        case .eur: "🇪🇺"
        case .rub: "🇷🇺"
        case .uzs: "🇺🇿"
        case .aed: "🇦🇪"
        }
    }

    var symbol: String {
        switch self {
        case .usdt: "USDT"
        case .lira: "₺"
        case .usd: "$"
        case .eur: "€"
        case .rub: "₽"
        case .uzs: "сум"
        case .aed: "AED"
        }
    }

    /// Для статистики «где тратили».
    var placeName: String {
        switch self {
        case .usdt: "В USDT"
        case .lira: "Турция"
        case .usd: "В долларах"
        case .eur: "Европа"
        case .rub: "Россия"
        case .uzs: "Узбекистан"
        case .aed: "ОАЭ"
        }
    }

    var fractionDigits: Int { self == .uzs ? 0 : 2 }

    /// Примерные курсы на случай, если интернета ещё не было ни разу.
    static let fallbackPerUSDT: [Currency: Decimal] = [
        .usdt: 1,
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
