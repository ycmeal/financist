import Foundation
import XCTest
@testable import FinancistCore

/// The "this version will stop opening soon" notice.
final class BuildAgeTests: XCTestCase {
    private let day: TimeInterval = 86_400

    func testWarnsFromDay75UntilSnoozed() {
        let start = Date(timeIntervalSince1970: 1_800_000_000)
        XCTAssertFalse(BuildAge.shouldWarn(firstLaunch: nil, snoozedUntil: nil, now: start))
        XCTAssertFalse(BuildAge.shouldWarn(firstLaunch: start, snoozedUntil: nil, now: start + 74 * day))
        XCTAssertTrue(BuildAge.shouldWarn(firstLaunch: start, snoozedUntil: nil, now: start + 75 * day))
        XCTAssertFalse(BuildAge.shouldWarn(firstLaunch: start, snoozedUntil: start + 78 * day, now: start + 76 * day))
        XCTAssertTrue(BuildAge.shouldWarn(firstLaunch: start, snoozedUntil: start + 78 * day, now: start + 79 * day))
    }

    func testNewBuildRestartsTheCountAndClearsSnooze() throws {
        let defaults = try XCTUnwrap(UserDefaults(suiteName: "build-age-\(UUID().uuidString)"))
        let start = Date(timeIntervalSince1970: 1_800_000_000)

        BuildAge.recordLaunch(now: start, defaults: defaults)
        BuildAge.recordLaunch(now: start + 10 * day, defaults: defaults)
        XCTAssertTrue(BuildAge.shouldWarn(now: start + 75 * day, defaults: defaults), "Second launch must not reset the count")

        BuildAge.snooze(now: start + 75 * day, defaults: defaults)
        XCTAssertFalse(BuildAge.shouldWarn(now: start + 76 * day, defaults: defaults))

        // A different build was installed.
        defaults.set("older-build", forKey: "build.tag")
        BuildAge.recordLaunch(now: start + 80 * day, defaults: defaults)
        XCTAssertFalse(BuildAge.shouldWarn(now: start + 81 * day, defaults: defaults))
        XCTAssertTrue(BuildAge.shouldWarn(now: start + 155 * day, defaults: defaults))
    }
}
