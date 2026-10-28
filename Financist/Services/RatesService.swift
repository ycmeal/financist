import Foundation

/// Курсы к 1 USD на конкретный день.
/// Основной источник — открытый currency-api (два зеркала: jsDelivr и Cloudflare): у него есть и сегодняшние
/// курсы, и архив по датам, поэтому каждая трата получает курс именно своего дня. Запасной — open.er-api.com.
/// В запросах нет никаких данных пользователя: только дата.
enum RatesService {
    struct DayRates {
        /// День курсов в формате yyyy-MM-dd.
        let day: String
        let rates: [Currency: Decimal]
    }

    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.httpCookieStorage = nil
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 15
        return URLSession(configuration: configuration)
    }()

    /// Самые свежие курсы.
    static func fetchLatest() async throws -> DayRates {
        let mirrors = [
            "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json",
            "https://latest.currency-api.pages.dev/v1/currencies/usd.json",
        ]
        for mirror in mirrors {
            if let result = try? await fetchCurrencyAPI(URL(string: mirror)!) { return result }
        }
        return try await fetchOpenER()
    }

    /// Курсы на прошедший день (для трат, записанных задним числом).
    static func fetch(day: String) async throws -> DayRates {
        let mirrors = [
            "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@\(day)/v1/currencies/usd.json",
            "https://\(day).currency-api.pages.dev/v1/currencies/usd.json",
        ]
        var lastError: Error = URLError(.badServerResponse)
        for mirror in mirrors {
            guard let url = URL(string: mirror) else { continue }
            do {
                let result = try await fetchCurrencyAPI(url)
                // Если на эту дату курсов нет, сервис может отдать другой день — такой ответ не годится.
                guard result.day == day else { throw URLError(.resourceUnavailable) }
                return result
            } catch {
                lastError = error
            }
        }
        throw lastError
    }

    // MARK: Разбор ответов

    private struct CurrencyAPIResponse: Decodable {
        let date: String
        let usd: [String: Double]
    }

    private static func fetchCurrencyAPI(_ url: URL) async throws -> DayRates {
        let (data, response) = try await session.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        let decoded = try JSONDecoder().decode(CurrencyAPIResponse.self, from: data)
        return DayRates(day: decoded.date, rates: try convert { decoded.usd[$0.code.lowercased()] })
    }

    private struct OpenERResponse: Decodable {
        let result: String
        let time_last_update_unix: TimeInterval
        let rates: [String: Double]
    }

    private static func fetchOpenER() async throws -> DayRates {
        let (data, _) = try await session.data(from: URL(string: "https://open.er-api.com/v6/latest/USD")!)
        let decoded = try JSONDecoder().decode(OpenERResponse.self, from: data)
        guard decoded.result == "success" else { throw URLError(.badServerResponse) }
        let day = RateDay.key(Date(timeIntervalSince1970: decoded.time_last_update_unix), utc: true)
        return DayRates(day: day, rates: try convert { decoded.rates[$0.code] })
    }

    /// Берём только разумные значения; если какой-то валюты нет, ответ считается неполным.
    private static func convert(_ value: (Currency) -> Double?) throws -> [Currency: Decimal] {
        var result: [Currency: Decimal] = [.usd: 1]
        for currency in Currency.allCases where currency != .usd {
            guard let rate = value(currency), rate.isFinite, rate > 0 else { throw URLError(.cannotParseResponse) }
            result[currency] = Decimal(rate).rounded(scale: 6)
        }
        return result
    }
}
