import Charts
import SwiftUI

struct AnalyticsView: View {
    @Environment(AppStore.self) private var store
    @State private var period: AnalyticsPeriod = .month
    @State private var anchor = Date.now

    var body: some View {
        let report = AnalyticsReport(
            all: store.vault.expenses, period: period, anchor: anchor,
            currency: store.displayCurrency, category: store.category(for:)
        )
        NavigationStack {
            List {
                Section {
                    Picker("Период", selection: $period) {
                        ForEach(AnalyticsPeriod.allCases) { Text($0.title).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    if period != .all {
                        periodNavigator(report.interval)
                    }
                }

                if report.total == 0 {
                    ContentUnavailableView("Нет трат", systemImage: "chart.pie",
                                           description: Text("За выбранный период ничего не записано."))
                } else {
                    Section("По категориям") {
                        pieChart(report)
                            .padding(.vertical, 8)
                        ForEach(report.byCategory) { item in
                            NavigationLink {
                                ExpenseListView(title: item.category.name, ids: Set(item.expenses.map(\.id)))
                            } label: {
                                HStack(spacing: 12) {
                                    CategoryIcon(category: item.category)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.category.name)
                                        Text("\(item.expenses.count) \(Fmt.plural(item.expenses.count, "трата", "траты", "трат"))")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(report.currency.format(item.total.rounded(scale: 2)))
                                            .monospacedDigit()
                                        Text(Fmt.percent(item.share))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }

                    Section("Динамика") {
                        barChart(report)
                            .frame(height: 200)
                            .padding(.vertical, 8)
                    }

                    Section("Резюме") {
                        ForEach(report.summary, id: \.self) { line in
                            Text(line)
                        }
                    }
                }
            }
            .navigationTitle("Анализ")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { DisplayCurrencyMenu() }
            }
            .onChange(of: period) { anchor = .now }
        }
    }

    private func periodNavigator(_ interval: DateInterval) -> some View {
        HStack {
            Button { shift(-1) } label: { Image(systemName: "chevron.left") }
                .accessibilityLabel("Предыдущий период")
            Spacer()
            Text(title(for: interval))
                .font(.headline)
            Spacer()
            Button { shift(1) } label: { Image(systemName: "chevron.right") }
                .accessibilityLabel("Следующий период")
                .disabled(interval.end > .now)
        }
        .buttonStyle(.borderless)
    }

    private func shift(_ value: Int) {
        guard let component = period.component,
              let next = Calendar.current.date(byAdding: component, value: value, to: anchor)
        else { return }
        anchor = next
    }

    private func title(for interval: DateInterval) -> String {
        switch period {
        case .week:
            let last = interval.end.addingTimeInterval(-1)
            return interval.start.formatted(.dateTime.day().month(.abbreviated)) + " – "
                + last.formatted(.dateTime.day().month(.abbreviated))
        case .month:
            return interval.start.formatted(.dateTime.month(.wide).year())
        case .year:
            return interval.start.formatted(.dateTime.year())
        case .all:
            return "Всё время"
        }
    }

    private func pieChart(_ report: AnalyticsReport) -> some View {
        Chart(report.byCategory) { item in
            SectorMark(
                angle: .value("Сумма", item.total.doubleValue),
                innerRadius: .ratio(0.62),
                angularInset: 1.5
            )
            .cornerRadius(4)
            .foregroundStyle(item.category.color)
            .accessibilityLabel(item.category.name)
            .accessibilityValue(Fmt.percent(item.share))
        }
        .chartBackground { proxy in
            GeometryReader { geometry in
                if let plotFrame = proxy.plotFrame {
                    let frame = geometry[plotFrame]
                    VStack(spacing: 2) {
                        Text("Итого")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(report.currency.format(report.total.rounded(scale: 2)))
                            .font(.headline)
                            .monospacedDigit()
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                    }
                    .frame(width: frame.width * 0.55)
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .frame(height: 240)
    }

    private func barChart(_ report: AnalyticsReport) -> some View {
        Chart(report.buckets) { bucket in
            BarMark(
                x: .value("Дата", bucket.date, unit: report.bucketUnit),
                y: .value("Сумма", bucket.total.doubleValue)
            )
            .foregroundStyle(Color.accentColor.gradient)
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel {
                    if let amount = value.as(Double.self) {
                        Text(Fmt.number(Decimal(amount), minFraction: 0, maxFraction: 0))
                    }
                }
            }
        }
    }
}
