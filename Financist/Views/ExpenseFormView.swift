import SwiftUI

struct ExpenseFormView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.palette) private var palette
    @Environment(\.dismiss) private var dismiss

    let original: Expense?

    @State private var amountText = ""
    @State private var currency: Currency = .lira
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
    @State private var templates: [Expense] = []
    @State private var orderedCategories: [ExpenseCategory] = []
    @State private var confirmDelete = false
    @State private var isScanning = false
    @State private var scanStatus: String?
    @FocusState private var focus: Field?
    private let template: Expense?
    private let presetDate: Date?

    private enum Field { case amount, rate, note }

    /// `template` — повтор прошлой траты: всё заполнено, дата — сейчас.
    init(expense: Expense?, template: Expense? = nil, presetDate: Date? = nil) {
        original = expense
        self.template = template
        self.presetDate = presetDate
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
        if currency != .base, let rate = Decimal.parse(rateText), rate > 0 { rates[currency] = rate }
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
                if original == nil && amountText.isEmpty && !templates.isEmpty {
                    recentSection
                }
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
            .warmListBackground()
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
                    orderedCategories.insert(saved, at: 0)
                    categoryID = saved.id
                    categoryTouched = true
                }
            }
            .fullScreenCover(isPresented: $isScanning) {
                CameraPicker { image in
                    isScanning = false
                    if let image { Task { await readReceipt(image) } }
                }
                .ignoresSafeArea()
            }
            .sensoryFeedback(.selection, trigger: categoryID)
            .sensoryFeedback(.selection, trigger: currency)
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
            HStack(spacing: 10) {
                TextField("0", text: $amountText)
                    .keyboardType(.decimalPad)
                    .font(.largeTitle.weight(.semibold))
                    .monospacedDigit()
                    .focused($focus, equals: .amount)
                    .accessibilityLabel("Сумма")
                if original == nil {
                    Button { isScanning = true } label: {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.title3)
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("Сканировать чек")
                }
                currencyMenu
            }

            if let scanStatus {
                Label(scanStatus, systemImage: "doc.text.viewfinder")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if currency != .base && isEditingRate {
                HStack {
                    Text("Курс: 1 USD =")
                        .foregroundStyle(.secondary)
                    TextField("Курс", text: $rateText)
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

    /// Недавние траты отдельным тихим блоком: одно касание — всё заполнено.
    private var recentSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(templates.prefix(5))) { expense in
                        Button { fill(from: expense) } label: {
                            HStack(spacing: 7) {
                                Text(expense.note)
                                Text(expense.currency.format(expense.amount))
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        } header: {
            Text("Недавние")
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
        Button { selectCurrency(cur) } label: {
            if cur == currency {
                Label("\(cur.flag) \(cur.code) — \(cur.name)", systemImage: "checkmark")
            } else {
                Text("\(cur.flag) \(cur.code) — \(cur.name)")
            }
        }
    }

    @ViewBuilder
    private var conversionText: some View {
        if let draft, draft.currency != store.displayCurrency {
            Text("≈ " + store.displayCurrency.format(draft.amount(in: store.displayCurrency).rounded(scale: 2)))
        }
    }

    @ViewBuilder
    private var rateLink: some View {
        if currency != .base && !isEditingRate {
            Button {
                withAnimation(.snappy) { isEditingRate = true }
                focus = .rate
            } label: {
                Text("1 USD = \(Fmt.rate(Decimal.parse(rateText) ?? 0)) \(currency.symbol) · ")
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

    private func selectCurrency(_ cur: Currency) {
        currency = cur
        currencyTouched = true
        isEditingRate = false
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
        // Считаем один раз при открытии, чтобы ввод не подтормаживал.
        suggestions = store.suggestions
        templates = store.recentTemplates
        orderedCategories = store.categoriesByUsage
        if let original {
            amountText = original.amount.inputString
            currency = original.currency
            rateText = original.rate(original.currency).inputString
            note = original.note
            categoryID = original.categoryID
            date = original.date
            categoryTouched = true
            currencyTouched = true
        } else if let template {
            fill(from: template)
        } else {
            currency = store.vault.inputCurrency
            rateText = store.vault.rates.rate(currency).inputString
            if let presetDate {
                // День из календаря, время — текущее.
                let time = Calendar.current.dateComponents([.hour, .minute], from: .now)
                date = Calendar.current.date(bySettingHour: time.hour ?? 12, minute: time.minute ?? 0,
                                             second: 0, of: presetDate) ?? presetDate
            }
            focus = .amount
        }
    }

    /// Заполняет форму прошлой тратой: сумма, валюта, категория, комментарий. Дата — сейчас.
    private func fill(from expense: Expense) {
        withAnimation(.snappy) {
            amountText = expense.amount.inputString
            currency = expense.currency
            rateText = store.vault.rates.rate(expense.currency).inputString
            note = expense.note
            categoryID = expense.categoryID
            date = .now
        }
        categoryTouched = true
        currencyTouched = true
    }

    private func readReceipt(_ image: UIImage) async {
        scanStatus = "Читаю чек…"
        let result = await ReceiptScanner.scan(image)
        withAnimation(.snappy) {
            if let amount = result.amount { amountText = amount.inputString }
            if let merchant = result.merchant, note.isEmpty {
                // Знакомый магазин — берём привычное название и категорию.
                let key = SuggestionEngine.normalize(merchant)
                if let known = suggestions.first(where: { key.contains($0.id) }) {
                    note = known.note
                    if !categoryTouched { categoryID = known.categoryID }
                } else {
                    note = merchant.capitalized
                }
            }
        }
        scanStatus = result.amount == nil
            ? "Сумму не нашёл — введите вручную"
            : "Проверьте сумму · сканировать ещё раз"
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
        .fontWeight(selected ? .semibold : .regular)
        .background(selected ? palette.accent.opacity(0.15) : Color.clear, in: .rect(cornerRadius: 12))
    }
}
