import SwiftUI

struct RatesView: View {
    @Environment(AppStore.self) private var store
    @State private var editing: Currency?
    @State private var amountText = "100"
    @State private var from: Currency = .usdt
    @FocusState private var amountFocused: Bool

    var body: some View {
        let rates = store.vault.rates
        NavigationStack {
            List {
                Section {
                    ForEach(Currency.allCases.filter { $0 != .usdt }) { currency in
                        Button { editing = currency } label: {
                            HStack {
                                Text(currency.flag)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(currency.code)
                                    Text(currency.name)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if rates.manual[currency] != nil {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundStyle(.orange)
                                        .accessibilityLabel("Задан вручную")
                                }
                                Text(Fmt.rate(rates.rate(currency)) + " " + currency.symbol)
                                    .monospacedDigit()
                            }
                        }
                        .tint(Color.primary)
                    }
                } header: {
                    Text("За 1 USDT")
                } footer: {
                    ratesFooter(rates)
                }

                Section("Конвертер") {
                    HStack {
                        TextField("Сумма", text: $amountText)
                            .keyboardType(.decimalPad)
                            .monospacedDigit()
                            .focused($amountFocused)
                        Picker("Из валюты", selection: $from) {
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
            }
            .navigationTitle("Курсы")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if store.isRefreshingRates {
                        ProgressView()
                    } else {
                        Button { Task { await store.refreshRates(force: true) } } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .accessibilityLabel("Обновить курсы")
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Готово") { amountFocused = false }
                }
            }
            .refreshable { await store.refreshRates(force: true) }
            .sheet(item: $editing) { RateEditView(currency: $0) }
        }
    }

    private func ratesFooter(_ rates: RateTable) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let updated = rates.updatedAt {
                Text("Обновлено \(updated.formatted(date: .abbreviated, time: .shortened)). Источники: open.er-api.com и CoinGecko.")
            } else {
                Text("Курсы ещё не загружались — сейчас используются примерные значения.")
            }
            if let error = store.ratesError {
                Text(error).foregroundStyle(.red)
            }
            Text("Нажми на валюту, чтобы задать свой курс (например, курс твоего обменника). Каждая трата запоминает курс на момент записи.")
        }
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
                        Text("1 USDT =")
                            .foregroundStyle(.secondary)
                        TextField("Курс", text: $text)
                            .keyboardType(.decimalPad)
                            .monospacedDigit()
                            .multilineTextAlignment(.trailing)
                            .focused($focused)
                        Text(currency.symbol)
                            .foregroundStyle(.secondary)
                    }
                } footer: {
                    Text("Автоматический курс: \(Fmt.rate(rates.fetched[currency] ?? rates.rate(currency))) \(currency.symbol). Свой курс применяется к новым тратам.")
                }
                if rates.manual[currency] != nil {
                    Section {
                        Button("Вернуть автоматический курс") {
                            store.setManualRate(nil, for: currency)
                            dismiss()
                        }
                    }
                }
            }
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
        .presentationDetents([.medium])
    }
}
