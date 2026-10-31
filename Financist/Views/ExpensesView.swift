import SwiftUI

struct ExpensesView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.palette) private var palette
    @State private var editing: Expense?
    @State private var viewing: Expense?
    @State private var repeating: Expense?
    @State private var isSearching = false
    @State private var showingSubscriptions = false
    @State private var buildWarningHidden = false
    @State private var openedTrial: Trial?
    /// Ввод траты «вырастает» из кнопки, правка — из строки траты (iOS 18).
    @Namespace private var zoom

    private func groupedDays(_ expenses: [Expense]) -> [(day: Date, items: [Expense])] {
        let groups = Dictionary(grouping: expenses) { Calendar.current.startOfDay(for: $0.date) }
        return groups.keys.sorted(by: >).map { day in
            (day, groups[day]!.sorted { $0.date > $1.date })
        }
    }

    var body: some View {
        @Bindable var store = store
        // Группировка считается один раз за отрисовку — список не подтормаживает.
        let days = groupedDays(store.vault.expenses)
        let place = store.headerPlace

        NavigationStack {
            GeometryReader { geo in
                List {
                    // Наверху — пиксельный город (фоном списка), поверх неба — приветствие.
                    Section {
                        CityGreeting(place: place)
                            .dynamicTypeSize(...DynamicTypeSize.xLarge)
                            .frame(minHeight: greetingHeight(geo), alignment: .top)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 0, trailing: 20))

                    Section { SummaryHeader(zoom: zoom) }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))

                    if !buildWarningHidden && BuildAge.shouldWarn() {
                        Section {
                            BuildExpiryNotice {
                                BuildAge.snooze()
                                withAnimation(.snappy) { buildWarningHidden = true }
                            }
                        }
                    }

                    // Пробная подписка видна здесь только за 5 дней до списания; все подписки — в кнопке вверху.
                    let soon = store.trialsDueSoon
                    if !soon.isEmpty {
                        Section {
                            ForEach(soon) { trial in
                                Button { openedTrial = trial } label: {
                                    TrialRow(trial: trial, subtitle: trial.needsDecision()
                                             ? "Пора решить · \(trial.chargeText())" : trial.chargeText(),
                                             highlighted: true)
                                }
                                .tint(Color.primary)
                            }
                        } header: {
                            Text("Подписки")
                        }
                    }

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

                    if store.vault.expenses.isEmpty {
                        ContentUnavailableView {
                            Label("Пока пусто", systemImage: "leaf")
                        } description: {
                            Text("Нажмите «Добавить трату», и она появится здесь.")
                        }
                        .listRowBackground(Color.clear)
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
                .contentMargins(.top, 0, for: .scrollContent)
                .background(alignment: .top) {
                    CityBackdrop(place: place, visit: store.headerVisit)
                        .ignoresSafeArea(edges: .top)
                }
                .warmListBackground()
            }
            .animation(.snappy, value: store.vault.expenses)
            .navigationTitle("Траты")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Заголовок не пишем: верх экрана — картинка; «Траты» и так на вкладке.
                ToolbarItem(placement: .principal) { Text("") }
                ToolbarItem(placement: .topBarLeading) { DisplayCurrencyMenu() }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if !store.openTrials.isEmpty || !store.upcomingCharges.isEmpty {
                        Button("Подписки") { showingSubscriptions = true }
                    }
                    if !store.vault.expenses.isEmpty {
                        Button { isSearching = true } label: { Image(systemName: "magnifyingglass") }
                            .accessibilityLabel("Поиск")
                    }
                }
            }
            // Новая трата — на весь экран: сумма, потом «На что?». Правка — обычной формой.
            .fullScreenCover(isPresented: $store.isAddingExpense) { AddExpenseView().zoomDestination("add", in: zoom) }
            .fullScreenCover(item: $repeating) { AddExpenseView(template: $0).zoomDestination($0.id, in: zoom) }
            .sheet(isPresented: $isSearching) { ExpenseSearchView() }
            .sheet(isPresented: $showingSubscriptions) { SubscriptionsView() }
            .sheet(item: $viewing) { ExpenseDetailView(expense: $0).zoomDestination($0.id, in: zoom) }
            .sheet(item: $editing) { ExpenseFormView(expense: $0) }
            .sheet(item: $openedTrial) { TrialEditView(trial: $0) }
            // Нажали на напоминание о пробной подписке — сразу спрашиваем про неё.
            .onChange(of: store.trialToOpen, initial: true) {
                guard let id = store.trialToOpen else { return }
                store.trialToOpen = nil
                openedTrial = store.vault.trials.first { $0.id == id }
            }
            // Лёгкая вибрация: «готово» при добавлении, мягкий щелчок при удалении.
            .sensoryFeedback(trigger: store.vault.expenses.count) { old, new in
                new > old ? .success : .impact(weight: .light)
            }
            .undoToast()
        }
    }

    /// Высота строки с приветствием: итоги начинаются там, где город уходит в фон.
    /// Город — 56/64 ширины экрана от самого верха; сверху его закрывают строка состояния и панель.
    private func greetingHeight(_ geo: GeometryProxy) -> CGFloat {
        let city = geo.size.width * CGFloat(PixelCity.rows) / CGFloat(PixelCity.cols)
        return max(110, city - geo.safeAreaInsets.top - 34)
    }

    private func expenseButton(_ expense: Expense) -> some View {
        // Нажатие — карточка траты; «Изменить» из меню — сразу форма правки.
        Button { viewing = expense } label: { ExpenseRow(expense: expense) }
            .tint(Color.primary)
            .zoomSource(expense.id, in: zoom)
            .swipeActions(edge: .leading) {
                Button { repeating = expense } label: { Label("Повторить", systemImage: "arrow.clockwise") }
                    .tint(palette.accent)
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

/// Тихая плашка: сборка из TestFlight скоро истечёт.
private struct BuildExpiryNotice: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text("Эта версия скоро перестанет открываться — попроси сына обновить. Траты не пропадут.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } icon: {
                Image(systemName: "arrow.down.app")
                    .foregroundStyle(.tint)
            }
            Button("Понятно", action: onDismiss)
                .font(.subheadline)
                .buttonStyle(.borderless)
        }
        .padding(.vertical, 2)
    }
}

