import Foundation
import XCTest
@testable import FinancistCore

/// Scenarios in which the user's data could be lost. Each test drives the real storage code
/// (AppStore + EncryptedStore) with a controllable Keychain and lock state.
final class StorageTests: XCTestCase {
    private var root: URL!

    override func setUp() {
        super.setUp()
        root = FileManager.default.temporaryDirectory.appendingPathComponent("fin-\(UUID().uuidString)", isDirectory: true)
        TestEnvironment.directory = root.appendingPathComponent("Financist", isDirectory: true)
        KeyStore.stored = nil
        KeyStore.mode = .normal
        KeyStore.createdKeys = 0
        UIApplication.shared.isProtectedDataAvailable = true
        Reminders.eveningSchedules = 0
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

    @MainActor
    private func expense(_ note: String, _ amount: Decimal = 100, in store: AppStore, daysAgo: Double = 0) -> Expense {
        let category = store.vault.categories.first { $0.name == "Продукты" }!
        return Expense(date: Date.now.addingTimeInterval(-daysAgo * 86_400), amount: amount, currency: .lira,
                       categoryID: category.id, note: note, rates: store.vault.rates.effective)
    }

    /// Name → contents of every file in the data folder.
    private func snapshot() -> [String: Data] {
        let dir = TestEnvironment.directory
        let files = (try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)) ?? []
        var result: [String: Data] = [:]
        for file in files { result[file.lastPathComponent] = try? Data(contentsOf: file) }
        return result
    }

    private var mainURL: URL { EncryptedStore().mainURL }

    /// Existing files are byte-for-byte the same and none disappeared. New files may only be
    /// extra safety copies (they never replace anything).
    private func assertNothingLost(since before: [String: Data], file: StaticString = #filePath, line: UInt = #line) {
        let after = snapshot()
        for (name, data) in before {
            XCTAssertEqual(after[name], data, "\(name) changed or disappeared", file: file, line: line)
        }
        for name in after.keys where before[name] == nil {
            XCTAssertTrue(name.hasPrefix("copy-"), "Unexpected new file \(name)", file: file, line: line)
        }
    }

    private func vaultJSON(_ vault: Vault) throws -> String {
        String(data: try JSONEncoder().encode(vault), encoding: .utf8)!
    }

    /// Seals arbitrary JSON with the current key and writes it as the main file.
    private func writeMain(json: String) throws {
        let key = try KeyStore.existing() ?? KeyStore.create()
        let sealed = try AES.GCM.seal(Data(json.utf8), using: key).combined!
        try FileManager.default.createDirectory(at: TestEnvironment.directory, withIntermediateDirectories: true)
        try sealed.write(to: mainURL)
    }

    private func setModificationDate(_ url: URL, daysAgo: Double) throws {
        try FileManager.default.setAttributes([.modificationDate: Date.now.addingTimeInterval(-daysAgo * 86_400)],
                                              ofItemAtPath: url.path)
    }

    // MARK: First launch and normal use

    @MainActor
    func testFirstLaunchIsFreshAndDataSurvivesRelaunch() async throws {
        let first = launch()
        XCTEqual(first.loadState, .ready)
        XCTAssertTrue(first.vault.expenses.isEmpty)
        XCTAssertTrue(snapshot().isEmpty, "Nothing is written until the user changes something")

        first.upsert(expense("Migros", in: first))
        XCTAssertEqual(KeyStore.createdKeys, 1)
        XCTAssertNotNil(snapshot()["main.sealed"])

        let second = launch()
        XCTEqual(second.loadState, .ready)
        XCTAssertEqual(second.vault.expenses.map(\.note), ["Migros"])
        XCTAssertEqual(KeyStore.createdKeys, 1, "Relaunch must reuse the key")
    }

    // MARK: Locked phone / prewarm

