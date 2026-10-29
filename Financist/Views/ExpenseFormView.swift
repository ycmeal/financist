import SwiftUI

/// Правка записанной траты: сумма и курс, категория, комментарий, день. Новые траты — в AddExpenseView.
struct ExpenseFormView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.palette) private var palette
    @Environment(\.dismiss) private var dismiss

    let original: Expense

    @State private var amountText = ""
    @State private var currency: Currency = .lira
    @State private var rateText = ""
    @State private var isEditingRate = false
    /// Курс введён вручную для этой траты — тогда он главнее курса дня.
    @State private var rateTouched = false
    @State private var note = ""
    @State private var categoryID: UUID?
    @State private var date = Date.now
    @State private var pickingOtherDay = false
    @State private var showAllCategories = false
    @State private var newCategory: ExpenseCategory?
    @State private var isSetUp = false
    @State private var suggestions: [Suggestion] = []
    @State private var orderedCategories: [ExpenseCategory] = []
    @State private var confirmDelete = false
    @FocusState private var focus: Field?

    private enum Field { case amount, rate, note }

    init(expense: Expense) {
        original = expense
    }

    /// Курсы дня траты: если день не меняли — её снимок; иначе — курсы выбранного дня.
    /// exact = false: курсы этого дня ещё не загружены, трата уточнится сама.
    private var dayRates: (rates: [Currency: Decimal], exact: Bool) {
        if Calendar.current.isDate(original.date, inSameDayAs: date) {
            return (original.rates, !original.ratesPending)
        }
        return store.ratesForDay(date, currency: currency)
    }

    /// Курс валюты траты, который сейчас действует: введённый вручную или курс дня.
    private var currentRate: Decimal {
        if rateTouched, let typed = Decimal.parse(rateText), typed > 0 { return typed }
        // Как в Expense.rate: если в снимке старой траты нет этой валюты — запасной курс.
        return dayRates.rates[currency] ?? Currency.fallbackPerUSD[currency] ?? 1
    }

    private var amount: Decimal? {
        guard let value = Decimal.parse(amountText), value > 0 else { return nil }
        return value
    }

    private var draft: Expense? {
        guard let amount, let categoryID else { return nil }
        let day = dayRates
        var rates = day.rates
        var pending = !day.exact
        if rateTouched, currency != .base, let rate = Decimal.parse(rateText), rate > 0 {
            rates[currency] = rate
            pending = false
        }
        return Expense(id: original.id, date: date, amount: amount, currency: currency,
                       categoryID: categoryID, note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                       rates: rates, recurringID: original.recurringID, ratesPending: pending)
    }

    private var matches: [Suggestion] {
        guard focus == .note else { return [] }
        return SuggestionEngine.match(note, in: suggestions)
    }

    var body: some View {
        NavigationStack {
            Form {
                amountSection
                categorySection
                noteSection
                whenSection
                if let draft {
                    conversionSection(draft)
                }
                Section {
                    Button { save() } label: {
                        Text("Сохранить")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(draft == nil)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                } footer: {
                    if draft == nil {
                        Text(amount == nil ? "Введите сумму." : "Выберите категорию.")
                    }
                }
                Section {
                    Button("Удалить трату", role: .destructive) { confirmDelete = true }
                }
            }
            .warmListBackground()
            .navigationTitle("Трата")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { save() }
                        .disabled(draft == nil)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Скрыть") { focus = nil }
                }
            }
            .confirmationDialog("Удалить эту трату?", isPresented: $confirmDelete, titleVisibility: .visible) {
                Button("Удалить", role: .destructive) {
                    store.deleteExpenses(ids: [original.id])
                    dismiss()
                }
            } message: {
                Text("Её можно будет вернуть в течение \(DeletedExpense.keepDays) дней: Настройки → Недавно удалённые.")
            }
            .sheet(item: $newCategory) { category in
                CategoryEditView(category: category) { saved in
                    orderedCategories.insert(saved, at: 0)
                    categoryID = saved.id
                }
            }
            .sensoryFeedback(.selection, trigger: categoryID)
            .sensoryFeedback(.selection, trigger: currency)
            .onAppear(perform: setUp)
            .onChange(of: currency) {
                // Введённый вручную курс относился к прежней валюте.
                rateTouched = false
                isEditingRate = false
            }
        }
    }

    // MARK: Сумма и валюта

    private var amountSection: some View {
        Section {
            HStack(spacing: 10) {
                TextField("0", text: $amountText)
                    .keyboardType(.decimalPad)
                    .font(.largeTitle.weight(.semibold))
                    .monospacedDigit()
                    .focused($focus, equals: .amount)
                    .accessibilityLabel("Сумма")
                currencyMenu
            }

            if currency != .base && isEditingRate {
                HStack {
                    Text("Курс: 1 USD =")
                        .foregroundStyle(.secondary)
                    TextField("Курс", text: Binding(get: { rateText },
                                                   set: { rateText = $0; rateTouched = true }))
                        .keyboardType(.decimalPad)
                        .monospacedDigit()
                        .multilineTextAlignment(.trailing)
                        .focused($focus, equals: .rate)
                    Text(currency.symbol)
                        .foregroundStyle(.secondary)
                }
            }
        } footer: {
            // Тонкая подпись: пересчёт и курс, который можно поправить.
            ViewThatFits(in: .horizontal) {
                HStack { conversionText; Spacer(); rateLink }
                VStack(alignment: .leading, spacing: 4) { conversionText; rateLink }
            }
        }
    }

    /// Кнопка валюты справа от суммы: по нажатию — список, недавние сверху.
    private var currencyMenu: some View {
        Menu {
            Section("Недавние") {
                ForEach(currencyChoices) { currencyItem($0) }
            }
            Section("Все валюты") {
                ForEach(Currency.allCases.filter { !currencyChoices.contains($0) }) { currencyItem($0) }
            }
        } label: {
            HStack(spacing: 4) {
                Text("\(currency.flag) \(currency.code)")
                    .fontWeight(.semibold)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(Color.primary)
        .accessibilityLabel("Валюта: \(currency.name)")
    }

    private func currencyItem(_ cur: Currency) -> some View {
        Button {
            currency = cur
            isEditingRate = false
        } label: {
            if cur == currency {
                Label("\(cur.flag) \(cur.code) — \(cur.name)", systemImage: "checkmark")
            } else {
                Text("\(cur.flag) \(cur.code) — \(cur.name)")
            }
        }
    }

    @ViewBuilder
    private var conversionText: some View {
        let display = store.displayCurrency
        if let draft, draft.currency != display {
            Text("≈ " + display.format(draft.amount(in: display).rounded(scale: 2)))
        }
    }

    @ViewBuilder
    private var rateLink: some View {
        if currency != .base && !isEditingRate {
            let approximate = !dayRates.exact && !rateTouched
            Button {
                rateText = currentRate.inputString
                withAnimation(.snappy) { isEditingRate = true }
                focus = .rate
            } label: {
                // «≈» и «уточнится»: курсы этого дня ещё не загружены, трата пересчитается сама.
                Text("1 USD \(approximate ? "≈" : "=") \(Fmt.rate(currentRate)) \(currency.symbol)\(approximate ? ", уточнится" : "") · ")
                    .foregroundStyle(.secondary)
                + Text("изменить")
                    .foregroundStyle(palette.accent)
            }
            .font(.footnote)
        }
    }

    /// Последние валюты + текущая, без повторов.
    private var currencyChoices: [Currency] {
        var list = store.quickCurrencies
        if !list.contains(currency) { list.insert(currency, at: 0) }
        return list
    }

    // MARK: Категория

    private var categorySection: some View {
        let all = orderedCategories
        var visible = showAllCategories ? all : Array(all.prefix(8))
        if let categoryID, !visible.contains(where: { $0.id == categoryID }),
           let selected = all.first(where: { $0.id == categoryID }) {
            visible.insert(selected, at: 0)
        }
        return Section {
            CategoryGrid(categories: visible, selection: categoryID) { picked in
                categoryID = picked.id
            } onAdd: {
                newCategory = ExpenseCategory(name: "", symbol: "star.fill", colorName: "orange")
            }
            if all.count > 8 {
                Button(showAllCategories ? "Свернуть" : "Все категории (\(all.count))") {
                    withAnimation { showAllCategories.toggle() }
                }
            }
        } header: {
            Text("Категория")
        }
    }

    // MARK: Комментарий

    private var noteSection: some View {
        Section {
            TextField("Например: Migros, аптека", text: $note)
                .focused($focus, equals: .note)
                .submitLabel(.done)
            ForEach(matches) { suggestion in
                Button { apply(suggestion) } label: {
                    HStack(spacing: 12) {
                        CategoryIcon(category: store.category(for: suggestion.categoryID))
                        Text(suggestion.note)
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.up.left")
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(Color.primary)
            }
        } header: {
            Text("Комментарий")
        } footer: {
            if !matches.isEmpty {
                Text("Нажмите на подсказку — подставится и категория.")
            }
        }
    }

    // MARK: Когда

    private enum Day: Hashable { case today, yesterday, other }

    private var whenSection: some View {
        Section {
            Picker("Когда", selection: dayBinding.animation(.snappy)) {
                Text("Сегодня").tag(Day.today)
                Text("Вчера").tag(Day.yesterday)
                Text("Другой").tag(Day.other)
            }
            .pickerStyle(.segmented)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())

            if dayBinding.wrappedValue == .other {
                DatePicker("Дата", selection: $date, in: ...Date.now)
            }
        } header: {
            Text("Когда")
        }
    }

    private var dayBinding: Binding<Day> {
        Binding(
            get: {
                let calendar = Calendar.current
                if pickingOtherDay { return .other }
                if calendar.isDateInToday(date) { return .today }
                if calendar.isDateInYesterday(date) { return .yesterday }
                return .other
            },
            set: { day in
                pickingOtherDay = day == .other
                guard day != .other else { return }
                // Меняем только день, время оставляем текущим.
                let calendar = Calendar.current
                let base = calendar.date(byAdding: .day, value: day == .yesterday ? -1 : 0, to: .now) ?? .now
                let time = calendar.dateComponents([.hour, .minute], from: day == .today ? .now : date)
                date = calendar.date(bySettingHour: time.hour ?? 12, minute: time.minute ?? 0, second: 0, of: base) ?? base
            }
        )
    }

    // MARK: Пересчёт

    private func conversionSection(_ expense: Expense) -> some View {
        Section("В других валютах") {
            ForEach(Currency.allCases.filter { $0 != expense.currency }) { target in
                LabeledContent("\(target.flag) \(target.code)") {
                    Text(target.format(expense.amount(in: target).rounded(scale: target.fractionDigits)))
                        .monospacedDigit()
                }
            }
        }
    }

    // MARK: Действия

    private func apply(_ suggestion: Suggestion) {
        note = suggestion.note
        categoryID = suggestion.categoryID
        focus = nil
    }

    private func setUp() {
        guard !isSetUp else { return }
        isSetUp = true
        // Считаем один раз при открытии, чтобы ввод не подтормаживал.
        suggestions = store.suggestions
        orderedCategories = store.categoriesByUsage
        amountText = original.amount.inputString
        currency = original.currency
        note = original.note
        categoryID = original.categoryID
        date = original.date
    }

    private func save() {
        guard let draft else { return }
        store.upsert(draft)
        dismiss()
    }
}

/// Плитки категорий: значок и название. Растут вместе со шрифтом.
struct CategoryGrid: View {
    @Environment(\.palette) private var palette
    let categories: [ExpenseCategory]
    let selection: UUID?
    let onSelect: (ExpenseCategory) -> Void
    let onAdd: () -> Void
    @ScaledMetric(relativeTo: .body) private var tileWidth: CGFloat = 88

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: tileWidth), spacing: 8)], spacing: 8) {
            ForEach(categories) { category in
                Button { onSelect(category) } label: {
                    tile(icon: CategoryIcon(category: category).overlay(alignment: .topTrailing) {
                             if category.isSubscription { SubscriptionBadge() }
                         },
                         title: category.name, selected: category.id == selection)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(category.id == selection ? .isSelected : [])
                .accessibilityHint(category.isSubscription ? "Пробная подписка с напоминанием о списании" : "")
            }
            Button(action: onAdd) {
                tile(icon: Image(systemName: "plus").font(.title2).foregroundStyle(.tint),
                     title: "Своя", selected: false)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Новая категория")
        }
        .padding(.vertical, 4)
    }

    private func tile(icon: some View, title: String, selected: Bool) -> some View {
        VStack(spacing: 6) {
            icon
            Text(title)
                .font(.footnote)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, minHeight: tileWidth * 0.85)
        .padding(.vertical, 6)
        .fontWeight(selected ? .semibold : .regular)
        .background(selected ? palette.accent.opacity(0.15) : Color.clear, in: .rect(cornerRadius: 12))
    }
}
