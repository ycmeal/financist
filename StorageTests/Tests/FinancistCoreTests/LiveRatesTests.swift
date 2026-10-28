import Foundation
import XCTest
@testable import FinancistCore

/// Hits the real rate sources. Runs only with LIVE_RATES=1, so normal test runs stay offline.
final class LiveRatesTests: XCTestCase {
    private var enabled: Bool { ProcessInfo.processInfo.environment["LIVE_RATES"] == "1" }

    func testLatestHasEveryCurrency() async throws {
        try XCTSkipUnless(enabled, "Set LIVE_RATES=1 to check the real sources")
        let latest = try await LiveRatesService.fetchLatest()
        for currency in Currency.allCases {
            let rate = try XCTUnwrap(latest.rates[currency], "\(currency.code) missing")
            XCTAssertGreaterThan(rate, 0)
        }
        XCTAssertEqual(latest.rates[.aed], Decimal(string: "3.6725"), "AED is pegged to USD")
        print("LIVE latest \(latest.day): TRY \(latest.rates[.lira]!), UZS \(latest.rates[.uzs]!)")
    }

    func testPastDayReturnsThatDay() async throws {
        try XCTSkipUnless(enabled, "Set LIVE_RATES=1 to check the real sources")
        let day = RateDay.key(Date.now.addingTimeInterval(-10 * 86_400))
        let past = try await LiveRatesService.fetch(day: day)
        XCTAssertEqual(past.day, day)
        XCTAssertEqual(past.rates.count, Currency.allCases.count)
        print("LIVE \(past.day): TRY \(past.rates[.lira]!)")
    }

    func testMissingDayFailsInsteadOfReturningAnotherDay() async throws {
        try XCTSkipUnless(enabled, "Set LIVE_RATES=1 to check the real sources")
        let future = RateDay.key(Date.now.addingTimeInterval(30 * 86_400))
        do {
            _ = try await LiveRatesService.fetch(day: future)
            XCTFail("A day without data must not be accepted")
        } catch {}
    }
}
