import Foundation
import XCTest
@testable import FinancistCore

/// The full-screen amount keypad and saving a new expense from it.
final class AddExpenseTests: XCTestCase {
    private var root: URL!

    override func setUp() {
        super.setUp()
        root = FileManager.default.temporaryDirectory.appendingPathComponent("add-\(UUID().uuidString)", isDirectory: true)
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

    private func typed(_ keys: String, fractionDigits: Int = 2) -> AmountInput {
        var input = AmountInput()
        for ch in keys {
            switch ch {
            case ",": input.press(.comma, fractionDigits: fractionDigits)
            case "<": input.press(.delete, fractionDigits: fractionDigits)
            default: input.press(.digit(Int(String(ch))!), fractionDigits: fractionDigits)
            }
        }
        return input
    }

    func testKeypadTyping() {
        XCTAssertEqual(typed("1250").text, "1250")
        XCTAssertEqual(typed("1250").display, "1\u{202F}250")
        XCTAssertEqual(typed("1250").value, 1250)
        XCTAssertEqual(typed("12,5").value, Decimal(string: "12.5"))
        XCTAssertEqual(typed("12,345").text, "12,34", "No more than kuruş allow")
        XCTAssertEqual(typed("1,2,3").text, "1,23", "One comma only")
        XCTAssertEqual(typed(",5").text, "0,5", "A comma first means zero point")
        XCTAssertEqual(typed("007").text, "7", "No leading zeros")
        XCTAssertEqual(typed("12<<").text, "")
        XCTAssertEqual(typed("12<<").display, "0")
        XCTAssertNil(typed("0").value, "Zero is not an amount")
        XCTAssertNil(typed("0,").value)
        XCTAssertEqual(typed("12345678901").text, "123456789", "Nine digits at most")
        XCTAssertEqual(typed("1234567,89").display, "1\u{202F}234\u{202F}567,89")
    }

    func testSumHasNoFractions() {
        XCTAssertEqual(typed("15000,5", fractionDigits: 0).text, "150005", "No comma for UZS")
        var input = typed("12,75")
        input.fit(fractionDigits: 0)
        XCTAssertEqual(input.text, "12", "Switching to sum drops the fraction")
        input = typed("12,75")
        input.fit(fractionDigits: 1)
        XCTAssertEqual(input.text, "12,7")
        XCTAssertEqual(AmountInput(amount: Decimal(string: "12.5")!, fractionDigits: 2).text, "12,5")
        XCTAssertEqual(AmountInput(amount: 15000, fractionDigits: 0).text, "15000")
    }

    @MainActor
    func testNewExpenseGetsTheRatesOfItsDay() async throws {
        let store = AppStore()
        store.loadIfNeeded()
        let category = try XCTUnwrap(store.vault.categories.first { $0.name == "Продукты" })
        let today = store.addExpense(amount: 350, currency: .lira, categoryID: category.id, note: "  Migros ", date: .now)
        XCTAssertEqual(today.note, "Migros")
        XCTAssertEqual(today.rates, store.ratesForDay(.now, currency: .lira).rates)
        XCTAssertEqual(store.vault.expenses.map(\.id), [today.id])
        XCTAssertEqual(store.vault.inputCurrency, .lira, "The next entry starts in the same currency")

        let longAgo = Calendar.current.date(byAdding: .day, value: -40, to: .now)!
        let old = store.addExpense(amount: 10, currency: .usd, categoryID: category.id, note: "", date: longAgo)
        XCTAssertTrue(old.ratesPending, "No rates for that day yet — it will be refined")
    }
}
