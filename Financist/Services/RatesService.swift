import Foundation

/// Курсы к 1 USD с open.er-api.com. Это единственный сетевой запрос приложения,
/// в нём нет никаких данных пользователя — только публичный URL.
enum RatesService {
    private static let url = URL(string: "https://open.er-api.com/v6/latest/USD")!

    private struct Response: Decodable {
        let result: String
        let rates: [String: Double]
    }

    static func fetch() async throws -> [Currency: Decimal] {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        let (data, _) = try await URLSession(configuration: .ephemeral).data(for: request)
        let response = try JSONDecoder().decode(Response.self, from: data)
        guard response.result == "success" else { throw URLError(.badServerResponse) }

        var result: [Currency: Decimal] = [.usd: 1]
        for currency in Currency.allCases where currency != .usd {
            if let perUSD = response.rates[currency.code], perUSD > 0 {
                result[currency] = Decimal(perUSD).rounded(scale: 6)
            }
        }
        return result
    }
}
