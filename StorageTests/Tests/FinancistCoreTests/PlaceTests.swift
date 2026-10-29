import Foundation
import XCTest
@testable import FinancistCore

/// The header's country and sky: only countries whose currencies the app has; from the last spending
/// or the phone's time zone, no location or network.
final class PlaceTests: XCTestCase {
    private func place(_ zone: String) -> Place? {
        Place.from(timeZone: TimeZone(identifier: zone)!)
    }

    func testCountriesOfTheTrips() {
        XCTAssertEqual(place("Europe/Istanbul"), Place(currency: .lira))
        XCTAssertEqual(place("Europe/Istanbul")?.country, "Турция")
        XCTAssertEqual(place("Asia/Tashkent")?.currency, .uzs)
        XCTAssertEqual(place("Asia/Samarkand")?.country, "Узбекистан")
        XCTAssertEqual(place("Asia/Dubai")?.currency, .aed)
        XCTAssertEqual(place("Europe/Moscow")?.currency, .rub)
        XCTAssertEqual(place("Asia/Vladivostok")?.country, "Россия")
        XCTAssertEqual(place("Europe/Berlin")?.country, "Европа")
        XCTAssertEqual(place("Europe/Athens")?.code, "EU")
        XCTAssertEqual(place("America/New_York")?.country, "США")
        XCTAssertEqual(place("America/New_York")?.code, "US")
    }

    func testOnlyCountriesWithTheAppsCurrencies() {
        for zone in ["Asia/Almaty", "Europe/London", "Europe/Warsaw", "Asia/Bangkok", "America/Sao_Paulo"] {
            XCTAssertNil(place(zone), "\(zone): its currency is not in the app")
        }
        XCTAssertEqual(Set(Place.zones.keys), Set(Currency.allCases))
    }

    func testEveryZoneIsRealAndListedOnce() {
        var seen: [String: Currency] = [:]
        for (currency, zones) in Place.zones {
            for zone in zones {
                XCTAssertNil(seen[zone], "\(zone) is listed twice")
                seen[zone] = currency
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
        XCTAssertEqual(DayPart(at(5), calendar: calendar), .dawn)
        XCTAssertEqual(DayPart(at(8), calendar: calendar), .day)
        XCTAssertEqual(DayPart(at(17), calendar: calendar), .dusk)
        XCTAssertEqual(DayPart(at(21), calendar: calendar), .night)

        XCTAssertNil(DayPart.sunProgress(at(5, 59), calendar: calendar))
        XCTAssertEqual(DayPart.sunProgress(at(6), calendar: calendar), 0)
        XCTAssertEqual(DayPart.sunProgress(at(13), calendar: calendar), 0.5)
        XCTAssertEqual(DayPart.sunProgress(at(20), calendar: calendar), 1)
        XCTAssertNil(DayPart.sunProgress(at(20, 1), calendar: calendar))
    }

    func testCountryOfTheLastSpending() {
        func expense(_ currency: Currency, daysAgo: Double) -> Expense {
            Expense(date: Date.now.addingTimeInterval(-daysAgo * 86_400), amount: 1, currency: currency,
                    categoryID: UUID(), note: "", rates: [:])
        }
        XCTAssertNil(Place.lastSpent(in: []))
        XCTAssertNil(Place.lastSpent(in: [expense(.usd, daysAgo: 0)]), "Dollars are spent everywhere")
        XCTAssertEqual(Place.lastSpent(in: [expense(.lira, daysAgo: 5), expense(.uzs, daysAgo: 1), expense(.usd, daysAgo: 0)]),
                       Place(currency: .uzs))
        XCTAssertEqual(Place.lastSpent(in: [expense(.eur, daysAgo: 2), expense(.rub, daysAgo: 3)])?.code, "EU")
    }

    func testWeekdayAndDay() {
        let date = Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: 29, hour: 12))!
        XCTAssertEqual(RuDate.weekdayAndDay(date), "Четверг, 29 октября")
    }
}
