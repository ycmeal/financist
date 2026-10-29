import Foundation
import XCTest
@testable import FinancistCore

/// The header's pixel places: the app draws exactly the picture of the clickable mockup.
/// Reference values come from the mockup's JavaScript (same algorithm, same drawings).
final class PixelCityTests: XCTestCase {
    private func fnv(_ pixels: [UInt32]) -> UInt32 {
        var h: UInt32 = 0x811C_9DC5
        for v in pixels {
            for byte in [(v >> 16) & 255, (v >> 8) & 255, v & 255] {
                h ^= byte
                h = h &* 0x0100_0193
            }
        }
        return h
    }

    private func render(_ scene: String, _ part: DayPart, sun: Double?, flag code: String?, time: Double,
                        seed: String?) -> [UInt32] {
        PixelCity.render(scene: scene, part: part, sun: sun, flag: code.flatMap(PixelCity.flagPixels), time: time,
                         seed: PixelCity.seed(for: seed))
    }

    func testSameNumbersAsTheMockup() {
        XCTAssertEqual(PixelCity.hash(0, 0, 0), 0)
        XCTAssertEqual(PixelCity.hash(5, 7, 9413), 61_008_553)
        XCTAssertEqual(PixelCity.hash(63, 55, 20_261_029), 3_254_216_467)
        XCTAssertEqual(PixelCity.hash(2, 3, -77), 1_645_745_784)
        XCTAssertEqual([PixelCity.seed(for: "TR"), PixelCity.seed(for: "RU"), PixelCity.seed(for: "EU"),
                        PixelCity.seed(for: "UZ"), PixelCity.seed(for: nil)], [9413, 9354, 8951, 9452, 9543])
    }

    func testSamePicturesAsTheMockup() {
        let cases: [(String, DayPart, Double?, String?, Double, String?, UInt32)] = [
            ("istanbul", .day, 0.5, "TR", 1234.5, "TR", 2_306_190_960),
            ("moscow", .night, nil, "RU", 40000.25, "RU", 550_223_265),
            ("dubai", .dusk, 0.93, "AE", 63000, "AE", 1_510_315_967),
            ("paris", .night, nil, "EU", 75610, "EU", 2_522_786_484),
            ("cappadocia", .dawn, 0.07, "TR", 25000, "TR", 2_159_179_077),
            ("desert", .day, 0.3, "AE", 50000.75, "AE", 2_290_080_810),
            ("village", .dusk, 0.85, "RU", 66000.5, "RU", 985_389_065),
            ("tropic", .day, 0.6, "TH", 45000, "TH", 2_867_048_031),
            ("mountains", .night, nil, "KZ", 3600, "KZ", 2_531_074_143),
            ("samarkand", .dawn, 0.15, "UZ", 26000, "UZ", 2_904_672_343),
            ("khiva", .day, 0.45, "UZ", 43000, "UZ", 2_130_244_529),
            ("coast", .dawn, 0.12, "EU", 24000, "EU", 2_660_342_141),
            ("alps", .day, 0.7, "CH", 52000, "CH", 1_252_104_079),
            ("newyork", .night, nil, "US", 80000, "US", 2_589_429_146),
            ("city", .day, 0.5, nil, 40000, nil, 3_207_444_980),
        ]
        for (scene, part, sun, flag, time, seed, checksum) in cases {
            let frame = render(scene, part, sun: sun, flag: flag, time: time, seed: seed)
            XCTAssertEqual(frame.count, PixelCity.cols * PixelCity.rows)
            XCTAssertEqual(fnv(frame), checksum, "\(scene) \(part)")
        }
        // A few points by hand, for a readable failure: sky, sun, flag, mosque, sea.
        let frame = render("istanbul", .day, sun: 0.5, flag: "TR", time: 1234.5, seed: "TR")
        let spots: [(Int, Int, UInt32)] = [(0, 0, 0x4FA3E3), (72, 30, 0xFFE27A), (6, 52, 0xE30A17), (70, 50, 0x9BAEC3),
                                           (20, 70, 0x4686BE)]
        for (x, y, color) in spots {
            XCTAssertEqual(frame[y * PixelCity.cols + x], color, "(\(x), \(y))")
        }
    }

    func testEveryCountryHasItsFlagAndPlaces() {
        let codes = Place.countries.map(\.1) + ["EU"]
        for code in codes {
            XCTAssertEqual(PixelCity.flagPixels(code)?.count, PixelCity.flagWidth * PixelCity.flagHeight, code)
            for day in 0..<3 {
                XCTAssertNotNil(PixelCity.scenes[PixelCity.scene(for: code, day: day)], code)
            }
        }
        XCTAssertNil(PixelCity.flagPixels("ZZ"))
        XCTAssertEqual(PixelCity.scene(for: "ZZ", day: 5), "city")
        XCTAssertEqual(PixelCity.scene(for: nil, day: 5), "city")
    }

