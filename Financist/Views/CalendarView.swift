import SwiftUI

/// День для записи задним числом — из календаря в «Итогах».
struct PresetDay: Identifiable {
    let date: Date
    var id: Date { date }
}

/// Календарь месяца в «Итогах»: дни подсвечены тем ярче, чем больше в них потрачено.
/// Нажатие на день показывает его траты ниже, повторное — прячет их. Месяц листается сверху «Итогов».
struct SpendingCalendar: View {
    @Environment(AppStore.self) private var store
    let month: Date
    @Binding var selectedDay: Date?

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    var body: some View {
        let currency = store.displayCurrency
        let monthInterval = calendar.dateInterval(of: .month, for: month)!
        let perDay = Dictionary(grouping: store.vault.expenses.filter { monthInterval.contains($0.date) }) {
            calendar.startOfDay(for: $0.date)
        }.mapValues { $0.total(in: currency).doubleValue }
        let maxDay = perDay.values.max() ?? 0

        LazyVGrid(columns: columns, spacing: 4) {
            ForEach([2, 3, 4, 5, 6, 7, 1], id: \.self) { weekday in
                Text(RuDate.weekdaysShort[weekday])
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
            ForEach(0..<leadingBlanks(monthInterval.start), id: \.self) { _ in
                Color.clear.frame(height: 1)
            }
            ForEach(days(in: monthInterval), id: \.self) { day in
                let isSelected = selectedDay.map { calendar.isDate(day, inSameDayAs: $0) } ?? false
                DayCell(day: day,
                        level: maxDay > 0 ? (perDay[day] ?? 0) / maxDay : 0,
                        isSelected: isSelected,
                        isToday: calendar.isDateInToday(day),
                        isFuture: day > .now,
                        amount: perDay[day].map { currency.format(Decimal($0).rounded(scale: 0)) })
                    .onTapGesture {
                        guard day <= .now else { return }
                        withAnimation(.snappy) { selectedDay = isSelected ? nil : day }
                    }
            }
        }
        .padding(.vertical, 6)
        .sensoryFeedback(.selection, trigger: selectedDay)
    }

    /// Сколько пустых клеток перед 1-м числом (неделя с понедельника).
    private func leadingBlanks(_ start: Date) -> Int {
        (calendar.component(.weekday, from: start) + 5) % 7
    }

    private func days(in interval: DateInterval) -> [Date] {
        var result: [Date] = []
        var day = interval.start
        while day < interval.end {
            result.append(day)
            day = calendar.date(byAdding: .day, value: 1, to: day)!
        }
        return result
    }
}

private struct DayCell: View {
    @Environment(\.palette) private var palette
    let day: Date
    let level: Double
    let isSelected: Bool
    let isToday: Bool
    let isFuture: Bool
    let amount: String?
    @ScaledMetric(relativeTo: .body) private var size: CGFloat = 40

    var body: some View {
        Text("\(Calendar.current.component(.day, from: day))")
            .font(.body.weight(isSelected || isToday ? .bold : .regular))
            .monospacedDigit()
            .minimumScaleFactor(0.6)
            .foregroundStyle(isSelected ? Color.white : isFuture ? Color.secondary.opacity(0.5) : isToday ? palette.accent : Color.primary)
            .frame(maxWidth: .infinity, minHeight: size)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isSelected ? palette.accent : palette.accent.opacity(level > 0 ? 0.12 + level * 0.5 : 0))
            }
            .contentShape(Rectangle())
            .accessibilityElement()
            .accessibilityLabel("\(RuDate.day(day))\(amount.map { ", потрачено \($0)" } ?? ", трат нет")")
            .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}
