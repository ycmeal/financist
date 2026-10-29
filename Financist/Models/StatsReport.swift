import SwiftUI

enum StatsPeriod: String, CaseIterable, Identifiable {
    case month, year

    var id: Self { self }
    var title: String { self == .month ? "Месяц" : "Год" }
    var component: Calendar.Component { self == .month ? .month : .year }
}

struct Insight: Identifiable {
    let symbol: String
    let color: Color
    let text: String
    var id: String { text }
}

struct CategoryTotal: Identifiable {
    let category: ExpenseCategory
    let total: Decimal
    let share: Double
    let ids: Set<UUID>
    var id: UUID { category.id }
}

struct TimeBucket: Identifiable {
    let date: Date
    let total: Double
    var id: Date { date }
}

struct WeekdayTotal: Identifiable {
    let weekday: Int
    let title: String
    let total: Double
    var id: Int { weekday }
}

struct CurrencyTotal: Identifiable {
    let currency: Currency
    let total: Decimal
    let share: Double
    let count: Int
    var id: Currency { currency }
}

/// Сколько заплачено картой и сколько наличными (доля — среди трат, где это отмечено).
struct PaymentShare: Identifiable {
    let method: PaymentMethod
    let total: Decimal
    let share: Double
    var id: PaymentMethod { method }
}

struct PlaceTotal: Identifiable {
    let note: String
    let count: Int
    let total: Decimal
    let ids: Set<UUID>
    var id: String { note }
}

struct MonthTotal: Identifiable {
    let month: Date
    let total: Decimal
    let count: Int
    var id: Date { month }
}

/// Вся статистика считается здесь, на устройстве. Никуда не отправляется.
struct StatsReport {
    let period: StatsPeriod
    let interval: DateInterval
    let currency: Currency
    let expenses: [Expense]
    let total: Decimal
    let byCategory: [CategoryTotal]
    let buckets: [TimeBucket]
    let bucketUnit: Calendar.Component
    let weekdays: [WeekdayTotal]
    let byCurrency: [CurrencyTotal]
    let topPlaces: [PlaceTotal]
    let byPayment: [PaymentShare]
    let insights: [Insight]
    let trend: Insight?