    @MainActor
    func testLockedPhoneTouchesNothingAndOpensAfterUnlock() async throws {
        let first = launch()
        first.upsert(expense("Migros", in: first))
        let before = snapshot()
        Reminders.eveningSchedules = 0

        UIApplication.shared.isProtectedDataAvailable = false
        let prewarmed = launch()
        XCTEqual(prewarmed.loadState, .waiting)
        prewarmed.upsert(expense("Must not be saved", in: prewarmed))
        await prewarmed.refreshRates(force: true)
        prewarmed.refreshReminders()
        XCTAssertEqual(snapshot(), before, "Nothing at all may be touched while the phone is locked")
        XCTAssertEqual(Reminders.eveningSchedules, 0, "Reminders must not be rescheduled from empty data")

        // iOS says protected data is available, but the Keychain is still locked for a moment.
        UIApplication.shared.isProtectedDataAvailable = true
        KeyStore.mode = .locked
        prewarmed.loadIfNeeded()
        XCTEqual(prewarmed.loadState, .waiting)
        assertNothingLost(since: before)

        KeyStore.mode = .normal
        prewarmed.appBecameActive()
        XCTEqual(prewarmed.loadState, .ready)
        XCTAssertEqual(prewarmed.vault.expenses.map(\.note), ["Migros"])
    }

    // MARK: Keychain trouble

    @MainActor
    func testKeychainErrorLeavesFilesAloneAndRecovers() async throws {
        let first = launch()
        first.upsert(expense("Migros", in: first))
        let before = snapshot()

        KeyStore.mode = .failing(-34018)
        let broken = launch()
        guard case .failed(.unreadable) = broken.loadState else { return XCTFail("\(broken.loadState)") }
        broken.upsert(expense("Must not be saved", in: broken))
        assertNothingLost(since: before)
        XCTAssertEqual(KeyStore.createdKeys, 1)

        KeyStore.mode = .normal
        broken.loadIfNeeded()
        XCTEqual(broken.loadState, .ready)
        XCTAssertEqual(broken.vault.expenses.map(\.note), ["Migros"])
    }

    @MainActor
    func testKeyWronglyReportedMissingNeverLeadsToANewKey() async throws {
        let first = launch()
        first.upsert(expense("Migros", in: first))
        let mainBefore = try Data(contentsOf: mainURL)
        let keyBefore = KeyStore.stored

        KeyStore.mode = .transientNotFound
        let store = launch()
        guard case .failed(.unreadable) = store.loadState else { return XCTFail("\(store.loadState)") }

        // The user taps "start over" or restores a transfer file while the Keychain misbehaves.
        XCTAssertThrowsError(try store.startFreshKeepingOldFiles())
        let transfer = try first.backup(password: "1234")
        XCTAssertThrowsError(try store.restore(from: transfer, password: "1234"))
        XCTAssertEqual(try Data(contentsOf: mainURL), mainBefore, "Main file must be untouched")
        XCTAssertEqual(KeyStore.stored, keyBefore, "Key must never be replaced")

        KeyStore.mode = .normal
        let later = launch()
        XCTEqual(later.loadState, .ready)
        XCTAssertEqual(later.vault.expenses.map(\.note), ["Migros"])
        XCTAssertTrue(EncryptedStore().displacedCopies.isEmpty, "Extra copies made on the way are cleaned up")
    }

    // MARK: Corruption and missing files

    @MainActor
    func testCorruptedMainOpensNewestCopyAndKeepsTheBrokenFile() async throws {
        let first = launch()
        first.upsert(expense("Day one", in: first))
        let second = launch() // makes the daily/weekly copies with "Day one"
        second.upsert(expense("Day two", in: second))

        var bytes = try Data(contentsOf: mainURL)
        bytes[bytes.count / 2] ^= 0xFF
        try bytes.write(to: mainURL)

        let third = launch()
        XCTEqual(third.loadState, .ready)
        XCTAssertTrue(third.recoveredFromBackup)
        XCTAssertEqual(third.vault.expenses.map(\.note), ["Day one"])
        XCTAssertEqual(EncryptedStore().displacedCopies.count, 1, "The corrupted file is kept, not deleted")
    }

