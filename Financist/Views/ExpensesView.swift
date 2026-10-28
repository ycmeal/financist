import SwiftUI

struct ExpensesView: View {
    @Environment(AppStore.self) private var store
    @State private var editing: Expense?
    @State private var repeating: Expense?
    @State private var addingOn: PresetDay?
    @State private var search = ""
    @State private var mode: Mode = .list
    @State private var calendarMonth = Date.now
    @State private var selectedDay = Calendar.current.startOfDay(for: .now)

    private enum Mode: String, CaseIterable, Identifiable {
        case list = "Список"
        case calendar = "Календарь"
        var id: Self { self }
    }

    private func groupedDays(_ expenses: [Expense]) -> [(day: Date, items: [Expense])] {
        let groups = Dictionary(grouping: expenses) { Calendar.current.startOfDay(for: $0.date) }
        return groups.keys.sorted(by: >).map { day in
            (day, groups[day]!.sorted { $0.date > $1.date })
        }
    }

    var body: some View {
        @Bindable var store = store
        let filtered = search.isEmpty ? store.vault.expenses : store.vault.expenses.filter {
            $0.note.localizedCaseInsensitiveContains(search)
                || store.category(for: $0.categoryID).name.localizedCaseInsensitiveContains(search)
        }
        // Группировка считается один раз за отрисовку — список не подтормаживает.
        let days = groupedDays(filtered)

        NavigationStack {
            List {
                if search.isEmpty {
                    Section { SummaryHeader() }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))

                    let due = store.dueRecurring
                    if !due.isEmpty {
                        Section {
                            ForEach(due) { RecurringCard(payment: $0) }
                        } footer: {
                            Text("Смахните влево, чтобы пропустить в этом месяце.")
                        }
                    }

                    if let closed = closedMonth {
                        Section { MonthClosedCard(month: closed) }
                    }
                }

                if store.vault.expenses.isEmpty {
                    ContentUnavailableView {
                        Label("Пока пусто", systemImage: "leaf")
                    } description: {
                        Text("Нажмите «Добавить трату», и она появится здесь.")
                    }
                    .listRowBackground(Color.clear)
                } else if mode == .calendar && search.isEmpty {
                    Section {
                        SpendingCalendar(month: $calendarMonth, selectedDay: $selectedDay)
                    }
                    dayDetails(days.first { Calendar.current.isDate($0.day, inSameDayAs: selectedDay) }?.items ?? [])
                } else {
                    ForEach(days, id: \.day) { group in
                        Section {
                            ForEach(group.items) { expenseButton($0) }
                                .onDelete { offsets in
                                    store.deleteExpenses(ids: offsets.map { group.items[$0].id })
                                }
                        } header: {
                            DayHeader(day: group.day, items: group.items)
                        }
                    }
                }
            }
            .warmListBackground()
            .animation(.snappy, value: store.vault.expenses)
            .navigationTitle("Траты")
            .searchable(text: $search, prompt: "Поиск")
            .overlay {
                if !search.isEmpty && days.isEmpty { ContentUnavailableView.search(text: search) }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { DisplayCurrencyMenu() }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if !store.vault.expenses.isEmpty {
                        Button {
                            withAnimation(.snappy) { mode = mode == .list ? .calendar : .list }
                        } label: {
                            Image(systemName: mode == .list ? "calendar" : "list.bullet")
                        }
                        .accessibilityLabel(mode == .list ? "Показать календарь" : "Показать списком")
                    }
                    Button { store.isAddingExpense = true } label: { Image(systemName: "plus") }
                        .accessibilityLabel("Добавить трату")
                }
            }
            .sheet(isPresented: $store.isAddingExpense) { ExpenseFormView(expense: nil) }
            .sheet(item: $editing) { ExpenseFormView(expense: $0) }
            .sheet(item: $repeating) { ExpenseFormView(expense: nil, template: $0) }
            .sheet(item: $addingOn) { ExpenseFormView(expense: nil, presetDate: $0.date) }
            // Лёгкая вибрация: «готово» при добавлении, мягкий щелчок при удалении.
            .sensoryFeedback(trigger: store.vault.expenses.count) { old, new in
                new > old ? .success : .impact(weight: .light)
            }
        }
    }

    private func expenseButton(_ expense: Expense, showDate: Bool = false) -> some View {
        Button { editing = expense } label: { ExpenseRow(expense: expense, showDate: showDate) }
            .tint(Color.primary)
            .swipeActions(edge: .leading) {
                Button { repeating = expense } label: { Label("Повторить", systemImage: "arrow.clockwise") }
                    .tint(.accentColor)
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) { store.deleteExpenses(ids: [expense.id]) } label: {
                    Label("Удалить", systemImage: "trash")
                }
            }
            .contextMenu {
                Button { repeating = expense } label: { Label("Повторить", systemImage: "arrow.clockwise") }
                Button { editing = expense } label: { Label("Изменить", systemImage: "pencil") }
                Button(role: .destructive) { store.deleteExpenses(ids: [expense.id]) } label: {
                    Label("Удалить", systemImage: "trash")
                }
            }
    }

    @ViewBuilder
    private func dayDetails(_ items: [Expense]) -> some View {
        Section {
            if items.isEmpty {
                Text("В этот день трат нет.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(items) { expenseButton($0) }
                    .onDelete { offsets in store.deleteExpenses(ids: offsets.map { items[$0].id }) }
            }
            Button {
                addingOn = PresetDay(date: selectedDay)
            } label: {
                Label("Добавить на этот день", systemImage: "plus.circle")
            }
        } header: {
            DayHeader(day: selectedDay, items: items)
        }
    }

    /// В первые 5 дней месяца показываем итог прошлого.
    private var closedMonth: Date? {
        let calendar = Calendar.current
        guard calendar.component(.day, from: .now) <= 5,
              let previous = calendar.date(byAdding: .month, value: -1, to: .now),
              store.vault.expenses.contains(where: { calendar.isDate($0.date, equalTo: previous, toGranularity: .month) })
        else { return nil }
        return previous
    }
}

