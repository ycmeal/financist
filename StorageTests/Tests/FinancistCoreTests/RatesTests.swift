import Foundation
import XCTest
@testable import FinancistCore

/// Every expense gets the exchange rate of its own day.
final class RatesTests: XCTestCase {
    private var root: URL!
    private let day: TimeInterval = 86_400

    override func setUp() {
        super.setUp()
        root = FileManager.default.temporaryDirectory.appendingPathComponent("rates-\(UUID().uuidString)", isDirectory: true)
        TestEnvironment.directory = root.appendingPathComponent("Financist", isDirectory: true)
        KeyStore.stored = nil
        KeyStore.mode = .normal
        UIApplication.shared.isProtectedDataAvailable = true
        RatesService.reset()
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: root)
        super.tearDown()
    }

    @MainActor
    private func launch() -> AppStore {
        let store = AppStore()
        store.loadIfNeeded()
        return store
    }

    private func rates(lira: Decimal) -> [Currency: Decimal] {
        [.usd: 1, .lira: lira, .eur: Decimal(string: "0.9")!, .rub: 80, .uzs: 12_000, .aed: Decimal(string: "3.6725")!]
    }

    /// Saves an expense the way the form does: rates of the expense's day, pending if not exact.
    @MainActor
    private func addExpense(_ store: AppStore, note: String, amount: Decimal = 100, date: Date = .now) -> Expense {
        let dayRates = store.ratesForDay(date, currency: .lira)
        let category = store.vault.categories[0].id
        let expense = Expense(date: date, amount: amount, currency: .lira, categoryID: category, note: note,
                              rates: dayRates.rates, ratesPending: !dayRates.exact)
        store.upsert(expense)
        return expense
    }

    @MainActor
    func testTodaysExpenseBeforeFirstDownloadIsCorrectedAutomatically() async throws {
        let store = launch()
        let expense = addExpense(store, note: "Migros", amount: 500)
        XCTAssertTrue(store.vault.expenses[0].ratesPending, "No rates yet: marked approximate")

        RatesService.latest = .init(day: RateDay.key(.now), rates: rates(lira: 50))
        await store.refreshRates(force: false)

        let saved = try XCTUnwrap(store.vault.expenses.first { $0.id == expense.id })
        XCTAssertFalse(saved.ratesPending)
        XCTAssertEqual(saved.rates[.lira], 50)
        XCTAssertEqual(saved.amount(in: .usd), 10)
        XCTAssertEqual(launch().vault.expenses[0].rates[.lira], 50, "Correction is saved")
    }

    @MainActor
    func testBackdatedExpenseGetsThatDaysRate() async throws {
        let store = launch()
        RatesService.latest = .init(day: RateDay.key(.now), rates: rates(lira: 50))
        await store.refreshRates(force: false)

        let threeDaysAgo = Date.now.addingTimeInterval(-3 * day)
        RatesService.byDay[RateDay.key(threeDaysAgo)] = rates(lira: 48)
        let expense = addExpense(store, note: "Doyuyo", amount: 480, date: threeDaysAgo)
        XCTAssertTrue(store.vault.expenses[0].ratesPending, "That day's rates are not known yet")

        await store.refreshRates(force: true)
        let saved = try XCTUnwrap(store.vault.expenses.first { $0.id == expense.id })
        XCTAssertFalse(saved.ratesPending)
        XCTAssertEqual(saved.rates[.lira], 48, "The rate of that day, not today's")
        XCTAssertEqual(saved.amount(in: .usd), 10)

        // A second expense on the same day is exact right away.
        let again = store.ratesForDay(threeDaysAgo, currency: .lira)
        XCTAssertTrue(again.exact)
        XCTAssertEqual(again.rates[.lira], 48)
    }

    @MainActor
    func testOfflineKeepsExpensesAndFixesRatesLater() async throws {
        let store = launch()
        RatesService.online = false
        let expense = addExpense(store, note: "Taksi")
        await store.refreshRates(force: false)
        XCTAssertNotNil(store.ratesError)
        XCTAssertTrue(store.vault.expenses[0].ratesPending)
        XCTAssertEqual(launch().vault.expenses.map(\.id), [expense.id], "The expense itself is saved regardless")

        RatesService.online = true
        RatesService.latest = .init(day: RateDay.key(.now), rates: rates(lira: 51))
        await store.refreshRates(force: true)
        XCTAssertNil(store.ratesError)
        XCTAssertFalse(store.vault.expenses[0].ratesPending)
        XCTAssertEqual(store.vault.expenses[0].rates[.lira], 51)
    }

    @MainActor
    func testRatesNotPublishedYetStayApproximateWithoutLosingAnything() async throws {
        let store = launch()
        // The service still serves yesterday as "latest"; today's file doesn't exist yet.
        let yesterday = RateDay.key(Date.now.addingTimeInterval(-day))
        RatesService.latest = .init(day: yesterday, rates: rates(lira: 49))
        let expense = addExpense(store, note: "Migros")
        await store.refreshRates(force: true)
        XCTAssertTrue(store.vault.expenses[0].ratesPending)
        XCTAssertEqual(store.vault.expenses[0].id, expense.id)
        XCTAssertTrue(RatesService.requestedDays.contains(RateDay.key(.now)))
    }

    @MainActor
    func testOwnExchangeRateWinsForToday() async throws {
        let store = launch()
        store.setManualRate(45, for: .lira)
        let today = store.ratesForDay(.now, currency: .lira)
        XCTAssertTrue(today.exact)
        XCTAssertEqual(today.rates[.lira], 45)

        RatesService.byDay[RateDay.key(Date.now.addingTimeInterval(-5 * day))] = rates(lira: 47)
        store.upsert(Expense(date: Date.now.addingTimeInterval(-5 * day), amount: 1, currency: .lira,
                             categoryID: store.vault.categories[0].id, note: "Old", rates: [:], ratesPending: true))
        await store.refreshRates(force: true)
        XCTAssertEqual(store.vault.expenses[0].rates[.lira], 47, "The exchange-office rate is only for today")
        let pastDay = store.ratesForDay(Date.now.addingTimeInterval(-5 * day), currency: .lira)
        XCTAssertEqual(pastDay.rates[.lira], 47, "A back-dated expense gets the market rate of its day")
    }

    @MainActor
    func testExpensesWithTheirOwnRateAreNeverTouched() async throws {
        let store = launch()
        let custom = Expense(date: .now, amount: 100, currency: .lira, categoryID: store.vault.categories[0].id,
                             note: "Own rate", rates: rates(lira: 40), ratesPending: false)
        store.upsert(custom)
        // Another expense is waiting for today's rates, so the correction does run.
        _ = addExpense(store, note: "Waiting")
        RatesService.latest = .init(day: RateDay.key(.now), rates: rates(lira: 50))
        await store.refreshRates(force: true)
        XCTAssertEqual(store.vault.expenses.first { $0.id == custom.id }?.rates[.lira], 40)
        XCTAssertEqual(store.vault.expenses.first { $0.note == "Waiting" }?.rates[.lira], 50)
    }

    @MainActor
    func testRateHistoryIsPrunedAndToleratesUnknownCodes() async throws {
        let store = launch()
        store.upsert(Expense(date: .now, amount: 1, currency: .usd, categoryID: store.vault.categories[0].id,
                             note: "x", rates: [:]))
        var json = String(data: try JSONEncoder().encode(store.vault), encoding: .utf8)!
        let old = RateDay.key(Date.now.addingTimeInterval(-200 * day))
        let recent = RateDay.key(Date.now.addingTimeInterval(-10 * day))
        json = json.replacingOccurrences(of: "\"rateHistory\":{}",
                                         with: "\"rateHistory\":{\"\(old)\":{\"TRY\":30},\"\(recent)\":{\"TRY\":48,\"QQQ\":2}}")
        XCTAssertTrue(json.contains(old))
        let key = try XCTUnwrap(KeyStore.existing())
        try AES.GCM.seal(Data(json.utf8), using: key).combined!.write(to: EncryptedStore().mainURL)

        let reopened = launch()
        XCTAssertEqual(reopened.vault.rateHistory[recent]?[.lira], 48)
        RatesService.latest = .init(day: RateDay.key(.now), rates: rates(lira: 50))
        await reopened.refreshRates(force: true)
        XCTAssertNil(reopened.vault.rateHistory[old], "Older than 120 days is dropped")
        XCTAssertNotNil(reopened.vault.rateHistory[recent])
    }

    func testDayKeys() {
        var components = DateComponents()
        components.year = 2026; components.month = 3; components.day = 7; components.hour = 12
        let date = Calendar(identifier: .gregorian).date(from: components)!
        XCTAssertEqual(RateDay.key(date), "2026-03-07")
    }

    func testTransferPasswordRules() {
        XCTAssertNotNil(BackupCrypto.passwordProblem("чай у", repeated: "чай у"), "Too short")
        XCTAssertNotNil(BackupCrypto.passwordProblem("12345678", repeated: "12345678"), "Digits only")
        XCTAssertNotNil(BackupCrypto.passwordProblem("чай у моря", repeated: "чай у мора"), "Typo in the repeat")
        XCTAssertNil(BackupCrypto.passwordProblem("чай у моря", repeated: "чай у моря"))
        XCTAssertNil(BackupCrypto.passwordProblem("Antalya2026", repeated: "Antalya2026"))
    }
}
