import Charts
import SwiftUI

struct StatsView: View {
    var body: some View {
        NavigationStack {
            StatsContent(period: .month, anchor: .now)
                .navigationTitle("Итоги")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) { DisplayCurrencyMenu() }
                }
        }
    }
}

/// Итоги месяца или года. Всё считается на устройстве.
struct StatsContent: View {
    @Environment(\.palette) private var palette
    @Environment(AppStore.self) private var store
    @State private var period: StatsPeriod
    @State private var anchor: Date
    @State private var keepAnchor = false
    private let showsPicker: Bool

    init(period: StatsPeriod, anchor: Date, showsPicker: Bool = true) {
        _period = State(initialValue: period)
        _anchor = State(initialValue: anchor)
        self.showsPicker = showsPicker
    }

    var body: some View {
        let report = StatsReport(all: store.vault.expenses, period: period, anchor: anchor,
                                 currency: store.displayCurrency, category: { store.category(for: $0) })
        List {
            if showsPicker {
                Section {
                    Picker("Период", selection: $period) {
                        ForEach(StatsPeriod.allCases) { Text($0.title).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
            }

            Section {
                PeriodNavigator(title: title(report.interval), canGoForward: report.interval.end <= .now) {
                    shift($0)
                }
                .listRowBackground(Color.clear)
            }

            if report.total == 0 {
                ContentUnavailableView("Трат нет", systemImage: "leaf",
                                       description: Text("За этот период ничего не записано."))
                    .listRowBackground(Color.clear)
            } else {
                Section {
                    HeroTotal(report: report)
                }

                if !report.insights.isEmpty {
                    Section("Главное") {
                        ForEach(report.insights) { InsightRow(insight: $0) }
                    }
                }

                Section("Категории") {
                    DonutChart(report: report)
                    ForEach(report.byCategory) { item in
                        NavigationLink {
                            ExpenseListView(title: item.category.name, ids: item.ids)
                        } label: {
                            ShareRow(icon: CategoryIcon(category: item.category), title: item.category.name,
                                     value: report.currency.format(item.total.rounded(scale: 0)),
                                     share: item.share, color: item.category.color)
                        }
                    }
                }

                Section(period == .month ? "По дням" : "По месяцам") {
                    TimelineChart(report: report)
                }

                Section("По дням недели") {
                    WeekdayChart(report: report)
                }

                if report.byCurrency.count > 1 {
                    Section("Где тратили") {
                        ForEach(report.byCurrency) { item in
                            ShareRow(icon: Text(item.currency.flag).font(.title2),
                                     title: item.currency.placeName,
                                     value: report.currency.format(item.total.rounded(scale: 0)),
                                     share: item.share, color: palette.accent)
                        }
                    }
                }

                if !report.topPlaces.isEmpty {
                    Section("Частые места") {
                        ForEach(report.topPlaces) { place in
                            NavigationLink {
                                ExpenseListView(title: place.note, ids: place.ids)
                            } label: {
                                AdaptiveRow {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(place.note)
                                        Text(Fmt.count(place.count, "раз", "раза", "раз"))
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer(minLength: 0)
                                    Text(report.currency.format(place.total.rounded(scale: 0)))
                                        .monospacedDigit()
                                }
                            }
                        }
                    }
                }
            }

            if showsPicker {
                Section {
                    NavigationLink {
                        MonthsHistoryView()
                    } label: {
                        Label("Все месяцы", systemImage: "calendar")
                    }
                }
            }
        }
        .warmListBackground()
        .animation(.snappy, value: anchor)
        .onChange(of: period) {
            if keepAnchor { keepAnchor = false } else { anchor = .now }
        }
        .onAppear(perform: applyJump)
        .onChange(of: store.statsJump) { applyJump() }
    }

    /// Переход из карточки «месяц закрыт» на вкладке «Траты».
    private func applyJump() {
        guard showsPicker, let jump = store.statsJump else { return }
        store.statsJump = nil
        if period != .month { keepAnchor = true }
        period = .month
        anchor = jump
    }

    private func shift(_ value: Int) {
        if let next = Calendar.current.date(byAdding: period.component, value: value, to: anchor) {
            withAnimation { anchor = next }
        }
    }

    private func title(_ interval: DateInterval) -> String {
        period == .month
            ? RuDate.month(interval.start)
            : "\(Calendar.current.component(.year, from: interval.start))"
    }
}

private struct PeriodNavigator: View {
    let title: String
    let canGoForward: Bool
    let onShift: (Int) -> Void

    var body: some View {
        HStack {
            Button { onShift(-1) } label: {
                Image(systemName: "chevron.left.circle.fill").font(.title)
            }
            .accessibilityLabel("Назад")
            Spacer()
            Text(title)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
            Spacer()
            Button { onShift(1) } label: {
                Image(systemName: "chevron.right.circle.fill").font(.title)
            }
            .accessibilityLabel("Вперёд")
            .disabled(!canGoForward)
        }
        .buttonStyle(.borderless)
        .symbolRenderingMode(.hierarchical)
    }
}

private struct HeroTotal: View {
    let report: StatsReport

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Потрачено")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(report.currency.format(report.total.rounded(scale: 2)))
                .font(.largeTitle.weight(.bold))
                .monospacedDigit()
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            Text(Fmt.count(report.expenses.count, "трата", "траты", "трат"))
                .foregroundStyle(.secondary)
            if let trend = report.trend {
                InsightRow(insight: trend)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 6)
    }
}

struct InsightRow: View {
    let insight: Insight

    var body: some View {
        Label {
            Text(insight.text)
        } icon: {
            Image(systemName: insight.symbol)
                .foregroundStyle(insight.color)
        }
    }
}

private struct ShareRow<Icon: View>: View {
    let icon: Icon
    let title: String
    let value: String
    let share: Double
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            icon
            VStack(alignment: .leading, spacing: 6) {
                AdaptiveRow(spacing: 8) {
                    Text(title)
                    Spacer(minLength: 0)
                    Text(value)
                        .monospacedDigit()
                    Text(Fmt.percent(share))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                ProgressView(value: share)
                    .tint(color)
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, 2)
    }
}

private struct DonutChart: View {
    let report: StatsReport

    var body: some View {
        Chart(report.byCategory) { item in
            SectorMark(angle: .value("Сумма", item.total.doubleValue),
                       innerRadius: .ratio(0.62), angularInset: 1.5)
                .cornerRadius(5)
                .foregroundStyle(item.category.color)
                .accessibilityLabel(item.category.name)
                .accessibilityValue(Fmt.percent(item.share))
        }
        .chartBackground { proxy in
            GeometryReader { geometry in
                if let plotFrame = proxy.plotFrame {
                    let frame = geometry[plotFrame]
                    VStack(spacing: 2) {
                        Text("\(report.byCategory.count)")
                            .font(.title.weight(.bold))
                        Text(Fmt.plural(report.byCategory.count, "категория", "категории", "категорий"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .frame(height: 220)
        .padding(.vertical, 8)
    }
}

private struct TimelineChart: View {
    @Environment(\.palette) private var palette
    let report: StatsReport

    var body: some View {
        Chart(report.buckets) { bucket in
            BarMark(x: .value("Дата", bucket.date, unit: report.bucketUnit),
                    y: .value("Сумма", bucket.total))
                .foregroundStyle(palette.accent)
                .cornerRadius(3)
        }
        .chartXAxis {
            AxisMarks(values: report.period == .year ? .stride(by: .month) : .stride(by: .day, count: 7)) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(axisLabel(date))
                    }
                }
            }
        }
        .chartYAxis { amountAxis() }
        .frame(height: 200)
        .padding(.vertical, 8)
    }

    /// Год: первая буква месяца (влезает и при крупном шрифте). Месяц: число.
    private func axisLabel(_ date: Date) -> String {
        report.period == .year
            ? String(RuDate.monthNominative(date).prefix(1)).uppercased()
            : "\(Calendar.current.component(.day, from: date))"
    }
}

private struct WeekdayChart: View {
    @Environment(\.palette) private var palette
    let report: StatsReport

    var body: some View {
        let maxDay = report.weekdays.max { $0.total < $1.total }?.weekday
        Chart(report.weekdays) { day in
            BarMark(x: .value("День", day.title), y: .value("Сумма", day.total))
                .foregroundStyle(day.weekday == maxDay ? palette.accent : palette.accent.opacity(0.4))
                .cornerRadius(4)
        }
        .chartYAxis { amountAxis() }
        .frame(height: 180)
        .padding(.vertical, 8)
    }
}

/// Ось сумм: три подписи без копеек.
private func amountAxis() -> some AxisContent {
    AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) { value in
        AxisGridLine()
        AxisValueLabel {
            if let amount = value.as(Double.self) {
                Text(Fmt.number(Decimal(amount), minFraction: 0, maxFraction: 0))
            }
        }
    }
}

/// Итоги всех месяцев с переходом в любой из них.
struct MonthsHistoryView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        let currency = store.displayCurrency
        let months = StatsReport.months(store.vault.expenses, currency: currency)
        let maxTotal = months.map(\.total).max() ?? 1
        List(months) { month in
            NavigationLink {
                StatsContent(period: .month, anchor: month.month, showsPicker: false)
                    .navigationTitle(RuDate.month(month.month, alwaysYear: true))
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    AdaptiveRow(spacing: 8) {
                        Text(RuDate.month(month.month))
                            .fontWeight(.semibold)
                        Spacer(minLength: 0)
                        Text(currency.format(month.total.rounded(scale: 0)))
                            .monospacedDigit()
                    }
                    ProgressView(value: maxTotal > 0 ? (month.total / maxTotal).doubleValue : 0)
                        .accessibilityHidden(true)
                    Text(Fmt.count(month.count, "трата", "траты", "трат"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .warmListBackground()
        .overlay {
            if months.isEmpty {
                ContentUnavailableView("Пока нет итогов", systemImage: "calendar")
            }
        }
        .navigationTitle("Все месяцы")
        .navigationBarTitleDisplayMode(.inline)
    }
}