    @MainActor
    func testMissingMainWithCopiesIsNotAFirstLaunch() async throws {
        let first = launch()
        first.upsert(expense("Migros", in: first))
        _ = launch() // copies
        try FileManager.default.removeItem(at: mainURL)

        let store = launch()
        XCTEqual(store.loadState, .ready)
        XCTAssertTrue(store.recoveredFromBackup)
        XCTAssertEqual(store.vault.expenses.map(\.note), ["Migros"])
    }

    @MainActor
    func testMissingMainWithOnlyUnreadableCopiesFailsInsteadOfStartingEmpty() async throws {
        let first = launch()
        first.upsert(expense("Migros", in: first))
        _ = launch()
        try FileManager.default.removeItem(at: mainURL)
        KeyStore.stored = Data(repeating: 7, count: 32) // a different key: copies can't be opened

        let store = launch()
        guard case .failed(.unreadable) = store.loadState else { return XCTFail("\(store.loadState)") }
        store.upsert(expense("Must not be saved", in: store))
        XCTAssertNil(snapshot()["main.sealed"], "No empty main file may appear next to the old copies")
    }

    // MARK: Older and newer builds

    @MainActor
    func testFileFromNewerBuildIsNeverOpenedOrOverwritten() async throws {
        let first = launch()
        first.upsert(expense("Migros", in: first))
        var newer = first.vault
        newer.schemaVersion = Vault.currentSchema + 1
        let json = try vaultJSON(newer).replacingOccurrences(of: "\"schemaVersion\":\(Vault.currentSchema)",
                                                             with: "\"schemaVersion\":\(Vault.currentSchema + 1)")
        try writeMain(json: json)
        let before = snapshot()

        let old = launch()
        XCTEqual(old.loadState, .failed(.newerVersion))
        old.upsert(expense("Must not be saved", in: old))
        try old.startFreshKeepingOldFiles()
        let transfer = try first.backup(password: "1234")
        XCTAssertThrowsError(try old.restore(from: transfer, password: "1234"))
        assertNothingLost(since: before)
    }

    @MainActor
    func testUndecodableMainIsNotSilentlyReplacedByAnOlderCopy() async throws {
        let first = launch()
        first.upsert(expense("Old", in: first))
        _ = launch() // copies with "Old"
        let latest = launch()
        latest.upsert(expense("New", in: latest))
        // Simulate data this build can't decode (e.g. a currency it doesn't know).
        let json = try vaultJSON(latest.vault).replacingOccurrences(of: "\"currency\":\"TRY\"", with: "\"currency\":\"XYZ\"")
        try writeMain(json: json)
        let before = snapshot()

        let store = launch()
        guard case .failed(.unreadable) = store.loadState else { return XCTFail("\(store.loadState)") }
        XCTAssertFalse(store.recoveredFromBackup)
        assertNothingLost(since: before)
    }

    @MainActor
    func testLargeFileThatDecodesAsEmptyIsNotOpened() async throws {
        let store = launch()
        var vault = store.vault
        vault.categories = (0..<400).map { ExpenseCategory(name: "Категория \($0)", symbol: "star.fill", colorName: "orange") }
        try writeMain(json: try vaultJSON(vault))
        let before = snapshot()

        let reopened = launch()
        guard case .failed(.unreadable) = reopened.loadState else { return XCTFail("\(reopened.loadState)") }
        assertNothingLost(since: before)
    }

