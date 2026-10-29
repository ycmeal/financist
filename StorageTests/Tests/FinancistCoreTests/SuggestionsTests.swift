import Foundation
import XCTest
@testable import FinancistCore

/// «На что?»: места находятся, как их ни набери — по-русски или латиницей, и подсказок много с первого дня.
final class SuggestionsTests: XCTestCase {
    private let categories = ExpenseCategory.defaults

    private func category(_ name: String) -> UUID {
        categories.first { $0.name == name }!.id
    }

    private func expense(_ note: String, _ categoryName: String, daysAgo: Double = 1) -> Expense {
        Expense(date: Date.now.addingTimeInterval(-daysAgo * 86_400), amount: 10, currency: .lira,
                categoryID: category(categoryName), note: note, rates: [:])
    }

    private var fresh: [Suggestion] { SuggestionEngine.build(expenses: [], categories: categories) }

    private func first(_ query: String, near currency: Currency = .lira) -> String? {
        SuggestionEngine.match(query, in: fresh, near: currency).first?.note
    }

    func testRussianTypingFindsLatinNames() {
        let cases: [(String, String)] = [
            ("мигрос", "Migros"), ("миг", "Migros"), ("филе", "File Market"), ("фил", "File Market"),
            ("фатура", "Fatura"), ("фат", "Fatura"), ("шок", "ŞOK"), ("бим", "BİM"), ("а101", "A101"),
            ("гетир", "Getir"), ("тюрк телеком", "Türk Telekom"), ("кахве дуньясы", "Kahve Dünyası"),
            ("кочташ", "Koçtaş"), ("йемексепети", "Yemeksepeti"), ("емексеп", "Yemeksepeti"),
            ("трендиол", "Trendyol"), ("вайкики", "LC Waikiki"), ("карфур", "Carrefour"), ("старбакс", "Starbucks"),
            ("макдональдс", "McDonald's"), ("эджзане", "Eczane"), ("экзане", "Eczane"), ("декатлон", "Decathlon"),
            ("икеа", "IKEA"), ("ватсонс", "Watsons"), ("водафон", "Vodafone"), ("туркселл", "Turkcell"),
            ("доалгаз", "Doğalgaz"), ("кира", "Kira"), ("аидат", "Aidat"), ("долмуш", "Dolmuş"),
        ]
        for (typed, expected) in cases {
            XCTAssertEqual(first(typed), expected, "«\(typed)»")
        }
        XCTAssertEqual(first("корзинка", near: .uzs), "Korzinka")
        XCTAssertEqual(first("юселл", near: .uzs), "Ucell")
        XCTAssertEqual(first("яндекс го", near: .uzs), "Yandex Go")
        XCTAssertEqual(first("вайлдберриз", near: .rub), "Wildberries")
    }

    func testLatinTypingFindsRussianWords() {
        XCTAssertEqual(first("apteka"), "Аптека")
        XCTAssertEqual(first("taksi"), "Такси")
        XCTAssertEqual(first("pyaterochka", near: .rub), "Пятёрочка")
        XCTAssertEqual(first("MIGROS"), nil, "Typed exactly as the place is called — nothing new to offer")
        XCTAssertEqual(SuggestionEngine.match("migr", in: fresh).first?.note, "Migros")
    }

    func testKnownPlacePicksCategoryAndIsSavedWithItsUsualSpelling() {
        let all = fresh
        let migros = try? XCTUnwrap(SuggestionEngine.exact("мигрос", in: all))
        XCTAssertEqual(migros?.categoryID, category("Продукты"))
        XCTAssertEqual(SuggestionEngine.exact("Фатура", in: all)?.categoryID, category("Жильё"))
        XCTAssertEqual(SuggestionEngine.exact("нетфликс", in: all)?.categoryID,
                       categories.first(where: \.isSubscription)?.id)
        XCTAssertEqual(SuggestionEngine.canonical("  мигрос ", in: all), "Migros")
        XCTAssertEqual(SuggestionEngine.canonical("шок", in: all), "ŞOK")
        XCTAssertEqual(SuggestionEngine.canonical("apteka", in: all), "Аптека")
        XCTAssertEqual(SuggestionEngine.canonical("Мигрос Джет", in: all), "Мигрос Джет", "Unknown — kept as typed")
        XCTAssertNil(SuggestionEngine.exact("ми", in: all), "Only whole names pick a category")
    }

    func testOwnSpellingsMergeIntoOnePlace() {
        let history = [expense("мигрос", "Продукты"), expense("Мигрос", "Продукты", daysAgo: 2),
                       expense("Migros", "Продукты", daysAgo: 3), expense("Хинкальная", "Кафе")]
        let all = SuggestionEngine.build(expenses: history, categories: categories)
        let migros = all.filter { $0.keys.contains(SuggestionEngine.key("Migros")) }
        XCTAssertEqual(migros.count, 1)
        XCTAssertEqual(migros.first?.note, "Migros", "Shown the usual way")
        XCTAssertEqual(migros.first?.count, 3)
        XCTAssertEqual(all.first?.note, "Migros", "Most used first")
        XCTAssertEqual(SuggestionEngine.match("хин", in: all).first?.note, "Хинкальная")
        XCTAssertEqual(SuggestionEngine.match("hink", in: all).first?.note, "Хинкальная", "Own places work in Latin too")
    }