/// Итоги дня и месяца и большая кнопка «Добавить трату».
private struct SummaryHeader: View {
    @Environment(AppStore.self) private var store
    let zoom: Namespace.ID

    var body: some View {
        let currency = store.displayCurrency
        let calendar = Calendar.current
        let today = store.vault.expenses.filter { calendar.isDateInToday($0.date) }.total(in: currency)
        let month = store.spentThisMonth(in: currency)

        VStack(alignment: .leading, spacing: 14) {
            // Плитки всегда рядом: при крупном шрифте сумма уменьшается, а не ломает строку.
            HStack(spacing: 12) {
                TotalTile(title: "Сегодня", value: currency.format(today.rounded(scale: 2)))
                TotalTile(title: RuDate.monthNominative(.now).capitalized, value: currency.format(month.rounded(scale: 2)))
            }

            // Лимит на месяц (Настройки → Лимит на месяц): сколько потрачено и сколько осталось.
            if let progress = store.limitProgress() {
                LimitBar(progress: progress)
            }

            Button { store.isAddingExpense = true } label: {
                // «+» — часть самой надписи, поэтому всегда того же цвета, что и текст (а не акцентного, как у Label).
                Text("\(Image(systemName: "plus")) Добавить трату")
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel("Добавить трату")
            .controlSize(.large)
            .zoomSource("add", in: zoom)
        }
        .padding(.horizontal, 4)
        // Шрифт растёт вместе с настройками iPhone, но умеренно: иначе плитки и кнопка разъезжаются.
        .dynamicTypeSize(...DynamicTypeSize.xLarge)
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
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))
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

struct DayHeader: View {
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
    /// Как у CategoryIcon: время под значком не шире самого значка.
    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 34

    var body: some View {
        let category = store.category(for: expense.categoryID)
        // Каждая трата — в двух валютах: вторая всегда доллары, а у трат в долларах — валюта итогов или ввода.
        let second = [Currency.usd, store.displayCurrency, store.vault.inputCurrency].first { $0 != expense.currency }
        HStack(alignment: .top, spacing: 12) {
            // Время — мелко под значком, чтобы в строке не было «категория · время · оплата» подряд.
            VStack(spacing: 5) {
                CategoryIcon(category: category)
                Text(RuDate.time(expense.date))
                    .font(.caption2)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(width: iconSize)
            }
            AdaptiveRow(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(expense.note.isEmpty ? category.name : expense.note)
                    let sub = subtitle(category)
                    if !sub.isEmpty {
                        Text(sub)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 0)
                VStack(alignment: .trailing, spacing: 2) {
                    Text(expense.currency.format(expense.amount))
                        .fontWeight(.semibold)
                        .monospacedDigit()
                    if let second {
                        Text("≈ " + second.format(expense.amount(in: second).rounded(scale: second.fractionDigits)))
                            .font(.subheadline)
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }

    /// «Продукты · картой»; в списках из «Итогов» и поиска — ещё и день: «Продукты · Пн, 26 октября · картой».
    private func subtitle(_ category: ExpenseCategory) -> String {
        var parts: [String] = []
        if !expense.note.isEmpty { parts.append(category.name) }
        if showDate { parts.append(RuDate.dayTitle(expense.date)) }
        if let payment = expense.payment { parts.append(payment.phrase) }
        return parts.joined(separator: " · ")
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
        .sheet(item: $editing) { ExpenseDetailView(expense: $0) }
    }
}