    @MainActor
    func testLegacyAndUnknownValuesDecode() async throws {
        let store = launch()
        let category = store.vault.categories[0].id.uuidString
        let json = """
        {"schemaVersion":1,"expenses":[{"id":"\(UUID().uuidString)","date":700000000,"amount":12.5,"currency":"USDT",
        "categoryID":"\(category)","note":"Старая","rates":{"USDT":1,"TRY":40,"ABC":3}}],
        "categories":[{"id":"\(category)","name":"Продукты","symbol":"cart.fill","colorName":"green"}],
        "rates":{"fetched":{"TRY":41,"USDT":1,"ZZZ":9},"manual":{}},
        "inputCurrency":"XYZ","displayCurrency":"USDT","recentCurrencies":["USDT","QQQ"],"palette":"neon"}
        """
        try writeMain(json: json)

        let reopened = launch()
        XCTEqual(reopened.loadState, .ready)
        let e = try XCTUnwrap(reopened.vault.expenses.first)
        XCTAssertEqual(e.currency, .usd)
        XCTAssertEqual(e.rates[.lira], 40)
        XCTAssertEqual(reopened.vault.rates.rate(.lira), 41)
        XCTAssertEqual(reopened.vault.displayCurrency, .usd)
        XCTAssertEqual(reopened.vault.inputCurrency, .lira)
        XCTAssertEqual(reopened.vault.palette, .sage)
    }

    // MARK: Transfer file

    @MainActor
    func testRestoreMergesAndNeverReplaces() async throws {
        // Old phone (or an old file): Y and Z. Its default categories have their own ids, as in real life.
        let oldPhone = launch()
        let shared = expense("Y", in: oldPhone)
        oldPhone.upsert(shared)
        oldPhone.upsert(expense("Z", in: oldPhone))
        var oldVault = oldPhone.vault
        var newIDs: [UUID: UUID] = [:]
        for index in oldVault.categories.indices {
            let fresh = UUID()
            newIDs[oldVault.categories[index].id] = fresh
            oldVault.categories[index].id = fresh
        }
        for index in oldVault.expenses.indices {
            oldVault.expenses[index].categoryID = newIDs[oldVault.expenses[index].categoryID]!
        }
        let file = try BackupCrypto.encrypt(oldVault, password: "secret")
        try FileManager.default.removeItem(at: TestEnvironment.directory)
        KeyStore.stored = nil

        // This phone: X and the same Y; default categories got different ids.
        let phone = launch()
        phone.upsert(expense("X", in: phone))
        var sameY = shared
        sameY.categoryID = phone.vault.categories.first { $0.name == "Продукты" }!.id
        phone.upsert(sameY)
        let categoriesBefore = phone.vault.categories.count

        let added = try phone.restore(from: file, password: "secret")
        XCTAssertEqual(added, 1)
        XCTAssertEqual(Set(phone.vault.expenses.map(\.note)), ["X", "Y", "Z"])
        XCTAssertEqual(phone.vault.categories.count, categoriesBefore, "Same-named categories are merged, not duplicated")
        let products = phone.vault.categories.first { $0.name == "Продукты" }!.id
        XCTAssertEqual(phone.vault.expenses.first { $0.note == "Z" }?.categoryID, products)

        XCTAssertEqual(try phone.restore(from: file, password: "secret"), 0, "Restoring twice adds nothing")
        XCTAssertEqual(launch().vault.expenses.count, 3, "Merged data is on disk")
    }

    @MainActor
    func testRestoreOnFreshPhoneTakesEverything() async throws {
        let oldPhone = launch()
        oldPhone.upsert(expense("Migros", in: oldPhone))
        oldPhone.displayCurrency = .eur
        let file = try oldPhone.backup(password: "secret")
        let oldCategories = oldPhone.vault.categories.map(\.id)
        try FileManager.default.removeItem(at: TestEnvironment.directory)
        KeyStore.stored = nil

        let newPhone = launch()
        XCTAssertEqual(try newPhone.restore(from: file, password: "secret"), 1)
        XCTAssertEqual(newPhone.vault.categories.map(\.id), oldCategories)
        XCTAssertEqual(newPhone.vault.displayCurrency, .eur)
    }

    @MainActor
    func testRestoreDoesNotBringBackDeletedExpenses() async throws {
        let phone = launch()
        let x = expense("X", in: phone)
        phone.upsert(x)
        phone.upsert(expense("Keep", in: phone))
        let file = try phone.backup(password: "secret")
        phone.deleteExpenses(ids: [x.id])

        XCTAssertEqual(try phone.restore(from: file, password: "secret"), 0)
        XCTAssertFalse(phone.vault.expenses.contains { $0.id == x.id })
        XCTAssertEqual(phone.vault.trash.map(\.id), [x.id])
    }

