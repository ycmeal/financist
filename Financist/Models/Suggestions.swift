import Foundation

/// Подсказка при вводе заметки: «Migros» → «Продукты».
struct Suggestion: Identifiable, Hashable {
    let note: String
    let categoryID: UUID
    let currency: Currency?
    let lastAmount: Decimal?
    let count: Int

    var id: String { SuggestionEngine.normalize(note) }
}

enum SuggestionEngine {
    /// Стартовые подсказки, пока своей истории нет. Категория ищется по имени.
    static let seeds: [(note: String, category: String)] = [
        ("Migros", "Продукты"), ("File Market", "Продукты"), ("Kasaba", "Продукты"),
        ("A101", "Продукты"), ("BİM", "Продукты"), ("ŞOK", "Продукты"),
        ("CarrefourSA", "Продукты"), ("Хлеб", "Продукты"),
        ("Doyuyo", "Рестораны"),
        ("Getir", "Доставка"), ("Yemeksepeti", "Доставка"), ("Trendyol Yemek", "Доставка"),
        ("Eczane", "Здоровье"), ("Аптека", "Здоровье"),
        ("Turkcell", "Связь"), ("Vodafone", "Связь"), ("Türk Telekom", "Связь"),
        ("Аренда", "Жильё"),
        ("Taksi", "Транспорт"), ("İstanbulkart", "Транспорт"),
    ]

    static func normalize(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
    }

    /// История пользователя (чаще используемое — выше), затем стартовые подсказки.
    static func build(expenses: [Expense], categories: [ExpenseCategory]) -> [Suggestion] {
        let validIDs = Set(categories.map(\.id))
        let groups = Dictionary(grouping: expenses.filter { !normalize($0.note).isEmpty }) { normalize($0.note) }

        var result: [Suggestion] = groups.values.compactMap { items in
            let sorted = items.sorted { $0.date > $1.date }
            let counts = Dictionary(grouping: sorted.filter { validIDs.contains($0.categoryID) }, by: \.categoryID)
            guard let latest = sorted.first,
                  let categoryID = counts.max(by: { $0.value.count < $1.value.count })?.key
            else { return nil }
            return Suggestion(
                note: latest.note.trimmingCharacters(in: .whitespacesAndNewlines),
                categoryID: categoryID,
                currency: latest.currency,
                lastAmount: latest.amount,
                count: items.count
            )
        }
        result.sort { $0.count != $1.count ? $0.count > $1.count : $0.note < $1.note }

        let known = Set(result.map(\.id))
        for seed in seeds where !known.contains(normalize(seed.note)) {
            guard let category = categories.first(where: { $0.name == seed.category }) else { continue }
            result.append(Suggestion(note: seed.note, categoryID: category.id, currency: nil, lastAmount: nil, count: 0))
        }
        return result
    }

    /// Совпадения по началу слова важнее совпадений в середине.
    static func match(_ query: String, in all: [Suggestion], limit: Int = 5) -> [Suggestion] {
        let q = normalize(query)
        guard !q.isEmpty else { return Array(all.filter { $0.count > 0 }.prefix(limit)) }
        var prefix: [Suggestion] = [], contains: [Suggestion] = []
        for s in all where s.id != q {
            let words = s.id.split(separator: " ")
            if s.id.hasPrefix(q) || words.contains(where: { $0.hasPrefix(q) }) {
                prefix.append(s)
            } else if s.id.contains(q) {
                contains.append(s)
            }
        }
        return Array((prefix + contains).prefix(limit))
    }

    static func exact(_ note: String, in all: [Suggestion]) -> Suggestion? {
        let q = normalize(note)
        return q.isEmpty ? nil : all.first { $0.id == q }
    }
}