private struct PresetDay: Identifiable {
    let date: Date
    var id: Date { date }
}

/// Приветствие, итоги дня и месяца, бюджет и большая кнопка «Добавить трату».
private struct SummaryHeader: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        let currency = store.displayCurrency
        let calendar = Calendar.current
        let today = store.vault.expenses.filter { calendar.isDateInToday($0.date) }.total(in: currency)
        let month = store.spentThisMonth(in: currency)

        VStack(alignment: .leading, spacing: 14) {
            Text(RuDate.greeting())
                .font(.title3)
                .foregroundStyle(.secondary)

            AdaptiveRow(spacing: 12) {
                TotalTile(title: "Сегодня", value: currency.format(today.rounded(scale: 2)))
                TotalTile(title: RuDate.monthNominative(.now).capitalized, value: currency.format(month.rounded(scale: 2)))
            }

            Button { store.isAddingExpense = true } label: {
                Label("Добавить трату", systemImage: "plus.circle.fill")
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(.horizontal, 4)
    }
}

private struct TotalTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2.weight(.semibold))
                .monospacedDigit()
                .contentTransition(.numericText())
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 14))
    }
}

/// «Пора оплатить: Аренда 650 $» — одна строка: записать или убрать до следующего месяца.
private struct RecurringCard: View {
    @Environment(AppStore.self) private var store
    let payment: RecurringPayment

    var body: some View {
        HStack(spacing: 12) {
            CategoryIcon(category: store.category(for: payment.categoryID))
            AdaptiveRow(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Пора оплатить")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(payment.note) · \(payment.currency.format(payment.amount))")
                }
                Spacer(minLength: 0)
                Button("Записать") { withAnimation(.snappy) { store.pay(payment) } }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
            }
        }
        .swipeActions {
            Button("Пропустить") { withAnimation(.snappy) { store.skip(payment) } }
                .tint(.gray)
        }
    }
}

/// «Сентябрь закрыт: 1 240 $» → открыть итоги.
private struct MonthClosedCard: View {
    @Environment(AppStore.self) private var store
    let month: Date

    var body: some View {
        let total = store.vault.expenses
            .filter { Calendar.current.isDate($0.date, equalTo: month, toGranularity: .month) }
            .total(in: store.displayCurrency)
        Button {
            store.statsJump = month
            store.selectedTab = .stats
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title2)
                    .foregroundStyle(.tint)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(RuDate.monthNominative(month).capitalized) закрыт")
                        .font(.headline)
                    Text("Потрачено \(store.displayCurrency.format(total.rounded(scale: 0))). Посмотреть итоги")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
        }
        .tint(Color.primary)
    }
}

private struct DayHeader: View {
    @Environment(AppStore.self) private var store
    let day: Date
    let items: [Expense]

    var body: some View {
        let currency = store.displayCurrency
        ViewThatFits(in: .horizontal) {
            HStack {
                Text(RuDate.dayTitle(day))
                Spacer()
                Text(currency.format(items.total(in: currency).rounded(scale: 2)))
                    .monospacedDigit()
            }
            Text(RuDate.dayTitle(day))
        }
        .font(.subheadline.weight(.semibold))
        .textCase(nil)
    }
}

struct ExpenseRow: View {
    @Environment(AppStore.self) private var store
    let expense: Expense
    var showDate = false

    var body: some View {
        let category = store.category(for: expense.categoryID)
        let display = store.displayCurrency
        HStack(alignment: .top, spacing: 12) {
            CategoryIcon(category: category)
            AdaptiveRow(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(expense.note.isEmpty ? category.name : expense.note)
                    Text(subtitle(category))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                VStack(alignment: .trailing, spacing: 2) {
                    Text(expense.currency.format(expense.amount))
                        .fontWeight(.semibold)
                        .monospacedDigit()
                    if expense.currency != display {
                        Text("≈ " + display.format(expense.amount(in: display).rounded(scale: 2)))
                            .font(.subheadline)
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }

    private func subtitle(_ category: ExpenseCategory) -> String {
        let when = showDate ? RuDate.dayTitle(expense.date) : RuDate.time(expense.date)
        return expense.note.isEmpty ? when : "\(category.name) · \(when)"
    }
}

/// Список трат (категории или места из «Итогов»).
struct ExpenseListView: View {
    @Environment(AppStore.self) private var store
    let title: String
    let ids: Set<UUID>
    @State private var editing: Expense?

    // Берём актуальные траты из хранилища, чтобы правки сразу были видны.
    private var expenses: [Expense] {
        store.vault.expenses.filter { ids.contains($0.id) }.sorted { $0.date > $1.date }
    }

    var body: some View {
        List(expenses) { expense in
            Button { editing = expense } label: { ExpenseRow(expense: expense, showDate: true) }
                .tint(Color.primary)
        }
        .warmListBackground()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editing) { ExpenseFormView(expense: $0) }
    }
}
