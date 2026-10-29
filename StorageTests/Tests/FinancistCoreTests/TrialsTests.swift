import Foundation
import XCTest
@testable import FinancistCore

/// Free trials: a reminder before the charge, a card until a decision, the charge recorded exactly once,
/// and nothing lost or brought back by a transfer file.
final class TrialsTests: XCTestCase {
    private var root: URL!
    private let day: TimeInterval = 86_400

    override func setUp() {
        super.setUp()
        root = FileManager.default.temporaryDirectory.appendingPathComponent("trials-\(UUID().uuidString)", isDirectory: true)
        TestEnvironment.directory = root.appendingPathComponent("Financist", isDirectory: true)
        KeyStore.stored = nil
        KeyStore.mode = .normal
        UIApplication.shared.isProtectedDataAvailable = true
        Reminders.remindedTrials = []
        RatesService.reset()
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: root)
        super.tearDown()
    }

    // MARK: Helpers

    @MainActor
    private func launch() -> AppStore {
        let store = AppStore()
        store.loadIfNeeded()
        return store
    }

    /// Another iPhone: its own folder and key.
    @MainActor
    private func otherPhone() throws -> AppStore {
        try FileManager.default.removeItem(at: TestEnvironment.directory)
        KeyStore.stored = nil
        return launch()
    }

    private func startOfDay(in days: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: days, to: calendar.startOfDay(for: .now))!
    }

    @MainActor
    @discardableResult
    private func addTrial(_ store: AppStore, _ note: String = "YouTube", chargeIn days: Int, remind: Int = 2) -> Trial {
        let trial = Trial(note: note, amount: Decimal(string: "13.99")!, currency: .usd,
                          categoryID: store.subscriptionCategory!.id, chargeDate: startOfDay(in: days),
                          remindDaysBefore: remind)
        store.upsert(trial)
        return trial
    }

    @MainActor
    private func addExpense(_ store: AppStore, _ note: String) {
        let category = store.vault.categories.first { $0.name == "Продукты" }!
        store.upsert(Expense(date: .now, amount: 100, currency: .lira, categoryID: category.id, note: note,
                             rates: store.vault.rates.effective))
    }

    /// A vault as written by the previous build (schema 2): no special category, no trials.
    private func schema2JSON(_ vault: Vault) throws -> String {
        var old = vault
        old.categories = old.categories.filter { !$0.isSubscription }
        old.trials = []
        let json = String(data: try JSONEncoder().encode(old), encoding: .utf8)!
        XCTAssertFalse(json.contains("\"kind\""))
        return json.replacingOccurrences(of: "\"schemaVersion\":\(Vault.currentSchema)", with: "\"schemaVersion\":2")
            .replacingOccurrences(of: ",\"trials\":[]", with: "")
    }

    private func writeMain(json: String) throws {
        let key = try KeyStore.existing() ?? KeyStore.create()
        let sealed = try AES.GCM.seal(Data(json.utf8), using: key).combined!
        try FileManager.default.createDirectory(at: TestEnvironment.directory, withIntermediateDirectories: true)
        try sealed.write(to: EncryptedStore().mainURL)
    }

    /// Categories on another phone have their own ids, as in real life.
    private func withOwnCategoryIDs(_ vault: Vault) -> Vault {
        var copy = vault
        var map: [UUID: UUID] = [:]
        for index in copy.categories.indices {
            let fresh = UUID()
            map[copy.categories[index].id] = fresh
            copy.categories[index].id = fresh
        }
        for index in copy.expenses.indices { copy.expenses[index].categoryID = map[copy.expenses[index].categoryID]! }
        for index in copy.trials.indices { copy.trials[index].categoryID = map[copy.trials[index].categoryID]! }
        return copy
    }

    // MARK: The category

    @MainActor
    func testNewDataHasOneSubscriptionCategoryBeforeOther() async throws {
        let store = launch()
        let names = store.vault.categories.map(\.name)
        XCTAssertEqual(store.vault.categories.filter(\.isSubscription).count, 1)
        XCTAssertEqual(Array(names.suffix(2)), ["Подписка", "Другое"])
    }

    @MainActor
    func testOldDataGetsTheCategoryOnceAndKeepsEverything() async throws {
        let first = launch()
        addExpense(first, "Migros")
        let oldCategories = first.vault.categories.filter { !$0.isSubscription }
        try writeMain(json: try schema2JSON(first.vault))

        let updated = launch()
        XCTAssertEqual(updated.loadState, .ready)
        XCTAssertEqual(updated.vault.expenses.map(\.note), ["Migros"])
        XCTAssertEqual(updated.vault.categories.filter(\.isSubscription).count, 1)
        XCTAssertEqual(updated.vault.categories.filter { !$0.isSubscription }, oldCategories, "Old categories untouched")
        XCTAssertEqual(updated.vault.categories.map(\.name).suffix(2), ["Подписка", "Другое"])

        let again = launch()
        XCTAssertEqual(again.vault.categories.count, oldCategories.count + 1, "Added once, not on every launch")
        XCTAssertEqual(again.vault.categories.first(where: \.isSubscription)?.id,
                       updated.vault.categories.first(where: \.isSubscription)?.id)

        // Renamed by the user: still the same one, nothing added on the next launches.
        var renamed = try XCTUnwrap(again.subscriptionCategory)
        renamed.name = "Сервисы"
        again.upsert(renamed)
        XCTAssertEqual(launch().vault.categories.count, oldCategories.count + 1)
        XCTAssertEqual(launch().vault.categories.filter(\.isSubscription).map(\.id), [renamed.id])
    }

    @MainActor
    func testOwnSubscriptionsCategoryIsAdoptedNotDuplicated() async throws {
        let first = launch()
        var vault = first.vault
        let own = ExpenseCategory(name: "Подписки", symbol: "star.fill", colorName: "orange")
        vault.categories.append(own)
        vault.expenses.append(Expense(date: .now, amount: 10, currency: .usd, categoryID: own.id, note: "Netflix",
                                      rates: vault.rates.effective))
        try writeMain(json: try schema2JSON(vault))

        let updated = launch()
        let special = try XCTUnwrap(updated.vault.categories.first(where: \.isSubscription))
        XCTAssertEqual(special.id, own.id)
        XCTAssertEqual(special.name, "Подписки", "Its name and look stay as the user made them")
        XCTAssertEqual(updated.vault.categories.filter { $0.name.hasPrefix("Подписк") }.count, 1)
        XCTAssertEqual(updated.vault.expenses.first?.categoryID, own.id)
    }

    @MainActor
    func testSubscriptionCategoryCannotBeDeleted() async throws {
        let store = launch()
        let special = store.subscriptionCategory!.id
        let gifts = store.vault.categories.first { $0.name == "Подарки" }!.id
        store.deleteCategories(ids: [special])
        XCTAssertNotNil(store.subscriptionCategory)
        store.deleteCategories(ids: [special, gifts])
        XCTAssertEqual(store.subscriptionCategory?.id, special)
        XCTAssertFalse(store.vault.categories.contains { $0.id == gifts })
    }

    // MARK: Reminder and card

    @MainActor
    func testTrialIsSavedAndRemindedBeforeTheCharge() async throws {
        let store = launch()
        let trial = addTrial(store, chargeIn: 10, remind: 3)
        XCTAssertEqual(Reminders.remindedTrials, [trial.id])

        let reopened = launch()
        let saved = try XCTUnwrap(reopened.vault.trials.first)
        XCTAssertEqual(saved, trial)
        XCTAssertEqual(reopened.openTrials.map(\.id), [trial.id])
        XCTAssertEqual(saved.remindDay, startOfDay(in: 7))
        XCTAssertEqual(saved.reminderDate, Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: startOfDay(in: 7)))
        XCTAssertFalse(saved.needsDecision(), "Quiet row until the reminder day")
        XCTAssertTrue(saved.needsDecision(now: startOfDay(in: 7)))
        XCTAssertTrue(saved.needsDecision(now: startOfDay(in: 30)), "Stays until a decision, even after the charge day")
        XCTAssertTrue(reopened.vault.expenses.isEmpty, "A trial is not an expense")
    }

    @MainActor
    func testMainScreenShowsATrialFiveDaysBeforeTheCharge() async throws {
        let store = launch()
        addTrial(store, "Netflix", chargeIn: 12)
        let youtube = addTrial(store, "YouTube", chargeIn: 5)
        addTrial(store, "Okko", chargeIn: 6, remind: 2)
        addTrial(store, "Disney+", chargeIn: 6, remind: 7)
        XCTAssertEqual(store.trialsDueSoon.map(\.note), ["YouTube", "Disney+"],
                       "Five days before the charge, or earlier if the chosen reminder has already come")
        XCTAssertEqual(store.openTrials.count, 4, "The rest wait in the «Подписки» button")

        let netflix = try XCTUnwrap(store.openTrials.first { $0.note == "Netflix" })
        XCTAssertFalse(netflix.isDueSoon(now: startOfDay(in: 6)))
        XCTAssertTrue(netflix.isDueSoon(now: startOfDay(in: 7)))
        XCTAssertTrue(netflix.isDueSoon(now: startOfDay(in: 20)), "Stays while undecided, even after the charge day")

        store.decide(.keep, for: youtube.id)
        XCTAssertEqual(store.trialsDueSoon.map(\.note), ["Disney+"], "A decided trial leaves the main screen")
        XCTAssertEqual(store.upcomingCharges.map(\.note), ["YouTube"])
    }

    @MainActor
    func testCancelRemovesCardAndReminderAndRecordsNothing() async throws {
        let store = launch()
        let trial = addTrial(store, chargeIn: 1)
        XCTAssertTrue(trial.needsDecision(), "Reminder day already here")

        store.decide(.cancel, for: trial.id)
        XCTAssertTrue(store.openTrials.isEmpty)
        XCTAssertTrue(store.upcomingCharges.isEmpty)
        XCTAssertTrue(Reminders.remindedTrials.isEmpty)
        XCTAssertTrue(store.recordDueCharges(now: startOfDay(in: 5)) == false)
        XCTAssertTrue(store.vault.expenses.isEmpty)

        let reopened = launch()
        XCTAssertEqual(reopened.vault.trials.first?.decision, .cancel)
        XCTAssertTrue(reopened.openTrials.isEmpty)
    }

    @MainActor
    func testKeepRecordsTheChargeOnceOnItsDay() async throws {
        let store = launch()
        let trial = addTrial(store, chargeIn: 3)
        store.decide(.keep, for: trial.id)
        XCTAssertTrue(store.openTrials.isEmpty)
        XCTAssertEqual(store.upcomingCharges.map(\.id), [trial.id])
        XCTAssertTrue(store.vault.expenses.isEmpty, "Not before the charge day")

        let chargeDay = startOfDay(in: 3).addingTimeInterval(3600)
        XCTAssertTrue(store.recordDueCharges(now: chargeDay))
        let expense = try XCTUnwrap(store.vault.expenses.first)
        XCTAssertEqual(expense.id, trial.id)
        XCTAssertEqual(expense.amount, Decimal(string: "13.99"))
        XCTAssertEqual(expense.currency, .usd)
        XCTAssertEqual(expense.note, "YouTube")
        XCTAssertEqual(expense.categoryID, store.subscriptionCategory?.id)
        XCTAssertTrue(Calendar.current.isDate(expense.date, inSameDayAs: startOfDay(in: 3)))
        XCTAssertTrue(store.upcomingCharges.isEmpty)

        XCTAssertFalse(store.recordDueCharges(now: chargeDay.addingTimeInterval(day)))
        XCTAssertEqual(store.vault.expenses.count, 1)
        store.deleteExpenses(ids: [expense.id])
        XCTAssertFalse(store.recordDueCharges(now: chargeDay.addingTimeInterval(2 * day)))
        XCTAssertTrue(store.vault.expenses.isEmpty, "A deleted charge does not come back")
    }

    @MainActor
    func testLateDecisionRecordsTheChargeOnItsDayAndItIsSaved() async throws {
        let store = launch()
        let trial = addTrial(store, chargeIn: -2)
        XCTAssertEqual(store.openTrials.map(\.id), [trial.id], "Still waiting for a decision after the charge day")

        store.decide(.keep, for: trial.id)
        let expense = try XCTUnwrap(store.vault.expenses.first)
        XCTAssertEqual(expense.date, Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: startOfDay(in: -2)))
        XCTAssertTrue(expense.ratesPending, "That day's rates are not loaded yet — corrected later like any expense")

        let reopened = launch()
        XCTAssertEqual(reopened.vault.expenses.map(\.id), [trial.id])
        XCTAssertEqual(reopened.vault.trials.first?.chargeRecorded, true)
    }

    @MainActor
    func testKeptChargeIsRecordedOnLaunchWhenItsDayHasCome() async throws {
        let store = launch()
        var trial = addTrial(store, chargeIn: 2)
        store.decide(.keep, for: trial.id)
        // The charge day comes while the app is closed.
        trial = store.vault.trials[0]
        trial.chargeDate = startOfDay(in: 0)
        var vault = store.vault
        vault.trials = [trial]
        try writeMain(json: String(data: try JSONEncoder().encode(vault), encoding: .utf8)!)

        let reopened = launch()
        XCTAssertEqual(reopened.vault.expenses.map(\.id), [trial.id])
        XCTAssertEqual(launch().vault.expenses.count, 1, "Recorded once and saved")
    }

    @MainActor
    func testChangingMindBeforeTheChargeRecordsNothing() async throws {
        let store = launch()
        let trial = addTrial(store, chargeIn: 4)
        store.decide(.keep, for: trial.id)
        store.decide(.cancel, for: trial.id)
        XCTAssertFalse(store.recordDueCharges(now: startOfDay(in: 10)))
        XCTAssertTrue(store.vault.expenses.isEmpty)
        XCTAssertTrue(store.upcomingCharges.isEmpty)
    }

    @MainActor
    func testDeletingATrialByMistakeLeavesNoTrace() async throws {
        let store = launch()
        let trial = addTrial(store, chargeIn: 5)
        store.deleteTrial(id: trial.id)
        XCTAssertTrue(store.vault.trials.isEmpty)
        XCTAssertTrue(Reminders.remindedTrials.isEmpty)
        XCTAssertTrue(launch().vault.trials.isEmpty)
    }

    // MARK: Transfer file

    @MainActor
    func testTransferBringsTrialsAndDecisionsButNeverUndoesOne() async throws {
        let oldPhone = launch()
        addExpense(oldPhone, "Old")
        var renamed = try XCTUnwrap(oldPhone.subscriptionCategory)
        renamed.name = "Сервисы"
        oldPhone.upsert(renamed)
        let cancelled = addTrial(oldPhone, "Кинопоиск", chargeIn: 6)
        let kept = addTrial(oldPhone, "YouTube", chargeIn: 8)
        let before = withOwnCategoryIDs(oldPhone.vault)
        oldPhone.decide(.cancel, for: cancelled.id)
        var after = before
        after.trials = oldPhone.vault.trials.map { trial in
            var copy = trial
            copy.categoryID = before.trials.first { $0.id == trial.id }!.categoryID
            return copy
        }
        let fileBefore = try BackupCrypto.encrypt(before, password: "secret")
        let fileAfter = try BackupCrypto.encrypt(after, password: "secret")

        let phone = try otherPhone()
        addExpense(phone, "Mine")
        try phone.restore(from: fileBefore, password: "secret")
        XCTAssertEqual(Set(phone.openTrials.map(\.id)), [cancelled.id, kept.id])
        let special = try XCTUnwrap(phone.subscriptionCategory?.id)
        XCTAssertTrue(phone.vault.trials.allSatisfy { $0.categoryID == special }, "Mapped into this phone's «Подписка»")
        XCTAssertEqual(phone.vault.categories.filter(\.isSubscription).count, 1, "Even though the other phone renamed it")

        try phone.restore(from: fileAfter, password: "secret")
        XCTAssertEqual(phone.vault.trials.first { $0.id == cancelled.id }?.decision, .cancel, "Decision from the other phone")

        phone.decide(.keep, for: kept.id)
        try phone.restore(from: fileBefore, password: "secret")
        XCTAssertEqual(phone.vault.trials.first { $0.id == kept.id }?.decision, .keep, "An old file never undoes a decision")
        XCTAssertEqual(phone.vault.trials.first { $0.id == cancelled.id }?.decision, .cancel)
        XCTAssertEqual(phone.vault.trials.count, 2)
    }

    @MainActor
    func testPhoneWithOnlyTrialsIsNotTreatedAsEmpty() async throws {
        let oldPhone = launch()
        addExpense(oldPhone, "Migros")
        let file = try BackupCrypto.encrypt(withOwnCategoryIDs(oldPhone.vault), password: "secret")

        let phone = try otherPhone()
        let mine = addTrial(phone, chargeIn: 9)
        XCTAssertEqual(try phone.restore(from: file, password: "secret"), 1)
        XCTAssertEqual(phone.vault.trials.map(\.id), [mine.id], "Own trial survives the restore")
        XCTAssertEqual(phone.vault.expenses.map(\.note), ["Migros"])
    }

    @MainActor
    func testChargeRecordedOnBothPhonesIsNotDuplicated() async throws {
        let oldPhone = launch()
        let trial = addTrial(oldPhone, chargeIn: 3)
        let shared = try BackupCrypto.encrypt(oldPhone.vault, password: "secret")
        oldPhone.decide(.keep, for: trial.id)
        oldPhone.recordDueCharges(now: startOfDay(in: 3).addingTimeInterval(3600))
        let recorded = try BackupCrypto.encrypt(oldPhone.vault, password: "secret")

        let phone = try otherPhone()
        addExpense(phone, "Mine")
        try phone.restore(from: shared, password: "secret")
        phone.decide(.keep, for: trial.id)
        phone.recordDueCharges(now: startOfDay(in: 3).addingTimeInterval(7200))
        try phone.restore(from: recorded, password: "secret")
        XCTAssertEqual(phone.vault.expenses.filter { $0.id == trial.id }.count, 1)
        XCTAssertEqual(phone.vault.trials.first?.chargeRecorded, true)
    }

    @MainActor
    func testUnreadableFileWithOnlyATrialBringsItBackLater() async throws {
        let first = launch()
        let trial = addTrial(first, chargeIn: 9)
        let json = String(data: try JSONEncoder().encode(first.vault), encoding: .utf8)!
        // Data this build can't read: an unknown currency in the trial.
        let unreadable = json.replacingOccurrences(of: "\"currency\":\"USD\"", with: "\"currency\":\"XYZ\"")
        XCTAssertNotEqual(json, unreadable)
        try writeMain(json: unreadable)

        let store = launch()
        guard case .failed(.unreadable) = store.loadState else { return XCTFail("\(store.loadState)") }
        try store.startFreshKeepingOldFiles()
        let displaced = try XCTUnwrap(EncryptedStore().displacedCopies.first, "The unreadable file is kept")

        // A later build can read it.
        let key = try XCTUnwrap(KeyStore.existing())
        try AES.GCM.seal(Data(json.utf8), using: key).combined!.write(to: displaced)

        let later = launch()
        XCTAssertEqual(later.vault.trials.map(\.id), [trial.id])
        XCTAssertTrue(EncryptedStore().displacedCopies.isEmpty)
        XCTAssertEqual(launch().vault.trials.map(\.id), [trial.id], "Saved before the old file was removed")
    }

    @MainActor
    func testTappingTheReminderOpensThatTrialOnceDataIsOpen() async throws {
        let store = launch()
        let trial = addTrial(store, chargeIn: 1)
        store.selectedTab = .settings

        UIApplication.shared.isProtectedDataAvailable = false
        let locked = AppStore()
        locked.loadIfNeeded()
        TrialRequest.pending = trial.id
        locked.consumeTrialRequest()
        XCTAssertNil(locked.trialToOpen, "Data not open yet — the request waits")
        XCTAssertEqual(TrialRequest.pending, trial.id)

        UIApplication.shared.isProtectedDataAvailable = true
        store.consumeTrialRequest()
        XCTAssertEqual(store.trialToOpen, trial.id)
        XCTAssertEqual(store.selectedTab, .expenses)
        XCTAssertNil(TrialRequest.pending)
    }

    // MARK: Decoding and texts

    func testTrialDecodesWithOnlyRequiredFields() throws {
        let json = """
        {"id":"\(UUID().uuidString)","amount":5,"currency":"USDT","categoryID":"\(UUID().uuidString)","chargeDate":800000000}
        """
        let trial = try JSONDecoder().decode(Trial.self, from: Data(json.utf8))
        XCTAssertEqual(trial.currency, .usd)
        XCTAssertEqual(trial.note, "")
        XCTAssertEqual(trial.title, "Пробная подписка")
        XCTAssertEqual(trial.remindDaysBefore, Trial.defaultReminder)
        XCTAssertNil(trial.decision)
        XCTAssertFalse(trial.chargeRecorded)
    }

    func testTexts() {
        func trial(in days: Int) -> Trial {
            Trial(note: "YouTube", amount: 1, currency: .usd, categoryID: UUID(), chargeDate: startOfDay(in: days),
                  remindDaysBefore: 2)
        }
        XCTAssertEqual(trial(in: 0).chargeText(), "Спишут сегодня")
        XCTAssertEqual(trial(in: 1).chargeText(), "Спишут завтра")
        XCTAssertEqual(trial(in: 3).chargeText(), "Спишут \(RuDate.day(startOfDay(in: 3))) · через 3 дня")
        XCTAssertEqual(trial(in: 5).chargeText(), "Спишут \(RuDate.day(startOfDay(in: 5))) · через 5 дней")
        XCTAssertEqual(trial(in: 30).chargeText(), "Спишут \(RuDate.day(startOfDay(in: 30)))")
        XCTAssertEqual(trial(in: -1).chargeText(), "Списание было \(RuDate.day(startOfDay(in: -1)))")

        XCTAssertTrue(Trial.reminderNote(chargeDate: startOfDay(in: 1), remindDaysBefore: 2).hasPrefix("Пора решать уже сейчас"))
        XCTAssertEqual(Trial.reminderNote(chargeDate: startOfDay(in: 9), remindDaysBefore: 2),
                       "Напомню \(RuDate.day(startOfDay(in: 7))) в 10:00. Пока не решите, «Подписки» на главном экране будут напоминать.")
    }
}
