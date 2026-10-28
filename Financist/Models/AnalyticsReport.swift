import Foundation

enum AnalyticsPeriod: String, CaseIterable, Identifiable {
    case week, month, year, all

    var id: Self { self }

    var title: String {
        switch self {
        case .week: "Неделя"
        case .month: "Месяц"
        case .year: "Год"
        case .all: "Всё"
        }
    }

    var component: Calendar.Component? {
        switch self {
        case .week: .weekOfYear
        case .month: .month
        case .year: .year
        case .all: nil
        }
    }

    /// «чем … прошлого месяца»
    var previousName: String {
        switch self {
        case .week: "прошлой недели"
        case .month: "прошлого месяца"
        case .year: "прошлого года"
        case .all: ""
        }
    }
}

struct CategoryTotal: Identifiable {
    let category: ExpenseCategory
    let total: Decimal
    let share: Double
    let expenses: [Expense]
    var id: UUID { category.id }
}

struct TimeBucket: Identifiable {
    let date: Date
    let total: Decimal
    var id: Date { date }
}

struct AnalyticsReport {
    let period: AnalyticsPeriod
    let interval: DateInterval
    let currency: Currency
    let expenses: [Expense]
    let total: Decimal
    let byCategory: [CategoryTotal]
    let buckets: [TimeBucket]
    let bucketUnit: Calendar.Component
    let summary: [String]

    init(all: [Expense], period: AnalyticsPeriod, anchor: Date, currency: Currency,
         category: (UUID) -> ExpenseCategory, calendar: Calendar = .current) {
        self.period = period
        self.currency = currency
        let now = Date.now

        if let component = period.component {
            interval = calendar.dateInterval(of: component, for: anchor) ?? DateInterval(start: anchor, duration: 1)
        } else {
            let earliest = all.map(\.date).min() ?? now
            let start = calendar.dateInterval(of: .month, for: earliest)?.start ?? earliest
            interval = DateInterval(start: start, end: max(now, all.map(\.date).max() ?? now).addingTimeInterval(1))
        }
        let iv = interval
        expenses = all.filter { $0.date >= iv.start && $0.date < iv.end }.sorted { $0.date > $1.date }
        total = expenses.reduce(0) { $0 + $1.amount(in: currency) }

        let grouped = Dictionary(grouping: expenses, by: \.categoryID)
        let grandTotal = self.total
        byCategory = grouped.map { id, items in
            let sum = items.reduce(Decimal(0)) { $0 + $1.amount(in: currency) }
            return CategoryTotal(category: category(id), total: sum,
                                 share: grandTotal > 0 ? (sum / grandTotal).doubleValue : 0, expenses: items)
        }
        .sorted { $0.total > $1.total }

        // Динамика: по дням для недели/месяца, по месяцам для года/всего.
        let unit: Calendar.Component = (period == .week || period == .month) ? .day : .month
        bucketUnit = unit
        let byBucket = Dictionary(grouping: expenses) { calendar.dateInterval(of: unit, for: $0.date)?.start ?? $0.date }
        var buckets: [TimeBucket] = []
        var cursor = calendar.dateInterval(of: unit, for: iv.start)?.start ?? iv.start
        while cursor < iv.end && buckets.count < 400 {
            let sum = (byBucket[cursor] ?? []).reduce(Decimal(0)) { $0 + $1.amount(in: currency) }
            buckets.append(TimeBucket(date: cursor, total: sum))
            guard let next = calendar.date(byAdding: unit, value: 1, to: cursor) else { break }
            cursor = next
        }
        self.buckets = buckets

        summary = Self.makeSummary(
            all: all, expenses: expenses, total: total, byCategory: byCategory, period: period,
            interval: iv, currency: currency, category: category, calendar: calendar, now: now
        )
    }

