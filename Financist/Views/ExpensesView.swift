import SwiftUI

struct ExpensesView: View {
    @Environment(AppStore.self) private var store
    @State private var isCreating = false
    @State private var editing: Expense?
    @State private var search = ""

    private var filtered: [Expense] {
        let all = store.vault.expenses
        guard !search.isEmpty else { return all }
        return all.filter {
            $0.note.localizedCaseInsensitiveContains(search)
                || store.category(for: $0.categoryID).name.localizedCaseInsensitiveContains(search)
        }
    }

    private var days: [(day: Date, items: [Expense])] {
        let groups = Dictionary(grouping: filtered) { Calendar.current.startOfDay(for: $0.date) }
        return groups.keys.sorted(by: >).map { day in
            (day, groups[day]!.sorted { $0.date > $1.date })
        }
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Траты")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) { DisplayCurrencyMenu() }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { isCreating = true } label: { Image(systemName: "plus") }
                            .accessibilityLabel("Добавить трату")
                    }
                }
                .sheet(isPresented: $isCreating) { ExpenseFormView(expense: nil) }
                .sheet(item: $editing) { ExpenseFormView(expense: $0) }
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.vault.expenses.isEmpty {
            ContentUnavailableView {
                Label("Пока нет трат", systemImage: "creditcard")
            } description: {
                Text("Нажми «+», чтобы записать первую трату.")
            } actions: {
                Button("Добавить трату") { isCreating = true }
                    .buttonStyle(.borderedProminent)
            }
        } else {
            let currency = store.displayCurrency
            List {
                if search.isEmpty {
                    Section { PeriodTotalsRows() }
                }
                ForEach(days, id: \.day) { group in
                    Section {
                        ForEach(group.items) { expense in
                            Button { editing = expense } label: { ExpenseRow(expense: expense) }
                                .tint(Color.primary)
                        }
                        .onDelete { offsets in
                            store.deleteExpenses(ids: offsets.map { group.items[$0].id })
                        }
                    } header: {
                        HStack {
                            Text(Fmt.dayTitle(group.day))
                            Spacer()
                            Text(currency.format(group.items.reduce(Decimal(0)) { $0 + $1.amount(in: currency) }.rounded(scale: 2)))
                                .monospacedDigit()
                        }
                    }
                }
            }
            .searchable(text: $search, prompt: "Заметка или категория")
            .overlay {
                if !search.isEmpty && days.isEmpty { ContentUnavailableView.search(text: search) }
            }
            .refreshable { await store.refreshRates(force: true) }
        }
    }
}

/// «Сегодня» и «В этом месяце» в валюте отображения.
struct PeriodTotalsRows: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        let currency = store.displayCurrency
        let calendar = Calendar.current
        let today = store.vault.expenses.filter { calendar.isDateInToday($0.date) }
        let month = store.vault.expenses.filter { calendar.isDate($0.date, equalTo: .now, toGranularity: .month) }
        LabeledContent("Сегодня", value: currency.format(sum(today, currency)))
        LabeledContent("В этом месяце", value: currency.format(sum(month, currency)))
    }

    private func sum(_ items: [Expense], _ currency: Currency) -> Decimal {
        items.reduce(Decimal(0)) { $0 + $1.amount(in: currency) }.rounded(scale: 2)
    }
}

struct ExpenseRow: View {
    @Environment(AppStore.self) private var store
    let expense: Expense
    var showDate = false

    var body: some View {
        let category = store.category(for: expense.categoryID)
        let display = store.displayCurrency
        HStack(spacing: 12) {
            CategoryIcon(category: category)
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.note.isEmpty ? category.name : expense.note)
                    .lineLimit(1)
                Text(subtitle(category))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(expense.currency.format(expense.amount))
                    .monospacedDigit()
                if expense.currency != display {
                    Text("≈ " + display.format(expense.amount(in: display).rounded(scale: 2)))
                        .font(.caption)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func subtitle(_ category: ExpenseCategory) -> String {
        let time = showDate
            ? expense.date.formatted(.dateTime.day().month(.abbreviated))
            : expense.date.formatted(date: .omitted, time: .shortened)
        return expense.note.isEmpty ? time : "\(category.name) · \(time)"
    }
}

struct CategoryIcon: View {
    let category: ExpenseCategory

    var body: some View {
        Image(systemName: category.symbol)
            .font(.subheadline)
            .foregroundStyle(.white)
            .frame(width: 30, height: 30)
            .background(category.color.gradient, in: .rect(cornerRadius: 7))
    }
}

struct DisplayCurrencyMenu: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        @Bindable var store = store
        Menu {
            Picker("Показывать в валюте", selection: $store.displayCurrency) {
                ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
            }
        } label: {
            Label(store.displayCurrency.code, systemImage: "dollarsign.arrow.circlepath")
                .labelStyle(.titleAndIcon)
        }
        .accessibilityLabel("Валюта отображения")
    }
}

/// Список трат (например, одной категории в аналитике).
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
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editing) { ExpenseFormView(expense: $0) }
    }
}
