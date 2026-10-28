import Foundation

/// Курсы к 1 USDT: фиатные курсы к доллару (open.er-api.com) × цена USDT в долларах (CoinGecko).
/// В запросах нет никаких данных пользователя — только публичные URL.
enum RatesService {
    private static let fiatURL = URL(string: "https://open.er-api.com/v6/latest/USD")!
    private static let tetherURL = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=tether&vs_currencies=usd")!

    private struct FiatResponse: Decodable {
        let result: String
        let rates: [String: Double]
    }

    private struct TetherResponse: Decodable {
        let tether: [String: Double]
    }

    static func fetch() async throws -> [Currency: Decimal] {
        let (data, _) = try await URLSession.shared.data(from: fiatURL)
        let fiat = try JSONDecoder().decode(FiatResponse.self, from: data)
        guard fiat.result == "success" else { throw URLError(.badServerResponse) }

        // Если CoinGecko недоступен, считаем 1 USDT = 1 USD.
        var usdPerUSDT = 1.0
        if let response = try? await URLSession.shared.data(from: tetherURL),
           let tether = try? JSONDecoder().decode(TetherResponse.self, from: response.0),
           let price = tether.tether["usd"], price > 0.5, price < 1.5 {
            usdPerUSDT = price
        }

        var result: [Currency: Decimal] = [.usdt: 1]
        for currency in Currency.allCases where currency != .usdt {
            let perUSD = currency == .usd ? 1.0 : fiat.rates[currency.code]
            if let perUSD, perUSD > 0 {
                result[currency] = Decimal(perUSD * usdPerUSDT).rounded(scale: 6)
            }
        }
        return result
    }
}
