import Foundation
import XCTest
@testable import FinancistCore

/// The header's country and sky: country from the phone's time zone, no location or network.
final class PlaceTests: XCTestCase {
    private func place(_ zone: String) -> Place? {
        Place.from(timeZone: TimeZone(identifier: zone)!)
    }

    func testCountriesOfTheTrips() {
        XCTAssertEqual(place("Europe/Istanbul"), Place(country: "Турция", code: "TR", currency: .lira))
        XCTAssertEqual(place("Asia/Tashkent")?.currency, .uzs)
        XCTAssertEqual(place("Asia/Samarkand")?.country, "Узбекистан")
        XCTAssertEqual(place("Asia/Dubai")?.currency, .aed)
        XCTAssertEqual(place("Europe/Moscow")?.currency, .rub)
        XCTAssertEqual(place("Asia/Vladivostok")?.country, "Россия")
        XCTAssertEqual(place("Europe/Berlin")?.currency, .eur)
        XCTAssertEqual(place("America/New_York")?.currency, .usd)
        XCTAssertEqual(place("Asia/Almaty")?.country, "Казахстан")
        XCTAssertNil(place("Asia/Almaty")?.currency, "Tenge is not in the app — no rate shown")
    }

    func testFlags() {
        XCTAssertEqual(Place.flag("TR"), "🇹🇷")
        XCTAssertEqual(Place.flag("uz"), "🇺🇿")
        XCTAssertEqual(place("Asia/Dubai")?.flag, "🇦🇪")
    }

    func testUnknownZoneShowsTheCity() {
        let zone = TimeZone(identifier: "America/Sao_Paulo")!
        XCTAssertNil(Place.from(timeZone: zone))
        XCTAssertEqual(Place.city(of: zone), "Sao Paulo")
    }

    func testEveryZoneIsRealAndListedOnce() {
        var seen: [String: String] = [:]
        for (country, code, _, zones) in Place.countries {
            XCTAssertEqual(code.count, 2, country)
            for zone in zones {
                XCTAssertNil(seen[zone], "\(zone) is listed for \(seen[zone] ?? "") and \(country)")
                seen[zone] = country
                XCTAssertNotNil(TimeZone(identifier: zone), "Unknown time zone \(zone)")
            }
        }
    }

    func testSky() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Istanbul")!
        func at(_ hour: Int, _ minute: Int = 0) -> Date {
            calendar.date(from: DateComponents(year: 2026, month: 10, day: 29, hour: hour, minute: minute))!
        }
        XCTAssertEqual(DayPart(at(4, 59), calendar: calendar), .night)
        XCTAssertEqual(DayPart(at(5), calendar: calendar), .morning)
        XCTAssertEqual(DayPart(at(11), calendar: calendar), .day)
        XCTAssertEqual(DayPart(at(17), calendar: calendar), .evening)
        XCTAssertEqual(DayPart(at(22), calendar: calendar), .night)

        XCTAssertNil(DayPart.sunProgress(at(5, 59), calendar: calendar))
        XCTAssertEqual(DayPart.sunProgress(at(6), calendar: calendar), 0)
        XCTAssertEqual(DayPart.sunProgress(at(13), calendar: calendar), 0.5)
        XCTAssertEqual(DayPart.sunProgress(at(20), calendar: calendar), 1)
        XCTAssertNil(DayPart.sunProgress(at(20, 1), calendar: calendar))
    }

    func testWeekdayAndDay() {
        let date = Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: 29, hour: 12))!
        XCTAssertEqual(RuDate.weekdayAndDay(date), "Четверг, 29 октября")
    }
}
