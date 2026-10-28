import SwiftUI

struct ExpensesView: View {
    @Environment(AppStore.self) private var store
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
        @Bindable var store = store
        NavigationStack {
            List {
                if search.isEmpty {
                    Section { SummaryHeader() }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                }

                if store.vault.expenses.isEmpty {
                    ContentUnavailableView {
                        Label("Пока пусто", systemImage: "leaf")
                    } description: {
                        Text("Нажмите «Добавить трату», и она появится здесь.")
                    }
                    .listRowBackground(Color.clear)
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
                        DayHeader(day: group.day, items: group.items)
                    }
                }
            }
            .warmBackground()
            .navigationTitle("Траты")
            .searchable(text: $search, prompt: "Поиск")
            .overlay {
                if !search.isEmpty && days.isEmpty { ContentUnavailableView.search(text: search) }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { DisplayCurrencyMenu() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { store.isAddingExpense = true } label: { Image(systemName: "plus") }
                        .accessibilityLabel("Добавить трату")
                }
            }
            .sheet(isPresented: $store.isAddingExpense) { ExpenseFormView(expense: nil) }
            .sheet(item: $editing) { ExpenseFormView(expense: $0) }
        }
    }
}

/// Приветствие, итоги дня и месяца и большая кнопка «Добавить трату».
private struct SummaryHeader: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        let currency = store.displayCurrency
        let calendar = Calendar.current
        let today = store.vault.expenses.filter { calendar.isDateInToday($0.date) }.total(in: currency)
        let month = store.vault.expenses
            .filter { calendar.isDate($0.date, equalTo: .now, toGranularity: .month) }
            .total(in: currency)

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
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 14))
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
        .warmBackground()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editing) { ExpenseFormView(expense: $0) }
    }
}
