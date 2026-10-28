import SwiftUI

/// Бюджет на месяц: сумма и валюта. На главном экране — полоска «осталось».
struct BudgetView: View {
    @Environment(AppStore.self) private var store
    @State private var enabled = false
    @State private var amountText = ""
    @State private var currency: Currency = .usd
    @State private var isSetUp = false
    @FocusState private var focused: Bool

    var body: some View {
        Form {
            Section {
                Toggle("Бюджет на месяц", isOn: $enabled.animation(.snappy))
            } footer: {
                Text("На главном экране появится полоска: сколько осталось и сколько можно тратить в день.")
            }
            if enabled {
                Section {
                    HStack(alignment: .firstTextBaseline) {
                        TextField("Сумма", text: $amountText)
                            .keyboardType(.decimalPad)
                            .font(.title.weight(.semibold))
                            .monospacedDigit()
                            .focused($focused)
                        Picker("Валюта", selection: $currency) {
                            ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
                        }
                        .labelsHidden()
                    }
                } footer: {
                    let spent = store.spentThisMonth(in: currency)
                    Text("В этом месяце уже потрачено \(currency.format(spent.rounded(scale: 0))).")
                }
            }
        }
        .warmListBackground()
        .navigationTitle("Бюджет")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard !isSetUp else { return }
            isSetUp = true
            enabled = store.budget != nil
            currency = store.budget?.currency ?? store.displayCurrency
            amountText = store.budget?.amount.inputString ?? ""
        }
        .onDisappear(perform: save)
        .onChange(of: enabled) { if enabled { focused = true } else { save() } }
    }

    private func save() {
        if enabled, let amount = Decimal.parse(amountText), amount > 0 {
            store.budget = MonthlyBudget(amount: amount, currency: currency)
        } else if !enabled {
            store.budget = nil
        }
    }
}

/// Регулярные платежи: аренда, связь, подписки.
struct RecurringListView: View {
    @Environment(AppStore.self) private var store
    @State private var editing: RecurringPayment?

    var body: some View {
        List {
            Section {
                ForEach(store.vault.recurring) { payment in
                    Button { editing = payment } label: {
                        HStack(spacing: 12) {
                            CategoryIcon(category: store.category(for: payment.categoryID))
                            AdaptiveRow(spacing: 8) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(payment.note)
                                    Text("Каждое \(payment.day) число")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                                Text(payment.currency.format(payment.amount))
                                    .monospacedDigit()
                            }
                        }
                    }
                    .tint(Color.primary)
                }
                .onDelete { offsets in store.deleteRecurring(ids: offsets.map { store.vault.recurring[$0].id }) }
            } footer: {
                Text("В нужный день на главном экране появится карточка «Пора оплатить» — одно касание, и трата записана. iPhone напомнит в 10:00, в уведомлении нет сумм.")
            }
        }
        .warmListBackground()
        .overlay {
            if store.vault.recurring.isEmpty {
                ContentUnavailableView {
                    Label("Нет регулярных платежей", systemImage: "repeat")
                } description: {
                    Text("Добавьте аренду, связь или подписки.")
                } actions: {
                    Button("Добавить") { editing = newPayment() }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Регулярные платежи")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { editing = newPayment() } label: { Image(systemName: "plus") }
                    .accessibilityLabel("Добавить платёж")
            }
        }
        .sheet(item: $editing) { RecurringEditView(payment: $0) }
    }

    private func newPayment() -> RecurringPayment {
        let category = store.vault.categories.first { $0.name == "Жильё" } ?? store.vault.categories.first ?? .unknown
        return RecurringPayment(note: "", amount: 0, currency: store.vault.inputCurrency,
                                categoryID: category.id, day: min(28, Calendar.current.component(.day, from: .now)))
    }
}

struct RecurringEditView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var payment: RecurringPayment
    @State private var amountText: String

    init(payment: RecurringPayment) {
        _payment = State(initialValue: payment)
        _amountText = State(initialValue: payment.amount > 0 ? payment.amount.inputString : "")
    }

    private var isValid: Bool {
        !payment.note.trimmingCharacters(in: .whitespaces).isEmpty && (Decimal.parse(amountText) ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Название, например «Аренда»", text: $payment.note)
                    HStack(alignment: .firstTextBaseline) {
                        TextField("Сумма", text: $amountText)
                            .keyboardType(.decimalPad)
                            .font(.title2.weight(.semibold))
                            .monospacedDigit()
                        Picker("Валюта", selection: $payment.currency) {
                            ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
                        }
                        .labelsHidden()
                    }
                }
                Section {
                    Picker("Категория", selection: $payment.categoryID) {
                        ForEach(store.categoriesByUsage) { Label($0.name, systemImage: $0.symbol).tag($0.id) }
                    }
                    .pickerStyle(.navigationLink)
                    Picker("Число месяца", selection: $payment.day) {
                        ForEach(1...28, id: \.self) { Text("\($0)").tag($0) }
                    }
                }
            }
            .warmListBackground()
            .navigationTitle("Регулярный платёж")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        payment.amount = Decimal.parse(amountText) ?? 0
                        payment.note = payment.note.trimmingCharacters(in: .whitespaces)
                        store.upsert(payment)
                        Task { _ = await Reminders.requestPermission() }
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

/// Как вызвать ввод траты голосом или кнопкой действия.
struct SiriGuideView: View {
    var body: some View {
        Form {
            Section("Siri") {
                StepRow(number: 1, text: "Скажите: «Привет, Siri, новая трата в Financist».")
                StepRow(number: 2, text: "Откроется ввод траты.")
            }
            Section {
                StepRow(number: 1, text: "Откройте «Настройки» iPhone → «Кнопка действия».")
                StepRow(number: 2, text: "Листайте до «Быстрая команда» и нажмите «Выбрать…».")
                StepRow(number: 3, text: "Выберите Financist → «Новая трата».")
            } header: {
                Text("Кнопка действия")
            } footer: {
                Text("Есть на iPhone 15 Pro и новее. Одно нажатие сбоку — и можно вводить трату.")
            }
            Section {
                Label {
                    Text("Siri только открывает приложение. Суммы и траты Siri не передаются.")
                } icon: {
                    Image(systemName: "hand.raised.fill").foregroundStyle(.green)
                }
            }
        }
        .warmListBackground()
        .navigationTitle("Siri и кнопка действия")
        .navigationBarTitleDisplayMode(.inline)
    }
}
