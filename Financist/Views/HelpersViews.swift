import SwiftUI

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