    @MainActor
    func testRestoreWhileUnreadableKeepsTheOldFileAndBringsItBackLater() async throws {
        let first = launch()
        first.upsert(expense("Old data", in: first))
        // Data this build can't read (simulated decode problem).
        let unreadableJSON = try vaultJSON(first.vault).replacingOccurrences(of: "\"currency\":\"TRY\"", with: "\"currency\":\"XYZ\"")
        try writeMain(json: unreadableJSON)

        let otherPhone = Vault()
        var transferVault = otherPhone
        transferVault.expenses = [Expense(date: .now, amount: 5, currency: .usd, categoryID: otherPhone.categories[0].id,
                                          note: "From file", rates: [:])]
        let file = try BackupCrypto.encrypt(transferVault, password: "secret")

        let store = launch()
        guard case .failed(.unreadable) = store.loadState else { return XCTFail("\(store.loadState)") }
        XCTAssertEqual(try store.restore(from: file, password: "secret"), 1)
        XCTAssertEqual(store.vault.expenses.map(\.note), ["From file"])
        let displaced = try XCTUnwrap(EncryptedStore().displacedCopies.first, "The unreadable file is kept")

        // A later build can read it: simulate by fixing the displaced file's contents.
        let key = try XCTUnwrap(KeyStore.existing())
        let fixed = unreadableJSON.replacingOccurrences(of: "\"currency\":\"XYZ\"", with: "\"currency\":\"TRY\"")
        try AES.GCM.seal(Data(fixed.utf8), using: key).combined!.write(to: displaced)

        let later = launch()
        XCTEqual(later.loadState, .ready)
        XCTAssertEqual(Set(later.vault.expenses.map(\.note)), ["From file", "Old data"])
        XCTAssertEqual(later.recoveredExpenses, 1)
        XCTAssertTrue(EncryptedStore().displacedCopies.isEmpty)
    }

    @MainActor
    func testStartFreshKeepsOldFileAndBringsItBackLater() async throws {
        let first = launch()
        first.upsert(expense("Old data", in: first))
        let unreadableJSON = try vaultJSON(first.vault).replacingOccurrences(of: "\"currency\":\"TRY\"", with: "\"currency\":\"XYZ\"")
        try writeMain(json: unreadableJSON)

        let store = launch()
        guard case .failed(.unreadable) = store.loadState else { return XCTFail("\(store.loadState)") }
        try store.startFreshKeepingOldFiles()
        XCTEqual(store.loadState, .ready)
        XCTAssertTrue(store.vault.expenses.isEmpty)
        store.upsert(expense("New data", in: store))
        let displaced = try XCTUnwrap(EncryptedStore().displacedCopies.first)

        let key = try XCTUnwrap(KeyStore.existing())
        let fixed = unreadableJSON.replacingOccurrences(of: "\"currency\":\"XYZ\"", with: "\"currency\":\"TRY\"")
        try AES.GCM.seal(Data(fixed.utf8), using: key).combined!.write(to: displaced)

        let later = launch()
        XCTAssertEqual(Set(later.vault.expenses.map(\.note)), ["Old data", "New data"])
    }

    @MainActor
    func testRestoreWhileWaitingIsRefused() async throws {
        let first = launch()
        first.upsert(expense("Migros", in: first))
        let file = try first.backup(password: "secret")
        let before = snapshot()

        UIApplication.shared.isProtectedDataAvailable = false
        let waiting = launch()
        XCTAssertThrowsError(try waiting.restore(from: file, password: "secret")) { error in
            guard case VaultError.notReady = error else { return XCTFail("\(error)") }
        }
        XCTAssertEqual(snapshot(), before)
    }