    func testDrawingsAreWhole() {
        for (name, text) in PixelCity.sprites {
            let lines = text.split(separator: "\n")
            XCTAssertFalse(lines.isEmpty, name)
            XCTAssertEqual(Set(lines.map(\.count)).count, 1, "\(name): rows of different width")
            for ch in text where ch != "\n" && ch != "." {
                XCTAssertNotNil(PixelCity.materials[ch], "\(name): no material for \(ch)")
            }
        }
        for (id, scene) in PixelCity.scenes {
            for op in scene.ops {
                let names: [String]
                switch op {
                case let .sprite(name, _, _, _, _), let .bob(name, _, _, _, _, _), let .sparkle(name, _, _): names = [name]
                case let .boat(list, _, _, _, _, _), let .anim(list, _, _, _, _): names = list
                case .water, .birds, .flag: names = []
                }
                for name in names { XCTAssertNotNil(PixelCity.parsedSprites[name], "\(id): no drawing \(name)") }
            }
        }
        for (code, flag) in PixelCity.flags {
            let lines = flag.rows.split(separator: "\n")
            XCTAssertEqual(lines.count, PixelCity.flagHeight, code)
            XCTAssertTrue(lines.allSatisfy { $0.count == PixelCity.flagWidth }, code)
        }
    }

    func testPlacesTakeTurnsByDay() {
        XCTAssertEqual(PixelCity.scene(for: "TR", day: 20_390), "istanbul")
        XCTAssertEqual(PixelCity.scene(for: "TR", day: 20_391), "cappadocia")
        XCTAssertEqual(PixelCity.scene(for: "TR", day: 20_392), "istanbul")
        XCTAssertEqual(Set((0..<6).map { PixelCity.scene(for: "UZ", day: $0) }), ["samarkand", "khiva"])
        XCTAssertEqual(Set((0..<6).map { PixelCity.scene(for: "AE", day: $0) }), ["dubai", "desert"])
        XCTAssertEqual(Set((0..<6).map { PixelCity.scene(for: "RU", day: $0) }), ["moscow", "village"])
        XCTAssertEqual(Set((0..<6).map { PixelCity.scene(for: "EU", day: $0) }), ["paris", "coast", "alps"])
        XCTAssertEqual(PixelCity.scene(for: "FR", day: 3), "paris")
        XCTAssertEqual(PixelCity.scene(for: "TR", day: -1), "cappadocia", "Days before 1970 still work")
    }

    func testPlaceChangesAtLocalMidnight() {
        let zone = TimeZone(identifier: "Europe/Istanbul")!
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = zone
        func at(_ day: Int, _ hour: Int, _ minute: Int) -> Date {
            calendar.date(from: DateComponents(year: 2026, month: 10, day: day, hour: hour, minute: minute))!
        }
        let evening = PixelCity.day(at(29, 23, 59), timeZone: zone)
        XCTAssertEqual(PixelCity.day(at(29, 0, 1), timeZone: zone), evening)
        XCTAssertEqual(PixelCity.day(at(30, 0, 1), timeZone: zone), evening + 1)
    }

    func testSunByDayMoonStarsAndLitWindowsAtNight() {
        let day = render("moscow", .day, sun: 0.5, flag: nil, time: 0, seed: "RU")
        let night = render("moscow", .night, sun: nil, flag: nil, time: 0, seed: "RU")
        XCTAssertTrue(day.contains(PixelCity.Light.day.sun))
        XCTAssertFalse(night.contains(PixelCity.Light.night.sun))
        XCTAssertTrue(night.contains(PixelCity.Light.night.moon))
        XCTAssertTrue(night.contains(PixelCity.Light.night.star))
        XCTAssertTrue(night.contains(PixelCity.Light.night.lamp), "Windows are lit at night")
        XCTAssertFalse(day.contains(PixelCity.Light.day.lamp), "…and not in the day")
        XCTAssertTrue(night.contains(0xE5333F), "The ruby star glows at night")
    }

    func testFlagWaves() {
        func flagArea(_ time: Double) -> [UInt32] {
            let frame = render("istanbul", .day, sun: 0.5, flag: "TR", time: time, seed: "TR")
            return (49..<61).flatMap { y in (6..<21).map { x in frame[y * PixelCity.cols + x] } }
        }
        XCTAssertTrue(flagArea(0).contains(0xE30A17))
        XCTAssertGreaterThan(Set((0..<10).map { flagArea(Double($0) * 0.25) }).count, 1, "The flag moves")
        XCTAssertEqual(flagArea(1), flagArea(1), "Same moment — same picture")
    }

    func testEiffelTowerSparklesOnTheHour() {
        func sparkles(_ time: Double) -> Int {
            let frame = render("paris", .night, sun: nil, flag: "FR", time: time, seed: "FR")
            return (22..<66).reduce(0) { sum, y in sum + (61..<88).filter { frame[y * PixelCity.cols + $0] == 0xFFFFFF }.count }
        }
        XCTAssertGreaterThan(sparkles(21 * 3600 + 10), sparkles(21 * 3600 + 30 * 60 + 10) + 10)
    }
}
