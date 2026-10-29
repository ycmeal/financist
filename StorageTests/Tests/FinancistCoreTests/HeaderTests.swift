import Foundation
import XCTest
@testable import FinancistCore

/// The «Траты» header: the country of the last spending, and the next place of it on every entry into the app.
final class HeaderTests: XCTestCase {
    private var root: URL!
    private let visitKey = "header.visit"

    override func setUp() {
        super.setUp()
        root = FileManager.default.temporaryDirectory.appendingPathComponent("header-\(UUID().uuidString)", isDirectory: true)
        TestEnvironment.directory = root.appendingPathComponent("Financist", isDirectory: true)
        KeyStore.stored = nil
        KeyStore.mode = .normal
        UIApplication.shared.isProtectedDataAvailable = true
        RatesService.reset()
        UserDefaults.standard.removeObject(forKey: visitKey)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: root)
        UserDefaults.standard.removeObject(forKey: visitKey)
        super.tearDown()
    }

    @MainActor
    private func launch() -> AppStore {
        let store = AppStore()
        store.loadIfNeeded()
        return store
    }

    @MainActor
    private func spend(_ store: AppStore, _ currency: Currency, hoursAgo: Double) {
        let category = store.vault.categories.first { $0.name == "Продукты" }!
        store.upsert(Expense(date: Date.now.addingTimeInterval(-hoursAgo * 3600), amount: 10, currency: currency,
                             categoryID: category.id, note: "", rates: store.vault.rates.effective))
    }

    @MainActor
    func testEveryEntryCountsAndIsRemembered() async throws {
        let store = launch()
        XCTAssertEqual(store.headerVisit, 0)
        store.countVisit()
        store.countVisit()
        XCTAssertEqual(store.headerVisit, 2)
        XCTAssertNotEqual(PixelCity.scene(for: "TR", visit: 1), PixelCity.scene(for: "TR", visit: 2))
        XCTAssertEqual(launch().headerVisit, 2, "The next launch goes on from the same count")
    }

    @MainActor
    func testCountryFollowsTheLastSpending() async throws {
        let store = launch()
        spend(store, .lira, hoursAgo: 3)
        XCTAssertEqual(store.headerPlace, Place(currency: .lira))
        spend(store, .usd, hoursAgo: 2)
        XCTAssertEqual(store.headerPlace?.code, "TR", "Dollars are spent everywhere")
        spend(store, .uzs, hoursAgo: 1)
        XCTAssertEqual(store.headerPlace?.country, "Узбекистан")
    }
}
