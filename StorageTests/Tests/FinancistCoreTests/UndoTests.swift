import Foundation
import XCTest
@testable import FinancistCore

/// Deleting an expense shows «Вернуть» for a few seconds; quick deletions gather into one plate.
final class UndoTests: XCTestCase {
    private var root: URL!

    override func setUp() {
        super.setUp()
        root = FileManager.default.temporaryDirectory.appendingPathComponent("undo-\(UUID().uuidString)", isDirectory: true)
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

    @MainActor
    private func add(_ store: AppStore, _ note: String) -> UUID {
        let category = store.vault.categories.first { $0.name == "Продукты" }!
        let expense = Expense(date: .now, amount: 100, currency: .lira, categoryID: category.id, note: note,
                              rates: store.vault.rates.effective)
        store.upsert(expense)
        return expense.id
    }

    @MainActor
    func testDeleteOffersUndoAndItBringsTheExpenseBack() async throws {
        let store = launch()
        let id = add(store, "Migros")
        store.deleteExpenses(ids: [id])
        XCTAssertEqual(store.lastDeletion?.title, "Удалено: Migros")
        XCTAssertEqual(store.lastDeletion?.expenseIDs, [id])
        XCTAssertTrue(store.vault.expenses.isEmpty)

        store.undoLastDeletion()
        XCTAssertNil(store.lastDeletion)
        XCTAssertEqual(store.vault.expenses.map(\.id), [id])
        XCTAssertTrue(store.vault.trash.isEmpty)
        XCTAssertEqual(launch().vault.expenses.map(\.id), [id], "Saved")
    }

    @MainActor
    func testQuickDeletionsGatherIntoOnePlate() async throws {
        let store = launch()
        let a = add(store, "Migros"), b = add(store, "Taksi")
        let start = Date.now
        store.deleteExpenses(ids: [a], now: start)
        store.deleteExpenses(ids: [b], now: start.addingTimeInterval(2))
        XCTAssertEqual(store.lastDeletion?.expenseIDs, [a, b])
        XCTAssertEqual(store.lastDeletion?.title, "Удалено: 2 траты")
        store.undoLastDeletion()
        XCTAssertEqual(Set(store.vault.expenses.map(\.id)), [a, b])
    }

    @MainActor
    func testPlateGoesAwayButExpensesStayInRecentlyDeleted() async throws {
        let store = launch()
        let a = add(store, "Migros"), b = add(store, "Taksi")
        let start = Date.now
        store.deleteExpenses(ids: [a], now: start)
        let first = try XCTUnwrap(store.lastDeletion)
        store.deleteExpenses(ids: [b], now: start.addingTimeInterval(AppStore.undoSeconds + 1))
        XCTAssertEqual(store.lastDeletion?.expenseIDs, [b], "The old plate had already gone")

        store.hideDeletion(first.id)
        XCTAssertNotNil(store.lastDeletion, "An old timer does not hide the new plate")
        store.hideDeletion(try XCTUnwrap(store.lastDeletion?.id))
        XCTAssertNil(store.lastDeletion)
        store.undoLastDeletion()
        XCTAssertTrue(store.vault.expenses.isEmpty)
        XCTAssertEqual(Set(store.vault.trash.map(\.id)), [a, b])
    }

    @MainActor
    func testTitleWithoutNoteUsesTheCategory() async throws {
        let store = launch()
        let id = add(store, "")
        store.deleteExpenses(ids: [id])
        XCTAssertEqual(store.lastDeletion?.title, "Удалено: Продукты")
        store.deleteExpenses(ids: [UUID()])
        XCTAssertEqual(store.lastDeletion?.expenseIDs, [id], "Deleting nothing changes nothing")
    }
}