    private static func makeSummary(all: [Expense], expenses: [Expense], total: Decimal,
                                    byCategory: [CategoryTotal], period: AnalyticsPeriod,
                                    interval: DateInterval, currency: Currency,
                                    category: (UUID) -> ExpenseCategory,
                                    calendar: Calendar, now: Date) -> [String] {
        guard total > 0 else { return ["За этот период трат нет."] }
        let fmt = currency.format
        var lines: [String] = []

        let elapsedEnd = min(interval.end, now)
        let days = max(1, Int((elapsedEnd.timeIntervalSince(interval.start) / 86_400).rounded(.up)))
        let perDay = total / Decimal(days)
        lines.append("Потрачено \(fmt(total)) — в среднем \(fmt(perDay.rounded(scale: 2))) в день.")

        if let top = byCategory.first {
            lines.append("Больше всего ушло на «\(top.category.name)»: \(fmt(top.total)) (\(Fmt.percent(top.share))).")
            if byCategory.count > 2 {
                let second = byCategory[1]
                let pair = top.share + second.share
                if pair >= 0.6 {
                    lines.append("«\(top.category.name)» и «\(second.category.name)» вместе — \(Fmt.percent(pair)) всех трат.")
                }
            }
        }

        // Сравнение с тем же отрезком прошлого периода (честно для незаконченного месяца).
        if let component = period.component,
           let prevStart = calendar.date(byAdding: component, value: -1, to: interval.start) {
            let elapsed = elapsedEnd.timeIntervalSince(interval.start)
            let prevEnd = prevStart.addingTimeInterval(elapsed)
            let prev = all.filter { $0.date >= prevStart && $0.date < prevEnd }
            let prevTotal = prev.reduce(Decimal(0)) { $0 + $1.amount(in: currency) }
            if prevTotal > 0 {
                let change = ((total - prevTotal) / prevTotal).doubleValue
                let pct = Fmt.percent(abs(change))
                let sameSpan = elapsedEnd < interval.end ? "за тот же отрезок " : ""
                if abs(change) < 0.03 {
                    lines.append("Почти столько же, сколько \(sameSpan)\(period.previousName) (\(fmt(prevTotal))).")
                } else {
                    let word = change > 0 ? "больше" : "меньше"
                    lines.append("Это на \(pct) \(word), чем \(sameSpan)\(period.previousName) (\(fmt(prevTotal))).")
                }

                let prevByCat = Dictionary(grouping: prev, by: \.categoryID)
                    .mapValues { $0.reduce(Decimal(0)) { $0 + $1.amount(in: currency) } }
                let curByCat = Dictionary(uniqueKeysWithValues: byCategory.map { ($0.category.id, $0.total) })
                let ids = Set(prevByCat.keys).union(curByCat.keys)
                let deltas = ids.map { ($0, (curByCat[$0] ?? 0) - (prevByCat[$0] ?? 0)) }
                if let up = deltas.max(by: { $0.1 < $1.1 }), up.1 > total / 20 {
                    lines.append("Сильнее всего выросли траты на «\(category(up.0).name)»: +\(fmt(up.1.rounded(scale: 2))).")
                }
                if let down = deltas.min(by: { $0.1 < $1.1 }), down.1 < -(total / 20) {
                    lines.append("Заметно меньше стало на «\(category(down.0).name)»: −\(fmt((-down.1).rounded(scale: 2))).")
                }
            }
        }

        if let biggest = expenses.max(by: { $0.amount(in: currency) < $1.amount(in: currency) }) {
            let what = biggest.note.isEmpty ? category(biggest.categoryID).name : biggest.note
            let when = biggest.date.formatted(.dateTime.day().month(.abbreviated))
            var line = "Самая крупная трата — \(fmt(biggest.amount(in: currency).rounded(scale: 2))): \(what), \(when)."
            if biggest.currency != currency {
                line = "Самая крупная трата — \(biggest.currency.format(biggest.amount)) (≈ \(fmt(biggest.amount(in: currency).rounded(scale: 2)))): \(what), \(when)."
            }
            lines.append(line)
        }

        let byNote = Dictionary(grouping: expenses.filter { !$0.note.isEmpty }) { SuggestionEngine.normalize($0.note) }
        if let frequent = byNote.values.max(by: { $0.count < $1.count }), frequent.count >= 2 {
            let sum = frequent.reduce(Decimal(0)) { $0 + $1.amount(in: currency) }
            let n = frequent.count
            lines.append("Чаще всего — \(frequent[0].note): \(n) \(Fmt.plural(n, "раз", "раза", "раз")), всего \(fmt(sum.rounded(scale: 2))).")
        }

        return lines
    }
}