    init(all: [Expense], period: StatsPeriod, anchor: Date, currency: Currency,
         category: (UUID) -> ExpenseCategory, calendar: Calendar = .current, now: Date = .now) {
        self.period = period
        self.currency = currency
        let iv = calendar.dateInterval(of: period.component, for: anchor) ?? DateInterval(start: anchor, duration: 86_400)
        interval = iv
        let items = all.filter { $0.date >= iv.start && $0.date < iv.end }.sorted { $0.date > $1.date }
        expenses = items
        let sum = items.total(in: currency)
        total = sum

        byCategory = Dictionary(grouping: items, by: \.categoryID)
            .map { id, group in
                let t = group.total(in: currency)
                return CategoryTotal(category: category(id), total: t,
                                     share: sum > 0 ? (t / sum).doubleValue : 0, ids: Set(group.map(\.id)))
            }
            .sorted { $0.total > $1.total }

        // По дням для месяца, по месяцам для года.
        let unit: Calendar.Component = period == .month ? .day : .month
        bucketUnit = unit
        let perBucket = Dictionary(grouping: items) { calendar.dateInterval(of: unit, for: $0.date)?.start ?? $0.date }
        var buckets: [TimeBucket] = []
        var cursor = iv.start
        while cursor < iv.end {
            buckets.append(TimeBucket(date: cursor, total: (perBucket[cursor] ?? []).total(in: currency).doubleValue))
            guard let next = calendar.date(byAdding: unit, value: 1, to: cursor) else { break }
            cursor = next
        }
        self.buckets = buckets

        // Дни недели, начиная с понедельника.
        let perWeekday = Dictionary(grouping: items) { calendar.component(.weekday, from: $0.date) }
        weekdays = [2, 3, 4, 5, 6, 7, 1].map { day in
            WeekdayTotal(weekday: day, title: RuDate.weekdaysShort[day],
                         total: (perWeekday[day] ?? []).total(in: currency).doubleValue)
        }

        byCurrency = Dictionary(grouping: items, by: \.currency)
            .map { cur, group in
                let t = group.total(in: currency)
                return CurrencyTotal(currency: cur, total: t,
                                     share: sum > 0 ? (t / sum).doubleValue : 0, count: group.count)
            }
            .sorted { $0.total > $1.total }

        // «мигрос» и «Migros» — одно место.
        let paid = items.totalsByPayment(in: currency)
        let paidSum = paid.reduce(Decimal(0)) { $0 + $1.total }
        byPayment = paid.map { PaymentShare(method: $0.method, total: $0.total,
                                            share: paidSum > 0 ? ($0.total / paidSum).doubleValue : 0) }

        topPlaces = Dictionary(grouping: items.filter { !SuggestionEngine.key($0.note).isEmpty }) { SuggestionEngine.key($0.note) }
            .values
            .map { group in
                PlaceTotal(note: group[0].note, count: group.count, total: group.total(in: currency),
                           ids: Set(group.map(\.id)))
            }
            .sorted { $0.count != $1.count ? $0.count > $1.count : $0.total > $1.total }
            .prefix(5)
            .map { $0 }

        // Сравнение с тем же отрезком прошлого периода — честно для незаконченного месяца.
        let elapsedEnd = min(iv.end, now)
        let isPartial = elapsedEnd < iv.end
        var trend: Insight?
        var growth: Insight?
        if let prevStart = calendar.date(byAdding: period.component, value: -1, to: iv.start) {
            let prevEnd = prevStart.addingTimeInterval(elapsedEnd.timeIntervalSince(iv.start))
            let prev = all.filter { $0.date >= prevStart && $0.date < prevEnd }
            let prevTotal = prev.total(in: currency)
            if prevTotal > 0 && sum > 0 {
                let compare: String
                switch (period, isPartial) {
                case (.month, true): compare = "чем за те же дни \(RuDate.monthGenitive(prevStart))"
                case (.month, false): compare = "чем за \(RuDate.monthNominative(prevStart))"
                case (.year, true): compare = "чем за то же время \(calendar.component(.year, from: prevStart)) года"
                case (.year, false): compare = "чем в \(calendar.component(.year, from: prevStart)) году"
                }
                let change = ((sum - prevTotal) / prevTotal).doubleValue
                if abs(change) < 0.03 {
                    trend = Insight(symbol: "equal.circle.fill", color: .blue, text: "Почти столько же, \(compare)")
                } else if change < 0 {
                    trend = Insight(symbol: "arrow.down.right.circle.fill", color: .green,
                                    text: "На \(Fmt.percent(-change)) меньше, \(compare)")
                } else {
                    trend = Insight(symbol: "arrow.up.right.circle.fill", color: .orange,
                                    text: "На \(Fmt.percent(change)) больше, \(compare)")
                }

                let prevByCat = Dictionary(grouping: prev, by: \.categoryID).mapValues { $0.total(in: currency) }
                let deltas = byCategory.map { ($0.category, $0.total - (prevByCat[$0.category.id] ?? 0)) }
                if let up = deltas.max(by: { $0.1 < $1.1 }), up.1 > sum / 10 {
                    growth = Insight(symbol: "chart.line.uptrend.xyaxis", color: .orange,
                                     text: "\(up.0.name): +\(currency.format(up.1.rounded(scale: 0))) к прошлому")
                }
            }
        }
        self.trend = trend

        var insights: [Insight] = []
        if sum > 0 {
            let days = max(1, Int((elapsedEnd.timeIntervalSince(iv.start) / 86_400).rounded(.up)))
            insights.append(Insight(symbol: "calendar", color: .blue,
                                    text: "В среднем \(currency.format((sum / Decimal(days)).rounded(scale: 2))) в день"))

            if let top = byCategory.first, byCategory.count > 1 {
                insights.append(Insight(symbol: top.category.symbol, color: top.category.color,
                                        text: "Больше всего — \(top.category.name), \(Fmt.percent(top.share))"))
            }
            if let growth { insights.append(growth) }

            let perDay = Dictionary(grouping: items) { calendar.startOfDay(for: $0.date) }
            if perDay.count >= 2,
               let busiest = perDay.max(by: { $0.value.total(in: currency) < $1.value.total(in: currency) }) {
                insights.append(Insight(symbol: "flame.fill", color: .red,
                                        text: "Самый затратный день — \(RuDate.day(busiest.key)): \(currency.format(busiest.value.total(in: currency).rounded(scale: 0)))"))
            }

            if let biggest = items.max(by: { $0.amount(in: currency) < $1.amount(in: currency) }), items.count >= 2 {
                let what = biggest.note.isEmpty ? category(biggest.categoryID).name : biggest.note
                insights.append(Insight(symbol: "star.fill", color: .yellow,
                                        text: "Самая крупная трата — \(what), \(currency.format(biggest.amount(in: currency).rounded(scale: 0)))"))
            }

            if let place = topPlaces.first, place.count >= 3 {
                insights.append(Insight(symbol: "heart.fill", color: .pink,
                                        text: "Любимое место — \(place.note): \(Fmt.count(place.count, "раз", "раза", "раз"))"))
            }

            if items.count >= 7 {
                let counts = Dictionary(grouping: items) { calendar.component(.weekday, from: $0.date) }
                if let day = counts.max(by: { $0.value.count < $1.value.count })?.key {
                    insights.append(Insight(symbol: "calendar.badge.clock", color: .purple,
                                            text: "Чаще всего тратите по \(RuDate.weekdaysDative[day])"))
                }
            }

            let quietDays = days - perDay.count
            if quietDays > 0 {
                insights.append(Insight(symbol: "leaf.fill", color: .green,
                                        text: "\(Fmt.count(quietDays, "день", "дня", "дней")) без трат"))
            }

            if byCurrency.count > 1 {
                insights.append(Insight(symbol: "globe.europe.africa.fill", color: .teal,
                                        text: "Траты в \(byCurrency.count) валютах"))
            }
        }
        self.insights = insights
    }

    /// Итоги по всем месяцам, от свежих к старым.
    static func months(_ all: [Expense], currency: Currency, calendar: Calendar = .current) -> [MonthTotal] {
        Dictionary(grouping: all) { calendar.dateInterval(of: .month, for: $0.date)?.start ?? $0.date }
            .map { MonthTotal(month: $0.key, total: $0.value.total(in: currency), count: $0.value.count) }
            .sorted { $0.month > $1.month }
    }
}
