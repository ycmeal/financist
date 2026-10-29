import SwiftUI

/// Все пробные подписки — по кнопке «Подписки» вверху «Трат». На самих «Тратах» подписка появляется
/// только за 5 дней до списания или когда пришло напоминание.
struct SubscriptionsView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var opened: Trial?

    var body: some View {
        let open = store.openTrials
        let upcoming = store.upcomingCharges
        NavigationStack {
            List {
                if !open.isEmpty {
                    Section {
                        ForEach(open) { trial in
                            let decide = trial.needsDecision()
                            Button { opened = trial } label: {
                                TrialRow(trial: trial, subtitle: decide ? "Пора решить · \(trial.chargeText())" : trial.chargeText(),
                                         highlighted: decide)
                            }
                            .tint(Color.primary)
                        }
                    } header: {
                        Text("Пробный период")
                    } footer: {
                        Text("На «Тратах» подписка появится сама за \(Fmt.count(Trial.shownDaysBefore, "день", "дня", "дней")) до списания.")
                    }
                }
                if !upcoming.isEmpty {
                    Section("Оставили") {
                        ForEach(upcoming) { trial in
                            Button { opened = trial } label: {
                                TrialRow(trial: trial, subtitle: "В траты запишется \(RuDate.day(trial.chargeDate))")
                            }
                            .tint(Color.primary)
                        }
                    }
                }
            }
            .warmListBackground()
            .overlay {
                if open.isEmpty && upcoming.isEmpty {
                    ContentUnavailableView {
                        Label("Подписок нет", systemImage: "arrow.triangle.2.circlepath")
                    } description: {
                        Text("Пробную подписку записывают так: «Добавить трату» → категория «Подписка».")
                    }
                }
            }
            .navigationTitle("Подписки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                }
            }
            .sheet(item: $opened) { TrialEditView(trial: $0) }
        }
    }
}

/// Строка подписки: значок, название, когда спишут, сумма.
struct TrialRow: View {
    @Environment(AppStore.self) private var store
    @Environment(\.palette) private var palette
    let trial: Trial
    let subtitle: String
    var highlighted = false

    var body: some View {
        HStack(spacing: 12) {
            CategoryIcon(category: store.category(for: trial.categoryID))
            AdaptiveRow(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(trial.title)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(highlighted ? palette.accent : Color.secondary)
                }
                Spacer(minLength: 0)
                Text(trial.currency.format(trial.amount))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(.rect)
    }
}

/// Пробная подписка: сначала вопрос «оставить или отменить», ниже — подробности, которые можно поправить.
/// Открывается из «Подписок» на главном экране и сразу по нажатию на уведомление.
struct TrialEditView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var trial: Trial
    @State private var amountText: String
    @State private var askKeep = false
    @State private var askCancel = false
    @State private var confirmDelete = false
    @State private var showCancelHelp = false

    init(trial: Trial) {
        _trial = State(initialValue: trial)
        _amountText = State(initialValue: trial.amount.inputString)
    }

    private var amount: Decimal? {
        guard let value = Decimal.parse(amountText), value > 0 else { return nil }
        return value
    }

    /// Последнее сохранённое состояние.
    private var saved: Trial? {
        store.vault.trials.first { $0.id == trial.id }
    }

    var body: some View {
        NavigationStack {
            Form {
                decisionSection

                Section {
                    TextField("Название, например «YouTube»", text: $trial.note)
                    HStack(alignment: .firstTextBaseline) {
                        TextField("Сумма", text: $amountText)
                            .keyboardType(.decimalPad)
                            .font(.title2.weight(.semibold))
                            .monospacedDigit()
                        Picker("Валюта", selection: $trial.currency) {
                            ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
                        }
                        .labelsHidden()
                    }
                } header: {
                    Text("Подробности")
                } footer: {
                    Text("Сколько спишут после пробного периода.")
                }

                Section {
                    DatePicker("Спишут", selection: $trial.chargeDate, displayedComponents: .date)
                    Picker("Напомнить", selection: $trial.remindDaysBefore) {
                        ForEach(Trial.reminderChoices, id: \.self) { days in
                            Text("за \(Fmt.count(days, "день", "дня", "дней"))").tag(days)
                        }
                    }
                } footer: {
                    Text(Trial.reminderNote(chargeDate: trial.chargeDate, remindDaysBefore: trial.remindDaysBefore))
                }

                Section {
                    Button("Удалить напоминание", role: .destructive) { confirmDelete = true }
                } footer: {
                    Text("Если записали по ошибке. Трата не запишется.")
                }
            }
            .warmListBackground()
            .navigationTitle("Подписка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        saveEdits()
                        dismiss()
                    }
                    .disabled(amount == nil)
                }
            }
            .trialDecisionDialogs(trial: trial, askKeep: $askKeep, askCancel: $askCancel) { decision in
                saveEdits()
                store.decide(decision, for: trial.id)
                dismiss()
            }
            .confirmationDialog("Удалить напоминание?", isPresented: $confirmDelete, titleVisibility: .visible) {
                Button("Удалить", role: .destructive) {
                    store.deleteTrial(id: trial.id)
                    dismiss()
                }
            }
            .sheet(isPresented: $showCancelHelp) { CancelSubscriptionHelpView() }
        }
    }

    /// Главное — наверху: решение и как отменить.
    @ViewBuilder
    private var decisionSection: some View {
        switch saved?.decision {
        case nil:
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trial.chargeText())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(trial.title) · \(trial.currency.format(trial.amount))")
                        .font(.title3.weight(.semibold))
                }
                .padding(.vertical, 4)
                Button("Я решил оплатить") { askKeep = true }
                Button("Я отменил") { askCancel = true }
                cancelHelpButton
            } footer: {
                Text("Пока не решите, «Подписки» на главном экране будут напоминать.")
            }
        case .keep? where saved?.chargeRecorded == false:
            Section {
                Button("Всё-таки отменил") { askCancel = true }
                cancelHelpButton
            } footer: {
                Text("Подписку оставили: \(RuDate.day(trial.chargeDate)) трата запишется сама.")
            }
        default:
            EmptyView()
        }
    }

    private var cancelHelpButton: some View {
        Button { showCancelHelp = true } label: {
            Label("Как отменить подписку", systemImage: "questionmark.circle")
        }
    }

    private func saveEdits() {
        guard var updated = saved else { return }
        updated.note = trial.note.trimmingCharacters(in: .whitespacesAndNewlines)
        if let amount { updated.amount = amount }
        updated.currency = trial.currency
        updated.chargeDate = Calendar.current.startOfDay(for: trial.chargeDate)
        updated.remindDaysBefore = trial.remindDaysBefore
        if updated != saved { store.upsert(updated) }
    }
}

