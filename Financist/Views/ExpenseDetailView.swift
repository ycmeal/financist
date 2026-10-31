import SwiftUI

/// Карточка траты — открывается нажатием на трату. Всё о ней на одном экране: место, сумма в двух валютах,
/// когда, чем платили, по какому курсу, сколько это в других валютах и как часто здесь бываете.
/// Кнопки: «Изменить» (форма правки), «Повторить» (ввод с теми же местом и категорией), «Удалить».
struct ExpenseDetailView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.palette) private var palette
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric(relativeTo: .largeTitle) private var iconSize: CGFloat = 76

    let expenseID: UUID
    /// Последняя известная версия — на случай, если трату только что удалили и экран закрывается.
    @State private var last: Expense
    @State private var editing: Expense?
    @State private var repeating: Expense?

    init(expense: Expense) {
        expenseID = expense.id
        _last = State(initialValue: expense)
    }

    /// Всегда свежая трата из хранилища: после правки карточка сразу показывает новое.
    private var expense: Expense {
        store.vault.expenses.first { $0.id == expenseID } ?? last
    }

    var body: some View {
        let expense = expense
        let category = store.category(for: expense.categoryID)
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    hero(expense, category)
                    actions(expense)
                    details(expense, category)
                    otherCurrencies(expense)
                    placeHistory(expense)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(palette.background.ignoresSafeArea())
            .navigationTitle(whenTitle(expense))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
        // Правку и повтор открываем отсюда же; после повтора карточка закрывается — новая трата уже в списке.
        .sheet(item: $editing) { ExpenseFormView(expense: $0) }
        .fullScreenCover(item: $repeating, onDismiss: { dismiss() }) { AddExpenseView(template: $0) }
        .onChange(of: store.vault.expenses.contains { $0.id == expenseID }) { _, exists in
            // Удалили (здесь или в форме правки) — закрываем карточку.
            if !exists { dismiss() }
        }
        .onChange(of: expense) { _, now in last = now }
    }

    /// «Сегодня», «Ср, 28 октября» — в заголовке; время и полная дата — в «Подробностях».
    private func whenTitle(_ expense: Expense) -> String {
        RuDate.dayTitle(expense.date)
    }

    // MARK: Шапка

    private func hero(_ expense: Expense, _ category: ExpenseCategory) -> some View {
        let second = [Currency.usd, store.displayCurrency, store.vault.inputCurrency].first { $0 != expense.currency }
        return VStack(spacing: 6) {
            Image(systemName: category.symbol)
                .font(.system(size: iconSize * 0.42, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: iconSize, height: iconSize)
                .background(category.color.gradient, in: .circle)
                .padding(.bottom, 8)
                .accessibilityHidden(true)
            Text(expense.note.isEmpty ? category.name : expense.note)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
            if !expense.note.isEmpty {
                Text(category.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(expense.currency.format(expense.amount))
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.top, 10)
            if let second {
                Text("≈ " + second.format(expense.amount(in: second).rounded(scale: second.fractionDigits)))
                    .font(.title3)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
        .accessibilityElement(children: .combine)
    }

    // MARK: Кнопки

    private func actions(_ expense: Expense) -> some View {
        HStack(spacing: 10) {
            ActionTile(title: "Изменить", symbol: "pencil", tint: palette.accent) { editing = expense }
            ActionTile(title: "Повторить", symbol: "arrow.clockwise", tint: palette.accent) { repeating = expense }
            // Удаление можно отменить: внизу появится «Вернуть», а ещё трата 30 дней лежит в «Недавно удалённых».
            ActionTile(title: "Удалить", symbol: "trash", tint: .red) {
                store.deleteExpenses(ids: [expense.id])
            }
        }
        // При очень крупном шрифте три плитки в ряд не помещаются — тогда друг под другом.
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
    }

    // MARK: Подробности

    private func details(_ expense: Expense, _ category: ExpenseCategory) -> some View {
        Card(title: "Подробности") {
            DetailRow(symbol: "calendar", title: "Когда", value: dayAndTime(expense.date))
            if let payment = expense.payment {
                Divider()
                DetailRow(symbol: payment.symbol, title: "Оплата", value: payment.title)
            }
            Divider()
            DetailRow(symbol: category.symbol, title: "Категория", value: category.name)
            if let rate = rateLine(expense) {
                Divider()
                DetailRow(symbol: "arrow.left.arrow.right", title: "Курс", value: rate,
                          footnote: expense.ratesPending ? "Примерный — уточнится сам, когда загрузятся курсы этого дня." : nil)
            }
            if expense.recurringID != nil {
                Divider()
                DetailRow(symbol: "repeat", title: "Записано", value: "Из регулярного платежа")
            }
        }
    }

    /// «Среда, 28 октября 2025, 20:04» — год, только если не текущий.
    private func dayAndTime(_ date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.isDate(date, equalTo: .now, toGranularity: .year) ? "" : " \(calendar.component(.year, from: date))"
        return "\(RuDate.weekdayAndDay(date))\(year), \(RuDate.time(date))"
    }

    /// «1 $ = 49,80 ₺»: курс валюты траты к доллару, а у трат в долларах — курс валюты итогов.
    private func rateLine(_ expense: Expense) -> String? {
        let other = expense.currency == .usd
            ? [store.displayCurrency, store.vault.inputCurrency].first { $0 != .usd }
            : expense.currency
        guard let other else { return nil }
        return "1 $ = " + other.format(expense.rate(other).rounded(scale: 2))
    }

    // MARK: В других валютах

    private func otherCurrencies(_ expense: Expense) -> some View {
        // Сначала валюта итогов и валюта ввода, потом остальные.
        let first = [store.displayCurrency, store.vault.inputCurrency]
        let list = (first + Currency.allCases).reduce(into: [Currency]()) { list, currency in
            if currency != expense.currency, !list.contains(currency) { list.append(currency) }
        }
        return Card(title: "В других валютах", footer: "По курсу дня траты.") {
            ForEach(Array(list.enumerated()), id: \.element) { index, currency in
                if index > 0 { Divider() }
                HStack(spacing: 10) {
                    Text(currency.flag)
                        .accessibilityHidden(true)
                    Text(currency.name)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer(minLength: 8)
                    Text(currency.format(expense.amount(in: currency).rounded(scale: currency.fractionDigits)))
                        .monospacedDigit()
                }
                .padding(.vertical, 10)
                .accessibilityElement(children: .combine)
            }
        }
    }

    // MARK: Здесь раньше

    @ViewBuilder
    private func placeHistory(_ expense: Expense) -> some View {
        if !expense.note.isEmpty {
            let key = SuggestionEngine.key(expense.note)
            let here = store.vault.expenses.filter { SuggestionEngine.key($0.note) == key }
            let calendar = Calendar.current
            let month = here.filter { calendar.isDate($0.date, equalTo: expense.date, toGranularity: .month) }
            if here.count > 1 {
                Card(title: "\(expense.note) — раньше") {
                    DetailRow(symbol: "calendar.badge.clock", title: "В \(RuDate.monthPrepositional(expense.date))",
                              value: "\(Fmt.count(month.count, "трата", "траты", "трат")) · \(expense.currency.format(month.total(in: expense.currency).rounded(scale: 0)))")
                    Divider()
                    DetailRow(symbol: "clock.arrow.circlepath", title: "Всего здесь",
                              value: "\(Fmt.count(here.count, "трата", "траты", "трат")) · \(expense.currency.format(here.total(in: expense.currency).rounded(scale: 0)))")
                }
            }
        }
    }
}

/// Плитка-кнопка под суммой: значок и подпись, как быстрые действия в банковских приложениях.
private struct ActionTile: View {
    let title: String
    let symbol: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: symbol)
                    .font(.title3.weight(.semibold))
                Text(title)
                    .font(.footnote.weight(.medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundStyle(tint)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))
            .contentShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

/// Белая (в тёмной теме — серая) карточка с заголовком, как группы в «Настройках».
private struct Card<Content: View>: View {
    let title: String
    var footer: String?
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, 4)
            VStack(spacing: 0) { content }
                .padding(.horizontal, 14)
                .padding(.vertical, 4)
                .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))
            if let footer {
                Text(footer)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Строка подробностей: значок, подпись сверху мелко, значение крупно — читается и при большом шрифте.
private struct DetailRow: View {
    let symbol: String
    let title: String
    let value: String
    var footnote: String?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 24)
                .padding(.top, 2)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text(value)
                if let footnote {
                    Text(footnote)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}
