import Foundation
import XCTest
@testable import FinancistCore

/// Лимит на месяц и «картой / наличными»: сохраняются, старые файлы читаются, перенос ничего не затирает.
final class LimitAndPaymentTests: XCTestCase {
    private var root: URL!

    override func setUp() {
        super.setUp()
        root = FileManager.default.temporaryDirectory.appendingPathComponent("limit-\(UUID().uuidString)", isDirectory: true)
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

    private func date(_ text: String) -> Date {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f.date(from: text)!
    }

    // MARK: Сохранение

    @MainActor
    func testLimitAndPaymentAreSavedAndTheLastPaymentIsRemembered() async throws {
        let store = launch()
        XCTAssertNil(store.monthlyLimit)
        XCTAssertEqual(store.lastPayment, .card, "Card until told otherwise")
        store.monthlyLimit = MonthlyLimit(amount: 30_000, currency: .lira)
        let groceries = try XCTUnwrap(store.vault.categories.first { $0.name == "Продукты" })
        store.addExpense(amount: 450, currency: .lira, categoryID: groceries.id, note: "Pazar", date: .now, payment: .cash)
        XCTAssertEqual(store.lastPayment, .cash)

        let reopened = launch()
        XCTAssertEqual(reopened.monthlyLimit, MonthlyLimit(amount: 30_000, currency: .lira))
        XCTAssertEqual(reopened.vault.expenses.first?.payment, .cash)
        XCTAssertEqual(reopened.lastPayment, .cash)
        XCTAssertEqual(reopened.vault.schemaVersion, 4)

        reopened.monthlyLimit = MonthlyLimit(amount: 0, currency: .lira)
        XCTAssertNil(reopened.monthlyLimit, "Zero means no limit")
        XCTAssertNil(launch().monthlyLimit)
    }

    func testOldExpensesHaveNoPaymentAndUnknownValuesDoNotBreakTheFile() throws {
        let category = UUID().uuidString
        let json = """
        {"schemaVersion":3,"expenses":[
        {"id":"\(UUID().uuidString)","date":800000000,"amount":10,"currency":"TRY","categoryID":"\(category)","note":"Old","rates":{}},
        {"id":"\(UUID().uuidString)","date":800000000,"amount":10,"currency":"TRY","categoryID":"\(category)","note":"Odd","rates":{},
         "payment":"crypto"}],
        "monthlyLimit":{"amount":-5,"currency":"TRY"},"lastPayment":"barter"}
        """
        let vault = try JSONDecoder().decode(Vault.self, from: Data(json.utf8))
        XCTAssertEqual(vault.expenses.count, 2, "Nothing lost")
        XCTAssertEqual(vault.expenses.map(\.payment), [nil, nil])
        XCTAssertNil(vault.monthlyLimit, "A broken limit is just no limit")
        XCTAssertEqual(vault.lastPayment, .card)

        var bad = Vault()
        bad.schemaVersion = Vault.currentSchema + 1
        let newer = String(data: try JSONEncoder().encode(bad), encoding: .utf8)!
            .replacingOccurrences(of: "\"schemaVersion\":\(Vault.currentSchema)", with: "\"schemaVersion\":\(Vault.currentSchema + 1)")
        XCTAssertThrowsError(try JSONDecoder().decode(Vault.self, from: Data(newer.utf8)), "A newer file is never opened")
    }

    func testTransferKeepsThisPhonesLimitAndBringsOneIfThereIsNone() {
        var here = Vault()
        here.expenses = [Expense(date: .now, amount: 1, currency: .lira, categoryID: here.categories[0].id, note: "A", rates: [:])]
        var other = Vault()
        other.monthlyLimit = MonthlyLimit(amount: 500, currency: .usd)
        other.expenses = [Expense(date: .now, amount: 2, currency: .lira, categoryID: other.categories[0].id, note: "B", rates: [:],
                                  payment: .cash)]

        var withoutLimit = here
        _ = withoutLimit.merge(other)
        XCTAssertEqual(withoutLimit.monthlyLimit, MonthlyLimit(amount: 500, currency: .usd))
        XCTAssertEqual(withoutLimit.expenses.first { $0.note == "B" }?.payment, .cash, "Payment travels with the expense")

        var withLimit = here
        withLimit.monthlyLimit = MonthlyLimit(amount: 20_000, currency: .lira)
        _ = withLimit.merge(other)
        XCTAssertEqual(withLimit.monthlyLimit, MonthlyLimit(amount: 20_000, currency: .lira), "This phone's limit stays")
    }

    // MARK: Лимит

    func testProgressCountsWhatIsLeftAndPerDay() {
        let limit = MonthlyLimit(amount: 1200, currency: .usd)
        let now = date("2026-10-29 12:00")
        let normal = LimitProgress(limit: limit, spent: Decimal(string: "973.8")!, now: now)
        XCTAssertEqual(normal.daysLeft, 3, "29, 30 and 31 October")
        XCTAssertEqual(normal.share, 0.8115, accuracy: 0.001)
        XCTAssertFalse(normal.isNear)
        XCTAssertFalse(normal.isOver)
        XCTAssertEqual(normal.spentText, "974 из 1\u{00A0}200\u{00A0}$")
        XCTAssertEqual(normal.statusText, "Осталось 226\u{00A0}$ · примерно 75\u{00A0}$ в день")

        let near = LimitProgress(limit: limit, spent: 1100, now: now)
        XCTAssertTrue(near.isNear)

        let over = LimitProgress(limit: limit, spent: 1250, now: now)
        XCTAssertTrue(over.isOver)
        XCTAssertNil(over.perDay)
        XCTAssertEqual(over.statusText, "Лимит превышен на 50\u{00A0}$")

        let lastDay = LimitProgress(limit: limit, spent: 1000, now: date("2026-10-31 20:00"))
        XCTAssertEqual(lastDay.daysLeft, 1)
        XCTAssertEqual(lastDay.statusText, "Осталось 200\u{00A0}$", "No per-day hint on the last day")
    }

    @MainActor
    func testProgressIsCountedInTheLimitsCurrency() async throws {
        let store = launch()
        XCTAssertNil(store.limitProgress())
        let groceries = try XCTUnwrap(store.vault.categories.first { $0.name == "Продукты" })
        store.upsert(Expense(date: .now, amount: 100, currency: .usd, categoryID: groceries.id, note: "A",
                             rates: [.usd: 1, .lira: 50]))
        store.upsert(Expense(date: .now, amount: 500, currency: .lira, categoryID: groceries.id, note: "B",
                             rates: [.usd: 1, .lira: 50]))
        store.upsert(Expense(date: .now.addingTimeInterval(-62 * 86_400), amount: 999, currency: .lira, categoryID: groceries.id,
                             note: "Old month", rates: [.usd: 1, .lira: 50]))
        store.monthlyLimit = MonthlyLimit(amount: 10_000, currency: .lira)
        let progress = try XCTUnwrap(store.limitProgress())
        XCTAssertEqual(progress.spent, 5500, "100 $ = 5 000 ₺ by its own rate, plus 500 ₺; the old month is not counted")
    }

    // MARK: Недавние

    @MainActor
    func testHiddenRecentStaysHiddenUntilANewExpenseThere() async throws {
        let store = launch()
        let groceries = try XCTUnwrap(store.vault.categories.first { $0.name == "Продукты" })
        store.addExpense(amount: 10, currency: .lira, categoryID: groceries.id, note: "Pazar", date: .now.addingTimeInterval(-3600), payment: .cash)
        store.addExpense(amount: 20, currency: .lira, categoryID: groceries.id, note: "Migros", date: .now.addingTimeInterval(-60), payment: .card)
        XCTAssertEqual(store.recentTemplates.map(\.note), ["Migros", "Pazar"])

        let pazar = try XCTUnwrap(store.recentTemplates.last)
        store.hideRecent(pazar)
        XCTAssertEqual(store.recentTemplates.map(\.note), ["Migros"])
        XCTAssertEqual(store.vault.expenses.count, 2, "The expense itself stays")
        XCTAssertEqual(launch().recentTemplates.map(\.note), ["Migros"], "Remembered after relaunch")

        store.addExpense(amount: 15, currency: .lira, categoryID: groceries.id, note: "pazar", date: .now, payment: .cash)
        XCTAssertEqual(store.recentTemplates.map(\.note), ["pazar", "Migros"], "A new expense there brings it back")
    }

    @MainActor
    func testClearAllRecentsHidesEveryPlaceNotJustTheVisibleOnes() async throws {
        let store = launch()
        let groceries = try XCTUnwrap(store.vault.categories.first { $0.name == "Продукты" })
        for i in 0..<9 {
            store.addExpense(amount: 1, currency: .lira, categoryID: groceries.id, note: "Place \(i)",
                             date: .now.addingTimeInterval(Double(i - 20) * 60), payment: .card)
        }
        XCTAssertEqual(store.recentTemplates.count, 6)
        store.hideAllRecents()
        XCTAssertTrue(store.recentTemplates.isEmpty, "Older places must not slide in")
        XCTAssertEqual(store.vault.expenses.count, 9)
        store.addExpense(amount: 1, currency: .lira, categoryID: groceries.id, note: "Place 2", date: .now, payment: .card)
        XCTAssertEqual(store.recentTemplates.map(\.note), ["Place 2"])
    }

    func testHiddenRecentsTravelWithTheTransferFile() {
        var here = Vault()
        here.hiddenRecents = ["a|1": Date(timeIntervalSince1970: 100)]
        var other = Vault()
        other.hiddenRecents = ["a|1": Date(timeIntervalSince1970: 200), "b|2": Date(timeIntervalSince1970: 50)]
        _ = here.merge(other)
        XCTAssertEqual(here.hiddenRecents, ["a|1": Date(timeIntervalSince1970: 200), "b|2": Date(timeIntervalSince1970: 50)])
    }

    // MARK: Картой или наличными

    func testTotalsByPaymentSkipUnknown() {
        let id = UUID()
        let items = [
            Expense(date: .now, amount: 100, currency: .lira, categoryID: id, note: "", rates: [:], payment: .card),
            Expense(date: .now, amount: 50, currency: .lira, categoryID: id, note: "", rates: [:], payment: .cash),
            Expense(date: .now, amount: 30, currency: .lira, categoryID: id, note: "", rates: [:], payment: .cash),
            Expense(date: .now, amount: 999, currency: .lira, categoryID: id, note: "", rates: [:]),
        ]
        let totals = items.totalsByPayment(in: .lira)
        XCTAssertEqual(totals.map(\.method), [.card, .cash])
        XCTAssertEqual(totals.map(\.total), [100, 80])
        XCTAssertTrue([Expense]().totalsByPayment(in: .lira).isEmpty)
    }

    func testSuggestionRemembersHowThePlaceWasPaid() {
        let categories = ExpenseCategory.defaults
        let groceries = categories.first { $0.name == "Продукты" }!.id
        let history = [
            Expense(date: .now, amount: 10, currency: .lira, categoryID: groceries, note: "Pazar", rates: [:], payment: .cash),
            Expense(date: .now.addingTimeInterval(-86_400), amount: 10, currency: .lira, categoryID: groceries, note: "Pazar",
                    rates: [:], payment: .card),
            Expense(date: .now, amount: 10, currency: .lira, categoryID: groceries, note: "Migros", rates: [:]),
        ]
        let all = SuggestionEngine.build(expenses: history, categories: categories)
        XCTAssertEqual(SuggestionEngine.exact("пазар", in: all)?.payment, .cash, "The latest known way")
        XCTAssertNil(SuggestionEngine.exact("Migros", in: all)?.payment)
    }

    func testSearchFindsCashOrCard() {
        func found(_ query: String, _ payment: PaymentMethod?) -> Bool {
            SearchQuery(query, places: []).matches(note: "Pazar", noteKey: SuggestionEngine.key("Pazar"),
                                                   category: "Продукты", categoryKey: SuggestionEngine.key("Продукты"),
                                                   payment: payment)
        }
        XCTAssertTrue(found("нал", .cash))
        XCTAssertTrue(found("Наличными", .cash))
        XCTAssertTrue(found("картой", .card))
        XCTAssertFalse(found("нал", .card))
        XCTAssertFalse(found("нал", nil))
        XCTAssertFalse(found("ка", .card), "Too short to mean the payment")
    }

    @MainActor
    func testCSVHasThePaymentColumn() async throws {
        let store = launch()
        let groceries = try XCTUnwrap(store.vault.categories.first { $0.name == "Продукты" })
        store.addExpense(amount: 5, currency: .lira, categoryID: groceries.id, note: "Simit", date: .now, payment: .cash)
        let text = String(decoding: store.csv(), as: UTF8.self)
        let lines = text.split(separator: "\n")
        XCTAssertTrue(lines[0].hasSuffix(";Оплата"))
        XCTAssertTrue(lines[1].hasSuffix(";наличными"))
    }
}