    func testCategoryIsGuessedFromWords() {
        func guess(_ note: String) -> String? { SuggestionEngine.guessCategory(note, in: categories)?.name }
        XCTAssertEqual(guess("Kasap Ali"), "Продукты")
        XCTAssertEqual(guess("Nur Eczanesi"), "Здоровье")
        XCTAssertEqual(guess("Ali Usta Döner"), "Кафе")
        XCTAssertEqual(guess("кафе у дома"), "Кафе")
        XCTAssertEqual(guess("Hilton Otel"), "Поездки")
        XCTAssertEqual(guess("Berber Mehmet"), "Другое")
        XCTAssertEqual(guess("Su faturası"), "Жильё")
        XCTAssertEqual(guess("аптека на углу"), "Здоровье")
        XCTAssertNil(guess("Мария"))
        XCTAssertNil(guess(""))
    }

    func testEmptyFieldOffersPlacesOfTheCountry() {
        XCTAssertEqual(SuggestionEngine.match("", in: fresh, near: .lira).map(\.note), ["Migros", "BİM", "A101", "ŞOK", "File Market"])
        XCTAssertEqual(SuggestionEngine.match("", in: fresh, near: .uzs).first?.note, "Korzinka")
        XCTAssertEqual(SuggestionEngine.match("", in: fresh, near: .rub).first?.note, "Пятёрочка")
        let own = SuggestionEngine.build(expenses: [expense("Хинкальная", "Кафе")], categories: categories)
        XCTAssertEqual(SuggestionEngine.match("", in: own, near: .lira).first?.note, "Хинкальная", "Own places first")
    }

    func testPlacesOfThisCountryComeFirst() {
        let turkey = SuggestionEngine.match("мак", in: fresh, near: .lira).map(\.note)
        let uzbekistan = SuggestionEngine.match("мак", in: fresh, near: .uzs).map(\.note)
        XCTAssertEqual(turkey.first, "Macrocenter")
        XCTAssertEqual(uzbekistan.first, "Makro")
        XCTAssertFalse(turkey.contains("Makro"), "Other countries only by a longer query")
        XCTAssertFalse(SuggestionEngine.match("та", in: fresh, near: .lira).map(\.note).contains("Yandex Go"))
        XCTAssertEqual(first("ап"), "Аптека", "Everyday words before brands")
        XCTAssertEqual(first("вайлдберриз"), "Wildberries", "A whole name is found in any country")
    }

    func testReceiptNameFindsThePlaceByWholeWords() {
        XCTAssertEqual(SuggestionEngine.place(onReceipt: "MİGROS TİCARET A.Ş.", in: fresh)?.note, "Migros")
        XCTAssertEqual(SuggestionEngine.place(onReceipt: "BİM BİRLEŞİK MAĞAZALAR", in: fresh)?.note, "BİM")
        XCTAssertNil(SuggestionEngine.place(onReceipt: "KAHVECİ DÜNYASI LTD", in: fresh), "No «du» inside other words")
    }

    func testSearchFindsExpensesTheSameWay() {
        let history = [expense("Migros", "Продукты"), expense("CarrefourSA", "Продукты", daysAgo: 2),
                       expense("Starbucks", "Кафе", daysAgo: 3), expense("Аптека", "Здоровье", daysAgo: 4),
                       expense("Kasap Ali", "Продукты", daysAgo: 5), expense("Fatura", "Жильё", daysAgo: 6)]
        let places = SuggestionEngine.build(expenses: history, categories: categories)
        func found(_ query: String) -> [String] {
            let search = SearchQuery(query, places: places)
            return history.filter { e in
                let name = categories.first { $0.id == e.categoryID }!.name
                return search.matches(note: e.note, noteKey: SuggestionEngine.key(e.note),
                                      category: name, categoryKey: SuggestionEngine.key(name))
            }.map(\.note)
        }
        XCTAssertEqual(found("мигрос"), ["Migros"])
        XCTAssertEqual(found("миг"), ["Migros"])
        XCTAssertEqual(found("migros"), ["Migros"])
        XCTAssertEqual(found("карфур"), ["CarrefourSA"], "Known other spelling")
        XCTAssertEqual(found("старбакс"), ["Starbucks"])
        XCTAssertEqual(found("apteka"), ["Аптека"])
        XCTAssertEqual(found("касап"), ["Kasap Ali"])
        XCTAssertEqual(found("фатура"), ["Fatura"])
        XCTAssertEqual(found("продукты"), ["Migros", "CarrefourSA", "Kasap Ali"], "By category")
        XCTAssertEqual(found("produkty"), ["Migros", "CarrefourSA", "Kasap Ali"], "Category by sound")
        XCTAssertEqual(found("  "), [])
        XCTAssertEqual(found("Netflix"), [])
    }

    func testSeedsAreValid() {
        let names = Set(categories.map(\.name))
        var seen: [String: String] = [:]
        for seed in SuggestionEngine.seeds {
            XCTAssertTrue(names.contains(seed.category), "\(seed.note): no category «\(seed.category)»")
            for key in seed.keys {
                XCTAssertFalse(key.isEmpty, seed.note)
                if let other = seen[key] {
                    XCTFail("«\(seed.note)» and «\(other)» are the same to the search (\(key))")
                }
                seen[key] = seed.note
            }
        }
        XCTAssertGreaterThan(SuggestionEngine.seeds.count, 250)
        XCTAssertEqual(fresh.count, SuggestionEngine.seeds.count, "Every seed reaches the user")
    }
}