private extension View {
    /// Подтверждения «Я решил оплатить» и «Я отменил»: что будет дальше, одним предложением.
    func trialDecisionDialogs(trial: Trial, askKeep: Binding<Bool>, askCancel: Binding<Bool>,
                              decide: @escaping (Trial.Decision) -> Void) -> some View {
        let amount = trial.currency.format(trial.amount)
        let keepMessage = trial.daysUntilCharge() > 0
            ? "\(RuDate.day(trial.chargeDate)) спишут \(amount) — в этот день трата запишется сама."
            : "Трата \(amount) запишется за \(RuDate.day(trial.chargeDate))."
        return self
            .confirmationDialog("Оставить подписку?", isPresented: askKeep, titleVisibility: .visible) {
                Button("Да, оставляю") { decide(.keep) }
                Button("Нет", role: .cancel) {}
            } message: {
                Text(keepMessage)
            }
            .confirmationDialog("Подписку отменили?", isPresented: askCancel, titleVisibility: .visible) {
                Button("Да, отменил") { decide(.cancel) }
                Button("Нет", role: .cancel) {}
            } message: {
                Text("Напоминание уберу, трата не запишется. Если ещё не отменили — загляните в «Как отменить подписку».")
            }
    }
}

/// Как отменить подписку, оформленную через App Store. Шаги — как в статье Apple.
struct CancelSubscriptionHelpView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                Section {
                    StepRow(number: 1, text: "Откройте «Настройки» на iPhone.")
                    StepRow(number: 2, text: "Нажмите на своё имя в самом верху.")
                    StepRow(number: 3, text: "Нажмите «Подписки».")
                    StepRow(number: 4, text: "Выберите нужную подписку.")
                    StepRow(number: 5, text: "Нажмите «Отменить подписку» и подтвердите. Кнопка внизу — возможно, придётся прокрутить.")
                } header: {
                    Text("Подписка через App Store")
                } footer: {
                    Text("Отменяйте хотя бы за сутки до конца пробного периода, иначе деньги могут успеть списать.")
                }

                Section {
                    Button {
                        if let url = URL(string: "https://apps.apple.com/account/subscriptions") { openURL(url) }
                    } label: {
                        Label("Открыть мои подписки", systemImage: "arrow.up.forward.app")
                    }
                } footer: {
                    Text("Откроется список подписок в App Store — сразу шаг 4.")
                }

                Section("Если что-то не так") {
                    Text("**Нет кнопки «Отменить подписку»?** Значит, подписка уже отменена: под ней красным написано, когда она закончится.")
                    Text("**Подписки нет в списке?** Значит, её оформили не через Apple — на сайте, в приложении банка или у оператора связи. Отменять нужно там же, обычно в настройках аккаунта.")
                }
            }
            .warmListBackground()
            .navigationTitle("Отмена подписки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                }
            }
        }
    }
}

/// Колокольчик на плитке «Подписки»: с ней приходят напоминания о списании.
struct SubscriptionBadge: View {
    @Environment(\.palette) private var palette

    var body: some View {
        Image(systemName: "bell.fill")
            .font(.caption2.weight(.bold))
            .foregroundStyle(.white)
            .padding(4)
            .background(palette.accent, in: .circle)
            .offset(x: 6, y: -6)
            .accessibilityHidden(true)
    }
}
