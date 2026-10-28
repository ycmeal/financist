import SwiftUI

struct ExpenseFormView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    let original: Expense?

    @State private var amountText = ""
    @State private var currency: Currency = .lira
    @State private var rateText = ""
    @State private var note = ""
    @State private var categoryID: UUID?
    @State private var date = Date.now
    @State private var categoryTouched = false
    @State private var currencyTouched = false
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

    private var rates: [Currency: Decimal] {
        var result = baseRates
        if currency != .usdt, let rate = Decimal.parse(rateText), rate > 0 { result[currency] = rate }
        return result
    }

    private var draft: Expense? {
        guard let amount, let categoryID else { return nil }
        return Expense(
            id: original?.id ?? UUID(),
            date: date,
            amount: amount,
            currency: currency,
            categoryID: categoryID,
            note: note.trimmingCharacters(in: .whitespacesAndNewlines),
            rates: rates
        )
    }

    private var matches: [Suggestion] {
        guard focus == .note else { return [] }
        return SuggestionEngine.match(note, in: suggestions)
    }

    var body: some View {
        NavigationStack {
            Form {
                amountSection
                noteSection
                Section {
                    Picker("Категория", selection: categoryBinding) {
                        if categoryID == nil {
                            Text("Не выбрана").tag(UUID?.none)
                        }
                        ForEach(store.vault.categories) { category in
                            Label(category.name, systemImage: category.symbol)
                                .tag(Optional(category.id))
                        }
                    }
                    .pickerStyle(.navigationLink)
                    DatePicker("Дата", selection: $date)
                }
                if original != nil {
                    Section {
                        Button("Удалить трату", role: .destructive) { confirmDelete = true }
                    }
                }
            }
            .navigationTitle(original == nil ? "Новая трата" : "Трата")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") { save() }
                        .disabled(draft == nil)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Готово") { focus = nil }
                }
            }
            .confirmationDialog("Удалить эту трату?", isPresented: $confirmDelete, titleVisibility: .visible) {
                Button("Удалить", role: .destructive) {
                    if let original { store.deleteExpenses(ids: [original.id]) }
                    dismiss()
                }
            }
            .onAppear(perform: setUp)
            .onChange(of: currency) { _, newValue in
                rateText = (baseRates[newValue] ?? 1).inputString
            }
            .onChange(of: note) { _, newValue in
                // Знакомое место — сразу ставим его категорию, если пользователь её не выбирал сам.
                guard !categoryTouched, let known = SuggestionEngine.exact(newValue, in: suggestions) else { return }
                categoryID = known.categoryID
            }
        }
    }

    private var amountSection: some View {
        Section {
            HStack {
                TextField("Сумма", text: $amountText)
                    .keyboardType(.decimalPad)
                    .font(.title2)
                    .monospacedDigit()
                    .focused($focus, equals: .amount)
                Picker("Валюта", selection: currencyBinding) {
                    ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
                }
                .labelsHidden()
            }
            if currency != .usdt {
                HStack {
                    Text("Курс: 1 USDT =")
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
            if let draft {
                Text(conversionLine(draft))
            }
        }
    }

    private var noteSection: some View {
        Section {
            TextField("Где или на что (Migros, аптека…)", text: $note)
                .focused($focus, equals: .note)
                .submitLabel(.done)
            ForEach(matches) { suggestion in
                Button { apply(suggestion) } label: {
                    let category = store.category(for: suggestion.categoryID)
                    HStack(spacing: 12) {
                        CategoryIcon(category: category)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(suggestion.note)
                            Text(category.name)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if let last = suggestion.lastAmount, let cur = suggestion.currency {
                            Text(cur.format(last))
                                .font(.caption)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .tint(Color.primary)
            }
        } header: {
            Text("Заметка")
        } footer: {
            if !matches.isEmpty {
                Text("Подсказки из твоих прошлых трат — нажми, чтобы подставить место и категорию.")
            }
        }
    }

    private var categoryBinding: Binding<UUID?> {
        Binding(get: { categoryID }, set: { categoryID = $0; categoryTouched = true })
    }

    private var currencyBinding: Binding<Currency> {
        Binding(get: { currency }, set: { currency = $0; currencyTouched = true })
    }

    private func conversionLine(_ expense: Expense) -> String {
        let targets = [Currency.usdt, store.displayCurrency]
            .reduce(into: [Currency]()) { if !$0.contains($1) && $1 != expense.currency { $0.append($1) } }
        guard !targets.isEmpty else { return "" }
        return "≈ " + targets.map { $0.format(expense.amount(in: $0).rounded(scale: 2)) }.joined(separator: " · ")
    }

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
            currency = store.inputCurrency
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
