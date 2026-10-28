import SwiftUI

struct RatesView: View {
    @Environment(AppStore.self) private var store
    @State private var editing: Currency?
    @State private var amountText = "100"
    @State private var from: Currency = .usd
    @FocusState private var amountFocused: Bool

    var body: some View {
        @Bindable var store = store
        let rates = store.vault.rates
        Form {
            Section("Пересчёт") {
                HStack(alignment: .firstTextBaseline) {
                    TextField("Сумма", text: $amountText)
                        .keyboardType(.decimalPad)
                        .font(.title.weight(.semibold))
                        .monospacedDigit()
                        .focused($amountFocused)
                    Picker("Валюта", selection: $from) {
                        ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
                    }
                    .labelsHidden()
                }
                if let amount = Decimal.parse(amountText) {
                    ForEach(Currency.allCases.filter { $0 != from }) { target in
                        LabeledContent("\(target.flag) \(target.code)") {
                            Text(target.format(rates.convert(amount, from: from, to: target).rounded(scale: target.fractionDigits)))
                                .monospacedDigit()
                                .textSelection(.enabled)
                        }
                    }
                }
            }

            Section {
                ForEach(Currency.allCases.filter { $0 != .base }) { currency in
                    Button { editing = currency } label: {
                        LabeledContent {
                            HStack(spacing: 6) {
                                if rates.manual[currency] != nil {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundStyle(.tint)
                                        .accessibilityLabel("Свой курс")
                                }
                                Text("\(Fmt.rate(rates.rate(currency))) \(currency.symbol)")
                                    .monospacedDigit()
                            }
                        } label: {
                            Text("\(currency.flag) \(currency.code)")
                        }
                    }
                    .tint(Color.primary)
                }
            } header: {
                Text("За 1 USD")
            } footer: {
                Text("Нажмите на валюту, чтобы указать свой курс — например, из обменника.")
            }

            Section {
                Button {
                    Task { await store.refreshRates(force: true) }
                } label: {
                    HStack {
                        Text("Обновить сейчас")
                        Spacer()
                        if store.isRefreshingRates { ProgressView() }
                    }
                }
                .disabled(store.isRefreshingRates)
            } footer: {
                VStack(alignment: .leading, spacing: 6) {
                    if let updated = rates.updatedAt {
                        Text("Обновлено: \(RuDate.dayTitle(updated)), \(RuDate.time(updated)).")
                    }
                    if let error = store.ratesError {
                        Text(error)
                    }
                    Text("Курсы обновляются сами каждый день. Каждая трата получает курс своего дня — и записанная задним числом тоже. Если курсы дня ещё не загрузились, трата пересчитается сама. Приложение только скачивает общие курсы, траты никуда не отправляются.")
                }
            }
        }
        .warmListBackground()
        .navigationTitle("Курсы валют")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Скрыть") { amountFocused = false }
            }
        }
        .sheet(item: $editing) { RateEditView(currency: $0) }
    }
}

struct RateEditView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    let currency: Currency
    @State private var text = ""
    @FocusState private var focused: Bool

    var body: some View {
        let rates = store.vault.rates
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("1 USD =")
                            .foregroundStyle(.secondary)
                        TextField("Курс", text: $text)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                            .monospacedDigit()
                            .multilineTextAlignment(.trailing)
                            .focused($focused)
                        Text(currency.symbol)
                            .foregroundStyle(.secondary)
                    }
                } footer: {
                    Text("Свой курс получат новые траты за сегодня, пока вы его не уберёте. Траты за прошедшие дни получают общий курс своего дня.")
                }
                if rates.manual[currency] != nil {
                    Section {
                        Button("Вернуть общий курс") {
                            store.setManualRate(nil, for: currency)
                            dismiss()
                        }
                    } footer: {
                        Text("Общий курс: \(Fmt.rate(rates.fetched[currency] ?? 0)) \(currency.symbol)")
                    }
                }
            }
            .warmListBackground()
            .navigationTitle("\(currency.flag) \(currency.code)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        store.setManualRate(Decimal.parse(text), for: currency)
                        dismiss()
                    }
                    .disabled((Decimal.parse(text) ?? 0) <= 0)
                }
            }
            .onAppear {
                text = rates.rate(currency).inputString
                focused = true
            }
        }
        .presentationDetents([.medium, .large])
    }
}