    @MainActor
    func testTransferFileErrorsAreHonest() async throws {
        let store = launch()
        store.upsert(expense("Migros", in: store))
        let file = try store.backup(password: "right")
        XCTAssertThrowsError(try BackupCrypto.decrypt(file, password: "wrong")) { error in
            guard case VaultError.wrongPassword = error else { return XCTFail("\(error)") }
        }
        XCTAssertEqual(try BackupCrypto.decrypt(file, password: "right").expenses.count, 1)

        var newer = store.vault
        newer.schemaVersion = Vault.currentSchema + 1
        let newerFile = try BackupCrypto.encrypt(newer, password: "right")
        XCTAssertThrowsError(try BackupCrypto.decrypt(newerFile, password: "right")) { error in
            guard case VaultError.newerFormat = error else { return XCTFail("\(error)") }
        }
        XCTAssertThrowsError(try BackupCrypto.decrypt(Data("garbage".utf8), password: "right")) { error in
            guard case VaultError.badBackup = error else { return XCTFail("\(error)") }
        }
    }

    // MARK: Deleting

    @MainActor
    func testDeletedExpensesGoToTrashAndCanBeRestored() async throws {
        let store = launch()
        let x = expense("X", in: store)
        store.upsert(x)
        store.deleteExpenses(ids: [x.id])
        XCTAssertTrue(store.vault.expenses.isEmpty)

        let reopened = launch()
        XCTAssertEqual(reopened.vault.trash.map(\.id), [x.id])
        reopened.restoreFromTrash(ids: [x.id])
        XCTAssertEqual(launch().vault.expenses.map(\.id), [x.id])
    }

    @MainActor
    func testTrashIsPurgedAfterThirtyDays() async throws {
        let store = launch()
        let old = expense("Old", in: store)
        let recent = expense("Recent", in: store)
        var vault = store.vault
        vault.trash = [DeletedExpense(expense: old, deletedAt: Date.now.addingTimeInterval(-31 * 86_400)),
                       DeletedExpense(expense: recent, deletedAt: Date.now.addingTimeInterval(-29 * 86_400))]
        vault.expenses = [expense("Kept", in: store)]
        try writeMain(json: try vaultJSON(vault))

        XCTAssertEqual(launch().vault.trash.map(\.expense.note), ["Recent"])
        XCTAssertEqual(launch().vault.trash.map(\.expense.note), ["Recent"], "Purge is saved")
    }

    @MainActor
    func testWipeRemovesEverything() async throws {
        let first = launch()
        first.upsert(expense("Migros", in: first))
        _ = launch()
        first.resetAll()
        XCTAssertEqual(Set(snapshot().keys), ["main.sealed"])
        let reopened = launch()
        XCTEqual(reopened.loadState, .ready)
        XCTAssertTrue(reopened.vault.expenses.isEmpty)
    }

    // MARK: Saving problems

    @MainActor
    func testSaveFailureIsReportedKeptInMemoryAndRetried() async throws {
        let store = launch()
        store.upsert(expense("Saved", in: store))
        // Make the next write fail (a folder where the file should be).
        try FileManager.default.removeItem(at: mainURL)
        try FileManager.default.createDirectory(at: mainURL, withIntermediateDirectories: false)

        store.upsert(expense("Pending", in: store))
        XCTAssertNotNil(store.saveProblem, "The user must be told")
        XCTAssertTrue(store.hasUnsavedChanges)
        XCTAssertEqual(store.vault.expenses.count, 2)

        try FileManager.default.removeItem(at: mainURL)
        store.retryUnsavedChanges()
        XCTAssertNil(store.saveProblem)
        XCTAssertFalse(store.hasUnsavedChanges)
        XCTAssertEqual(Set(launch().vault.expenses.map(\.note)), ["Saved", "Pending"])
    }

