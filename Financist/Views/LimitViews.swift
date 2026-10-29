import SwiftUI

/// Полоска лимита: сколько потрачено за месяц из лимита, сколько осталось и сколько можно в день.
/// Ближе к концу лимита — оранжевая, сверх лимита — красная.
struct LimitBar: View {
    @Environment(\.palette) private var palette
    let progress: LimitProgress
    var title = "Лимит на \(RuDate.monthNominative(.now))"
    @ScaledMetric(relativeTo: .body) private var barHeight: CGFloat = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .firstTextBaseline) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                    Spacer(minLength: 8)
                    spent
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                    spent
                }
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.primary.opacity(0.1))
                    Capsule().fill(color)
                        .frame(width: max(barHeight, geo.size.width * min(progress.share, 1)))
                }
            }
            .frame(height: barHeight)
            Text(progress.statusText)
                .font(.footnote)
                .foregroundStyle(progress.isOver ? Color.red : Color.secondary)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))
        .animation(.snappy, value: progress)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue("Потрачено \(progress.spentText). \(progress.statusText)")
    }

    private var spent: some View {
        Text(progress.spentText)
            .font(.subheadline)
            .monospacedDigit()
            .foregroundStyle(.secondary)
    }

    private var color: Color {
        progress.isOver ? .red : progress.isNear ? .orange : palette.accent
    }
}

/// «Лимит на месяц» в настройках: сколько можно потратить за месяц и в какой валюте.
struct LimitView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var amountText = ""
    @State private var currency: Currency = .usd
    @State private var isSetUp = false
    @FocusState private var focused: Bool

    private var amount: Decimal? {
        guard let value = Decimal.parse(amountText), value > 0 else { return nil }
        return value
    }

    /// Как будет выглядеть полоска с этим лимитом — сразу, пока набираете.
    private var preview: LimitProgress? {
        amount.map { LimitProgress(limit: MonthlyLimit(amount: $0, currency: currency),
                                   spent: store.spentThisMonth(in: currency)) }
    }

    var body: some View {
        Form {
            Section {
                HStack(spacing: 10) {
                    TextField("Например, 30 000", text: $amountText)
                        .keyboardType(.decimalPad)
                        .font(.title2.weight(.semibold))
                        .monospacedDigit()
                        .focused($focused)
                        .accessibilityLabel("Лимит на месяц")
                    Picker("Валюта", selection: $currency) {
                        ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
                    }
                    .labelsHidden()
                }
            } header: {
                Text("Сколько можно потратить за месяц")
            } footer: {
                Text("Траты в других валютах пересчитываются по курсу своего дня. Каждый месяц лимит начинается заново.")
            }

            if let preview {
                Section("Сейчас") {
                    LimitBar(progress: preview)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }

            if store.monthlyLimit != nil {
                Section {
                    Button("Убрать лимит", role: .destructive) {
                        store.monthlyLimit = nil
                        dismiss()
                    }
                } footer: {
                    Text("Полоска на «Тратах» пропадёт. Траты не изменятся.")
                }
            }
        }
        .warmListBackground()
        .navigationTitle("Лимит на месяц")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Сохранить") {
                    if let amount { store.monthlyLimit = MonthlyLimit(amount: amount, currency: currency) }
                    dismiss()
                }
                .disabled(amount == nil)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Скрыть") { focused = false }
            }
        }
        .onAppear {
            guard !isSetUp else { return }
            isSetUp = true
            if let limit = store.monthlyLimit {
                amountText = limit.amount.inputString
                currency = limit.currency
            } else {
                currency = store.displayCurrency
                focused = true
            }
        }
    }
}
