import SwiftUI

struct ExpenseFormView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    let original: Expense?

    @State private var amountText = ""
    @State private var currency: Currency = .usdt
    @State private var rateText = ""
    @State private var isEditingRate = false
    @State private var note = ""
    @State private var categoryID: UUID?
    @State private var date = Date.now
    @State private var categoryTouched = false
    @State private var currencyTouched = false
    @State private var showAllCategories = false
    @State private var newCategory: ExpenseCategory?
    @State private var isSetUp = false
    @State private var suggestions: [Suggestion] = []
    @State private var confirmDelete = false
    @FocusState private var focus: Field?

    private enum Field { case amount, rate, note }

    init(expense: Expense?) {
        original = expense
    }

    /// Курсы, от которых считаем: у старой траты — её снимок, у новой — текущие.
    private var baseRates: [Currency: Decimal] {
        original?.rates ?? store.vault.rates.effective
    }

    private var amount: Decimal? {
        guard let value = Decimal.parse(amountText), value > 0 else { return nil }
        return value
    }

    private var draft: Expense? {
        guard let amount, let categoryID else { return nil }
        var rates = baseRates
        if currency != .usdt, let rate = Decimal.parse(rateText), rate > 0 { rates[currency] = rate }
        return Expense(id: original?.id ?? UUID(), date: date, amount: amount, currency: currency,
                       categoryID: categoryID, note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                       rates: rates)
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
                Section {
                    DatePicker("Когда", selection: $date)
                }
                if let draft, original != nil {
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
                if original != nil {
                    Section {
                        Button("Удалить трату", role: .destructive) { confirmDelete = true }
                    }
                }
            }
            .warmBackground()
            .navigationTitle(original == nil ? "Новая трата" : "Трата")
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
                    if let original { store.deleteExpenses(ids: [original.id]) }
                    dismiss()
                }
            }
            .sheet(item: $newCategory) { category in
                CategoryEditView(category: category) { saved in
                    categoryID = saved.id
                    categoryTouched = true
                }
            }
            .onAppear(perform: setUp)
            .onChange(of: currency) { _, newValue in
                rateText = (baseRates[newValue] ?? 1).inputString
            }
            .onChange(of: note) { _, newValue in
                // Знакомое место — сразу ставим его категорию, если её не выбирали вручную.
                guard !categoryTouched, let known = SuggestionEngine.exact(newValue, in: suggestions) else { return }
                categoryID = known.categoryID
            }
        }
    }

    // MARK: Сумма и валюта

    private var amountSection: some View {
        Section {
            HStack(alignment: .firstTextBaseline) {
                TextField("0", text: $amountText)
                    .keyboardType(.decimalPad)
                    .font(.largeTitle.weight(.semibold))
                    .monospacedDigit()
                    .focused($focus, equals: .amount)
                    .accessibilityLabel("Сумма")
                Text(currency.symbol)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(currencyChoices) { cur in
                        Button { selectCurrency(cur) } label: {
                            Text("\(cur.flag) \(cur.code)")
                                .font(.body.weight(cur == currency ? .semibold : .regular))
                        }
                        .buttonStyle(.bordered)
                        .tint(cur == currency ? Color.accentColor : Color.secondary)
                        .accessibilityAddTraits(cur == currency ? .isSelected : [])
                    }
                    Menu {
                        ForEach(Currency.allCases) { cur in
                            Button("\(cur.flag) \(cur.code) — \(cur.name)") { selectCurrency(cur) }
                        }
                    } label: {
                        Text("Другая")
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.secondary)
                }
                .padding(.vertical, 2)
            }

            if currency != .usdt {
                if isEditingRate {
                    HStack {
                        Text("1 USDT =")
                            .foregroundStyle(.secondary)
                        TextField("Курс", text: $rateText)
                            .keyboardType(.decimalPad)
                            .monospacedDigit()
                            .multilineTextAlignment(.trailing)
                            .focused($focus, equals: .rate)
                        Text(currency.symbol)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Button {
                        isEditingRate = true
                        focus = .rate
                    } label: {
                        ViewThatFits {
                            HStack {
                                Text("Курс: 1 USDT = \(Fmt.rate(Decimal.parse(rateText) ?? 0)) \(currency.symbol)")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("Изменить")
                            }
                            VStack(alignment: .leading) {
                                Text("Курс: 1 USDT = \(Fmt.rate(Decimal.parse(rateText) ?? 0)) \(currency.symbol)")
                                    .foregroundStyle(.secondary)
                                Text("Изменить")
                            }
                        }
                    }
                }
            }
        } footer: {
            if let draft, draft.currency != store.displayCurrency {
                Text("≈ " + store.displayCurrency.format(draft.amount(in: store.displayCurrency).rounded(scale: 2)))
                    .font(.body)
            }
        }
    }

    /// Последние валюты + текущая, без повторов.
    private var currencyChoices: [Currency] {
        var list = store.quickCurrencies
        if !list.contains(currency) { list.insert(currency, at: 0) }
        return list
    }

    private func selectCurrency(_ cur: Currency) {
        currency = cur
        currencyTouched = true
    }

    // MARK: Категория

    private var categorySection: some View {
        let all = store.categoriesByUsage
        var visible = showAllCategories ? all : Array(all.prefix(8))
        if let categoryID, !visible.contains(where: { $0.id == categoryID }),
           let selected = all.first(where: { $0.id == categoryID }) {
            visible.insert(selected, at: 0)
        }
        return Section {
            CategoryGrid(categories: visible, selection: categoryID) { picked in
                categoryID = picked.id
                categoryTouched = true
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
        categoryTouched = true
        if !currencyTouched, original == nil, let cur = suggestion.currency { currency = cur }
        focus = amount == nil ? .amount : nil
    }

    private func setUp() {
        guard !isSetUp else { return }
        isSetUp = true
        suggestions = store.suggestions
        if let original {
            amountText = original.amount.inputString
            currency = original.currency
            rateText = original.rate(original.currency).inputString
            note = original.note
            categoryID = original.categoryID
            date = original.date
            categoryTouched = true
            currencyTouched = true
        } else {
            currency = store.vault.inputCurrency
            rateText = store.vault.rates.rate(currency).inputString
            focus = .amount
        }
    }

    private func save() {
        guard let draft else { return }
        store.upsert(draft)
        dismiss()
    }
}

/// Плитки категорий: значок и название. Растут вместе со шрифтом.
struct CategoryGrid: View {
    let categories: [ExpenseCategory]
    let selection: UUID?
    let onSelect: (ExpenseCategory) -> Void
    let onAdd: () -> Void
    @ScaledMetric(relativeTo: .body) private var tileWidth: CGFloat = 88

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: tileWidth), spacing: 8)], spacing: 8) {
            ForEach(categories) { category in
                Button { onSelect(category) } label: {
                    tile(icon: CategoryIcon(category: category), title: category.name,
                         selected: category.id == selection)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(category.id == selection ? .isSelected : [])
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
        .background(selected ? Color.accentColor.opacity(0.15) : Color(.tertiarySystemFill),
                    in: .rect(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(selected ? Color.accentColor : .clear, lineWidth: 2)
        }
    }
}