    @MainActor
    func testSaveWhileLockedIsSilentAndRetried() async throws {
        let store = launch()
        KeyStore.mode = .locked
        UIApplication.shared.isProtectedDataAvailable = false
        store.upsert(expense("While locking", in: store))
        XCTAssertNil(store.saveProblem, "No scary alert for a normal lock")
        XCTAssertTrue(store.hasUnsavedChanges)

        KeyStore.mode = .normal
        UIApplication.shared.isProtectedDataAvailable = true
        store.appBecameActive()
        XCTAssertFalse(store.hasUnsavedChanges)
        XCTAssertEqual(launch().vault.expenses.map(\.note), ["While locking"])
    }

    func testOutOfSpaceIsRecognised() {
        XCTAssertTrue(NSError(domain: NSCocoaErrorDomain, code: NSFileWriteOutOfSpaceError).isOutOfSpace)
        XCTAssertTrue(NSError(domain: NSPOSIXErrorDomain, code: Int(ENOSPC)).isOutOfSpace)
        XCTAssertFalse(NSError(domain: NSCocoaErrorDomain, code: NSFileWriteNoPermissionError).isOutOfSpace)
    }

    // MARK: Safety copies

    @MainActor
    func testRoutineCopiesAreRefreshedOnlyWhenOld() async throws {
        let store = launch()
        store.upsert(expense("A", in: store))
        let second = launch()
        let files = EncryptedStore()
        let launchCopy = try Data(contentsOf: files.launchCopyURL)
        second.upsert(expense("B", in: second))

        second.appBecameActive()
        XCTAssertEqual(try Data(contentsOf: files.launchCopyURL), launchCopy, "Not refreshed within a day")

        try setModificationDate(files.launchCopyURL, daysAgo: 2)
        second.appBecameActive()
        XCTAssertEqual(try Data(contentsOf: files.launchCopyURL), try Data(contentsOf: mainURL))
    }

    @MainActor
    func testBuildSnapshotsAreKeptAndPruned() async throws {
        let store = launch()
        store.upsert(expense("A", in: store))
        let files = EncryptedStore()
        for tag in ["1.0-1", "1.0-2", "1.1-1", "1.2-1"] {
            files.snapshotBeforeUpdate(tag: tag)
            try await Task.sleep(nanoseconds: 20_000_000)
        }
        let builds = files.allVaultFiles.filter { $0.lastPathComponent.hasPrefix("copy-build-") }
        XCTAssertLessThanOrEqual(builds.count, 3)
        XCTAssertTrue(builds.contains { $0.lastPathComponent == "copy-build-1.2-1.sealed" })
    }

    @MainActor
    func testMergingASafetyCopyOnlyAdds() async throws {
        let store = launch()
        let a = expense("A", in: store)
        let b = expense("B", in: store)
        store.upsert(a)
        store.upsert(b)
        let reopened = launch() // copies contain A and B
        // B disappears completely (e.g. purged long ago); A is in the trash.
        reopened.deleteExpenses(ids: [a.id, b.id])
        var vault = reopened.vault
        vault.trash.removeAll { $0.id == b.id }
        try writeMain(json: try vaultJSON(vault))
        let current = launch()

        let copy = try XCTUnwrap(current.safetyCopies.first { $0.title == "Ежедневная копия" })
        XCTAssertEqual(try current.mergeCopy(copy), 1)
        XCTAssertEqual(current.vault.expenses.map(\.note), ["B"], "B returns, A stays deleted")
    }

    @MainActor
    func testLegacyLocationIsMigrated() async throws {
        let store = launch()
        store.upsert(expense("Legacy", in: store))
        let legacy = root.appendingPathComponent("vault.sealed")
        try FileManager.default.moveItem(at: mainURL, to: legacy)
        try FileManager.default.removeItem(at: TestEnvironment.directory)

        let reopened = launch()
        XCTEqual(reopened.loadState, .ready)
        XCTAssertEqual(reopened.vault.expenses.map(\.note), ["Legacy"])
        XCTAssertFalse(FileManager.default.fileExists(atPath: legacy.path))
    }
}

/// XCTAssertEqual for LoadState with a readable message.
private func XCTEqual(_ state: LoadState, _ expected: LoadState, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(state, expected, file: file, line: line)
}
