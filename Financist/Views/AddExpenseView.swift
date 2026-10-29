import SwiftUI

/// Новая трата на весь экран, по шагам:
/// 1. Сколько — крупная сумма на своей клавиатуре, сзади подсветка цветов валюты.
///    Тут же «Вчера» или другой день и недавние траты: одно касание — и всё заполнено.
/// 2. На что — знакомое место само выбирает категорию: «Migros» → «Продукты».
/// 3. Только для «Подписки»: пробный период (iPhone напомнит до списания) или уже оплачено.
struct AddExpenseView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.palette) private var palette
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private enum Step: Int { case amount, details, subscription }

    private let template: Expense?
    private let presetDate: Date?

    @State private var step: Step
    @State private var input: AmountInput
    /// Сумма подставлена (повтор, недавняя трата, чек) и выделена: первая же цифра набирает новую.
    @State private var amountPrefilled: Bool
    @State private var currency: Currency
    @State private var date: Date
    @State private var note: String
    @State private var categoryID: UUID?
    @State private var categoryTouched: Bool
    /// Категорию подобрало знакомое место, а не человек.
    @State private var autoPicked = false
    /// Пробная подписка: спишут позже, iPhone напомнит заранее.
    @State private var isTrial: Bool
    /// Картой или наличными: как платили в прошлый раз, а в знакомом месте — как платили там.
    @State private var payment: PaymentMethod
    @State private var paymentTouched = false
    @State private var chargeDate = Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.startOfDay(for: .now)) ?? .now
    @State private var remindDays = Trial.defaultReminder
    @State private var suggestions: [Suggestion] = []
    @State private var templates: [Expense] = []
    @State private var orderedCategories: [ExpenseCategory] = []
    @State private var showAllCategories = false
    @State private var isSetUp = false
    @State private var pickingDay = false
    @State private var isScanning = false
    @State private var scanStatus: String?
    @State private var newCategory: ExpenseCategory?
    @State private var showCancelHelp = false
    @FocusState private var noteFocused: Bool
    @ScaledMetric(relativeTo: .largeTitle) private var amountSize: CGFloat = 64

    /// `template` — повтор прошлой траты: всё заполнено, дата — сейчас. `presetDate` — день из календаря.
    init(template: Expense? = nil, presetDate: Date? = nil) {
        self.template = template
        self.presetDate = presetDate
        // Повтор открывается сразу на «На что?» с кнопкой «Сохранить»; сумму можно поменять, нажав на неё.
        _step = State(initialValue: template == nil ? .amount : .details)
        _input = State(initialValue: template.map { AmountInput(amount: $0.amount, fractionDigits: $0.currency.fractionDigits) }
            ?? AmountInput())
        _amountPrefilled = State(initialValue: template != nil)
        _currency = State(initialValue: template?.currency ?? .lira)
        _date = State(initialValue: presetDate.map(Self.keepingTime) ?? .now)
        _note = State(initialValue: template?.note ?? "")
        _categoryID = State(initialValue: template?.categoryID)
        _categoryTouched = State(initialValue: template != nil)
        // Повтор и запись на день из календаря — это уже оплаченное, не пробный период.
        _isTrial = State(initialValue: template == nil && presetDate == nil)
        _payment = State(initialValue: template?.payment ?? .card)
    }

    private var subscriptionSelected: Bool {
        guard let categoryID else { return false }
        return store.category(for: categoryID).isSubscription
    }

    private var trimmedNote: String { note.trimmingCharacters(in: .whitespacesAndNewlines) }

    /// Как запишется: знакомое место — привычным написанием («мигрос» → «Migros»).
    private var savedNote: String { SuggestionEngine.canonical(note, in: suggestions) }

    var body: some View {
        // Шаги стоят в ряд и листаются целиком, а подсветка остаётся на месте.
        GeometryReader { geo in
            HStack(alignment: .top, spacing: 0) {
                page(.amount, geo.size) { amountPage }
                page(.details, geo.size) { detailsPage }
                if subscriptionSelected {
                    page(.subscription, geo.size) { subscriptionPage }
                }
            }
            .offset(x: -CGFloat(step.rawValue) * geo.size.width)
            .animation(reduceMotion ? nil : .snappy(duration: 0.35), value: step)
        }
        // Шрифт растёт вместе с настройками iPhone, но до разумного предела: кнопки и плитки должны помещаться.
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
        .background { CurrencyGlow(currency: currency) }
        .onAppear(perform: setUp)
        .onChange(of: step) { _, now in
            // Для VoiceOver новый шаг — новый экран.
            UIAccessibility.post(notification: .screenChanged, argument: nil)
            guard now == .details, note.isEmpty else { return }
            // Клавиатура — когда шаг уже на месте, чтобы переход не дёргался.
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(350))
                if step == .details { noteFocused = true }
            }
        }
        .onChange(of: note) { _, newValue in
            let known = SuggestionEngine.exact(newValue, in: suggestions)
            // В знакомом месте платим так же, как в прошлый раз, — если способ оплаты не меняли сами.
            if !paymentTouched, let paid = known?.payment { payment = paid }
            // Знакомое место (как его ни напиши) — сразу его категория, если её не выбирали вручную.
            // Незнакомое — по словам в названии: «Kasap Ali» — «Продукты», «Nur Eczanesi» — «Здоровье».
            guard !categoryTouched else { return }
            if let known {
                pickAutomatically(known.categoryID)
            } else if let guessed = SuggestionEngine.guessCategory(newValue, in: orderedCategories) {
                pickAutomatically(guessed.id)
            } else if autoPicked && newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                categoryID = nil
                autoPicked = false
            }
        }
        .sheet(isPresented: $pickingDay) {
            DaySheet(day: date) { date = Self.keepingTime($0) }
        }
        .sheet(item: $newCategory) { category in
            CategoryEditView(category: category) { saved in
                orderedCategories.insert(saved, at: 0)
                pick(saved)
            }
        }
        .sheet(isPresented: $showCancelHelp) { CancelSubscriptionHelpView() }
        .fullScreenCover(isPresented: $isScanning) {
            CameraPicker { image in
                isScanning = false
                if let image { Task { await readReceipt(image) } }
            }
            .ignoresSafeArea()
        }
        .sensoryFeedback(.selection, trigger: categoryID)
        .sensoryFeedback(.selection, trigger: currency)
    }

    private func page(_ which: Step, _ size: CGSize, @ViewBuilder content: () -> some View) -> some View {
        content()
            .frame(width: size.width, height: size.height)
            .accessibilityHidden(step != which)
            .allowsHitTesting(step == which)
    }

    // MARK: 1. Сколько

    private var amountPage: some View {
        VStack(spacing: 0) {
            HStack {
                RoundButton(systemImage: "xmark", label: "Закрыть") { dismiss() }
                Spacer(minLength: 8)
                currencyMenu
                Spacer(minLength: 8)
                RoundButton(systemImage: "doc.text.viewfinder", label: "Сканировать чек") { isScanning = true }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            Spacer(minLength: 12)
            amountDisplay
            amountCaption
                .padding(.top, 4)
            if let scanStatus {
                Label(scanStatus, systemImage: "doc.text.viewfinder")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
            }
            dayChips
                .padding(.top, 16)
            Spacer(minLength: 12)

            if !templates.isEmpty {
                recentStrip
                    .padding(.bottom, 12)
            }
            Keypad(commaEnabled: currency.fractionDigits > 0) { press($0) }
                .padding(.horizontal)
            mainButton("Далее", enabled: input.value != nil) { go(.details) }
                .padding(.top, 12)
        }
        // Клавиатура и сумма и так крупные; больше — уже не помещается на экран.
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .sensoryFeedback(.selection, trigger: input)
    }

    /// «1 250,5 ₺» — крупно; знак валюты помельче.
    private var amountDisplay: some View {
        // Не крупнее, чем при самом большом обычном шрифте: дальше сумма не поместится над клавиатурой.
        let size = min(amountSize, 76)
        return (Text(input.display)
            .foregroundStyle(input.isEmpty ? Color.secondary : Color.primary)
         + Text("\u{00A0}" + currency.symbol)
            .font(.system(size: size * 0.5, weight: .semibold, design: .rounded))
            .foregroundStyle(Color.secondary))
            .font(.system(size: size, weight: .bold, design: .rounded))
            .monospacedDigit()
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .contentTransition(.numericText())
            .animation(.snappy(duration: 0.2), value: input)
            .padding(.horizontal, 12)
            .padding(.vertical, 2)
            .background(amountPrefilled ? palette.accent.opacity(0.2) : Color.clear, in: .rect(cornerRadius: 14))
            .padding(.horizontal)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Сумма")
            .accessibilityValue(input.value.map { currency.format($0) } ?? "не введена")
    }

    /// Под суммой: пересчёт в валюту итогов или подсказка, что вводить.
    private var amountCaption: some View {
        let display = store.displayCurrency
        return Group {
            if let value = input.value, display != currency {
                Text("≈ " + display.format(converted(value, to: display).rounded(scale: 2)))
                    .monospacedDigit()
            } else if input.isEmpty {
                Text("Сколько потратили?")
            } else {
                Text(" ").accessibilityHidden(true)
            }
        }
        .font(.title3)
        .foregroundStyle(.secondary)
    }

    /// Валюта над суммой: по нажатию — список, недавние сверху.
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
        Button {
            currency = cur
            // У сума копеек нет — лишние знаки после запятой уходят.
            input.fit(fractionDigits: cur.fractionDigits)
        } label: {
            if cur == currency {
                Label("\(cur.flag) \(cur.code) — \(cur.name)", systemImage: "checkmark")
            } else {
                Text("\(cur.flag) \(cur.code) — \(cur.name)")
            }
        }
    }

    /// Последние валюты + текущая, без повторов.
    private var currencyChoices: [Currency] {
        var list = store.quickCurrencies
        if !list.contains(currency) { list.insert(currency, at: 0) }
        return list
    }

    /// «Сегодня» стоит сразу; «Вчера» — одно касание; календарь — для дня раньше.
    private var dayChips: some View {
        let calendar = Calendar.current
        let today = calendar.isDateInToday(date)
        let yesterday = calendar.isDateInYesterday(date)
        let other = !today && !yesterday
        let row = HStack(spacing: 8) {
            Chip(title: "Сегодня", selected: today) { setDay(daysAgo: 0) }
            Chip(title: "Вчера", selected: yesterday) { setDay(daysAgo: 1) }
            Chip(title: other ? date.formatted(.dateTime.day().month(.abbreviated).locale(Locale(identifier: "ru_RU"))) : nil,
                 systemImage: "calendar", selected: other) { pickingDay = true }
                .accessibilityLabel(other ? "День: \(RuDate.day(date))" : "Другой день")
        }
        return ViewThatFits(in: .horizontal) {
            row
            ScrollView(.horizontal, showsIndicators: false) { row.padding(.horizontal) }
        }
    }

    /// Недавние разные траты: нажали — подставились место и категория (и сумма, если её ещё нет).
    private var recentStrip: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Недавние")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(templates.prefix(5))) { recentChip($0) }
                }
                .padding(.horizontal)
            }
        }
    }

    private func recentChip(_ expense: Expense) -> some View {
        let category = store.category(for: expense.categoryID)
        return Button { useRecent(expense) } label: {
            HStack(spacing: 6) {
                Image(systemName: category.symbol)
                    .foregroundStyle(category.color)
                Text(expense.note)
                if input.isEmpty {
                    Text(expense.currency.format(expense.amount))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
            .font(.subheadline)
            .lineLimit(1)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.ultraThinMaterial, in: .capsule)
        }
        .buttonStyle(.plain)
        .accessibilityHint(input.isEmpty ? "Заполнить, как в прошлый раз" : "Подставить место и категорию")
    }

    // MARK: 2. На что

    private var detailsPage: some View {
        VStack(spacing: 0) {
            stepBar(back: .amount, showDay: true)
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("На что?")
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)
                    noteField
                    // «Запишу как «Migros»» — только если правда по-другому, а не одной заглавной буквой.
                    if !trimmedNote.isEmpty && SuggestionEngine.normalize(savedNote) != SuggestionEngine.normalize(trimmedNote) {
                        Text("Запишу как «\(savedNote)»")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                    }
                    if let categoryID, autoPicked {
                        pickedHint(store.category(for: categoryID))
                    }
                    if noteFocused {
                        suggestionList
                    }
                    categoryCard
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .scrollDismissesKeyboard(.interactively)
            .scrollBounceBehavior(.basedOnSize)
            paymentPicker
                .padding(.horizontal)
                .padding(.top, 8)
            mainButton(categoryID == nil ? "Выберите категорию" : subscriptionSelected ? "Далее" : "Сохранить",
                       enabled: categoryID != nil) {
                if subscriptionSelected { go(.subscription) } else { save() }
            }
            .padding(.top, 8)
        }
    }

    /// Картой или наличными — одним касанием над кнопкой «Сохранить». Обычно уже стоит как надо.
    private var paymentPicker: some View {
        Picker("Чем платили", selection: Binding(get: { payment }, set: { payment = $0; paymentTouched = true })) {
            ForEach(PaymentMethod.allCases) { Text($0.title).tag($0) }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel("Чем платили")
    }

    private var noteField: some View {
        HStack(spacing: 8) {
            TextField("Migros, аптека, такси…", text: $note)
                .font(.title2)
                .focused($noteFocused)
                .submitLabel(.done)
                .onSubmit { noteFocused = false }
                .autocorrectionDisabled()
            if !note.isEmpty {
                Button {
                    note = ""
                    noteFocused = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Очистить")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
    }

    private func pickedHint(_ category: ExpenseCategory) -> some View {
        HStack(spacing: 12) {
            CategoryIcon(category: category)
            VStack(alignment: .leading, spacing: 1) {
                Text(category.name)
                    .font(.headline)
                Text("Категория подобрана сама — можно сменить ниже")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 4)
        .accessibilityElement(children: .combine)
    }

    /// Пока пусто — частые места; по мере ввода — похожие. Нажали — подставилась и категория.
    @ViewBuilder
    private var suggestionList: some View {
        let items = SuggestionEngine.match(note, in: suggestions, near: currency)
        if !items.isEmpty {
            VStack(spacing: 0) {
                ForEach(items) { suggestion in
                    let category = store.category(for: suggestion.categoryID)
                    Button { apply(suggestion) } label: {
                        HStack(spacing: 12) {
                            CategoryIcon(category: category)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(suggestion.note)
                                Text(category.name)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "arrow.up.left")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    if suggestion.id != items.last?.id {
                        Divider().padding(.leading, 58)
                    }
                }
            }
            .background(.regularMaterial, in: .rect(cornerRadius: 16))
        }
    }

    private var categoryCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Категория")
                .font(.headline)
                .padding(.horizontal, 4)
            CategoryGrid(categories: visibleCategories, selection: categoryID) { pick($0) } onAdd: {
                newCategory = ExpenseCategory(name: "", symbol: "star.fill", colorName: "orange")
            }
            if orderedCategories.count > 8 {
                Button(showAllCategories ? "Свернуть" : "Все категории (\(orderedCategories.count))") {
                    withAnimation(.snappy) { showAllCategories.toggle() }
                }
                .font(.subheadline)
                .padding(.horizontal, 4)
            }
        }
        .padding(12)
        .background(.regularMaterial, in: .rect(cornerRadius: 20))
    }

    /// Частые категории; выбранная и «Подписка» видны всегда.
    private var visibleCategories: [ExpenseCategory] {
        let all = orderedCategories
        var visible = showAllCategories ? all : Array(all.prefix(8))
        if let categoryID, !visible.contains(where: { $0.id == categoryID }),
           let selected = all.first(where: { $0.id == categoryID }) {
            visible.insert(selected, at: 0)
        }
        if !visible.contains(where: \.isSubscription), let subscription = all.first(where: \.isSubscription) {
            visible.append(subscription)
        }
        return visible
    }

    // MARK: 3. Подписка

    private var subscriptionPage: some View {
        VStack(spacing: 0) {
            stepBar(back: .details, showDay: false)
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trimmedNote.isEmpty ? "Подписка" : savedNote)
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                        Text("Уже платите или пока пробный период?")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    choice(trial: true, symbol: "hourglass", title: "Пробный период",
                           detail: "Пока бесплатно — напомню до списания")
                    choice(trial: false, symbol: "checkmark.circle", title: "Уже оплачено",
                           detail: "Записать трату сейчас")
                    if isTrial {
                        trialCard
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .scrollBounceBehavior(.basedOnSize)
            mainButton(isTrial ? "Напомнить о списании" : "Записать трату") { save() }
                .padding(.top, 8)
        }
    }

    private func choice(trial: Bool, symbol: String, title: String, detail: String) -> some View {
        let selected = isTrial == trial
        return Button {
            withAnimation(.snappy) { isTrial = trial }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: symbol)
                    .font(.title2)
                    .foregroundStyle(selected ? palette.accent : Color.secondary)
                    .frame(width: 32)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(selected ? palette.accent : Color.secondary)
            }
            .padding(16)
            .background(.regularMaterial, in: .rect(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(selected ? palette.accent : Color.clear, lineWidth: 2)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private var trialCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            DatePicker("Спишут", selection: $chargeDate, in: Calendar.current.startOfDay(for: .now)...,
                       displayedComponents: .date)
                .padding(.vertical, 10)
            Divider()
            HStack {
                Text("Напомнить")
                Spacer()
                Picker("Напомнить", selection: $remindDays) {
                    ForEach(Trial.reminderChoices, id: \.self) { days in
                        Text("за \(Fmt.count(days, "день", "дня", "дней"))").tag(days)
                    }
                }
                .labelsHidden()
            }
            .padding(.vertical, 6)
            Divider()
            Text(Trial.reminderNote(chargeDate: chargeDate, remindDaysBefore: remindDays))
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.vertical, 10)
            Button { showCancelHelp = true } label: {
                Label("Как отменить подписку", systemImage: "questionmark.circle")
            }
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 16)
        .background(.regularMaterial, in: .rect(cornerRadius: 18))
    }

    // MARK: Общее

    /// Наверху шагов 2 и 3: назад, сумма (нажать — поменять), закрыть.
    private func stepBar(back: Step, showDay: Bool) -> some View {
        let amount = input.value.map { currency.format($0) } ?? "0\u{00A0}\(currency.symbol)"
        return HStack(spacing: 8) {
            RoundButton(systemImage: "chevron.backward", label: "Назад") { go(back) }
            Spacer(minLength: 4)
            Button { go(.amount) } label: {
                Text(showDay ? "\(amount) · \(RuDate.dayTitle(date))" : amount)
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(.ultraThinMaterial, in: .capsule)
            }
            .buttonStyle(.plain)
            .accessibilityHint("Изменить сумму или день")
            Spacer(minLength: 4)
            RoundButton(systemImage: "xmark", label: "Закрыть") { dismiss() }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private func mainButton(_ title: String, enabled: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!enabled)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    // MARK: Действия

    private func setUp() {
        guard !isSetUp else { return }
        isSetUp = true
        // Считаем один раз при открытии, чтобы ввод не подтормаживал.
        suggestions = store.suggestions
        templates = store.recentTemplates
        orderedCategories = store.categoriesByUsage
        if template?.payment == nil { payment = store.lastPayment }
        if template == nil {
            // Валюта прошлой траты — без перелива подсветки при открытии.
            var instant = Transaction()
            instant.disablesAnimations = true
            withTransaction(instant) { currency = store.vault.inputCurrency }
        }
    }

    private func go(_ next: Step) {
        if next != .details { noteFocused = false }
        step = next
    }

    private func press(_ key: AmountInput.Key) {
        if amountPrefilled {
            amountPrefilled = false
            // Подставленная сумма выделена: цифра набирает новую, «стереть» правит прежнюю.
            if key != .delete { input = AmountInput() }
        }
        scanStatus = nil
        input.press(key, fractionDigits: currency.fractionDigits)
    }

    private func setDay(daysAgo: Int) {
        date = Self.keepingTime(Calendar.current.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now)
    }

    /// Выбранный день, время — сейчас: трата «вчера» встаёт на нынешний час.
    private static func keepingTime(_ day: Date) -> Date {
        let calendar = Calendar.current
        let time = calendar.dateComponents([.hour, .minute], from: .now)
        return calendar.date(bySettingHour: time.hour ?? 12, minute: time.minute ?? 0, second: 0, of: day) ?? day
    }

    /// Сумма в валюте итогов по курсам выбранного дня.
    private func converted(_ amount: Decimal, to target: Currency) -> Decimal {
        let rates = store.ratesForDay(date, currency: currency).rates
        let usd = currency == .base ? amount : amount / (rates[currency] ?? 1)
        return target == .base ? usd : usd * (rates[target] ?? 1)
    }

    private func useRecent(_ expense: Expense) {
        if input.isEmpty {
            currency = expense.currency
            input = AmountInput(amount: expense.amount, fractionDigits: expense.currency.fractionDigits)
            amountPrefilled = true
        }
        note = expense.note
        categoryTouched = true
        pickAutomatically(expense.categoryID)
        if !paymentTouched, let paid = expense.payment { payment = paid }
        go(.details)
    }

    private func apply(_ suggestion: Suggestion) {
        note = suggestion.note
        categoryTouched = true
        pickAutomatically(suggestion.categoryID)
        noteFocused = false
    }

    private func pick(_ category: ExpenseCategory) {
        categoryID = category.id
        categoryTouched = true
        autoPicked = false
        // Нажали «Подписку» сами — скорее всего, это пробный период (если трата не за прошлый день).
        if category.isSubscription {
            isTrial = template == nil && presetDate == nil && Calendar.current.isDateInToday(date)
        }
    }

    /// Категория подставилась сама (знакомое место, недавняя трата, чек) — значит, это уже оплаченное,
    /// даже если категория «Подписка». Пробный период выбирают сами.
    private func pickAutomatically(_ id: UUID) {
        categoryID = id
        autoPicked = true
        if store.category(for: id).isSubscription { isTrial = false }
    }

    private func readReceipt(_ image: UIImage) async {
        scanStatus = "Читаю чек…"
        let result = await ReceiptScanner.scan(image)
        withAnimation(.snappy) {
            if let amount = result.amount {
                input = AmountInput(amount: amount, fractionDigits: currency.fractionDigits)
                amountPrefilled = true
            }
            if let merchant = result.merchant, note.isEmpty {
                // Знакомый магазин — берём привычное название и категорию.
                if let known = SuggestionEngine.place(onReceipt: merchant, in: suggestions) {
                    note = known.note
                    if !categoryTouched { pickAutomatically(known.categoryID) }
                } else {
                    note = merchant.capitalized
                }
            }
        }
        scanStatus = result.amount == nil
            ? "Сумму не нашёл — наберите её"
            : "Проверьте сумму и нажмите «Далее»"
    }

    private func save() {
        guard let amount = input.value, let categoryID else { return }
        if subscriptionSelected && isTrial {
            store.upsert(Trial(note: savedNote, amount: amount, currency: currency, categoryID: categoryID,
                               chargeDate: Calendar.current.startOfDay(for: chargeDate), remindDaysBefore: remindDays))
            // Напоминание придёт, только если уведомления разрешены.
            Task { @MainActor in
                if await Reminders.requestPermission() { store.refreshReminders() }
            }
        } else {
            store.addExpense(amount: amount, currency: currency, categoryID: categoryID, note: savedNote, date: date,
                             payment: payment)
        }
        dismiss()
    }
}

// MARK: - Детали

/// Цифры, запятая и «стереть» — крупные клавиши на стекле.
private struct Keypad: View {
    let commaEnabled: Bool
    let onPress: (AmountInput.Key) -> Void

    var body: some View {
        VStack(spacing: 10) {
            ForEach([[1, 2, 3], [4, 5, 6], [7, 8, 9]], id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { digit($0) }
                }
            }
            HStack(spacing: 10) {
                Button { onPress(.comma) } label: { Text(",") }
                    .disabled(!commaEnabled)
                    .accessibilityLabel("Запятая")
                digit(0)
                Button { onPress(.delete) } label: { Image(systemName: "delete.left") }
                    .accessibilityLabel("Стереть")
            }
        }
        .buttonStyle(KeyStyle())
    }

    private func digit(_ value: Int) -> some View {
        Button { onPress(.digit(value)) } label: { Text(String(value)) }
    }
}

private struct KeyStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title.weight(.medium))
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity, minHeight: 46, maxHeight: 64)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
            .contentShape(.rect)
            .opacity(isEnabled ? 1 : 0.35)
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
    }
}

/// Капсула выбора дня. Выбранная — залита, остальные — на стекле.
private struct Chip: View {
    var title: String?
    var systemImage: String?
    var selected = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let systemImage { Image(systemName: systemImage) }
                if let title { Text(title) }
            }
            .font(.subheadline.weight(selected ? .semibold : .regular))
            .lineLimit(1)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .foregroundStyle(selected ? Color(.systemBackground) : Color.primary)
            .background {
                Capsule().fill(selected ? AnyShapeStyle(Color.primary) : AnyShapeStyle(.ultraThinMaterial))
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}

/// Круглая кнопка на стекле: закрыть, назад, сканировать чек.
private struct RoundButton: View {
    let systemImage: String
    let label: String
    let action: () -> Void
    @ScaledMetric(relativeTo: .body) private var side: CGFloat = 44

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.body.weight(.semibold))
                .frame(width: min(side, 60), height: min(side, 60))
                .background(.ultraThinMaterial, in: .circle)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

/// Календарь для дня раньше вчерашнего: нажали на число — и готово.
private struct DaySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var day: Date
    let onPick: (Date) -> Void

    init(day: Date, onPick: @escaping (Date) -> Void) {
        _day = State(initialValue: day)
        self.onPick = onPick
    }

    var body: some View {
        NavigationStack {
            DatePicker("День траты", selection: $day, in: ...Date.now, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationTitle("Какой день?")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Отмена") { dismiss() }
                    }
                }
        }
        .onChange(of: day) { _, picked in
            onPick(picked)
            dismiss()
        }
    }
}

/// Фон ввода: мягкое свечение цветов валюты (флага её страны) поверх фона палитры.
/// Медленно дышит; при «Уменьшении движения» стоит на месте.
private struct CurrencyGlow: View {
    let currency: Currency
    @Environment(\.palette) private var palette
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            ZStack {
                palette.background
                glow(geo.size)
                    .id(currency)
                    .transition(.opacity)
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.6), value: currency)
        .accessibilityHidden(true)
    }

    private func glow(_ size: CGSize) -> some View {
        let side = max(size.width, size.height)
        let strength = colorScheme == .dark ? 0.55 : 0.4
        let colors = currency.glowColors
        return ZStack {
            blob(colors.0.opacity(strength), side: side * 0.95)
                .position(x: size.width * 0.12, y: size.height * 0.14)
            blob(colors.1.opacity(strength * 0.85), side: side * 0.8)
                .position(x: size.width * 0.96, y: size.height * 0.4)
        }
        .phaseAnimator(reduceMotion ? [false] : [false, true]) { content, drift in
            content
                .scaleEffect(drift ? 1.08 : 1)
                .offset(x: drift ? 14 : -10, y: drift ? 18 : 0)
        } animation: { _ in
            .easeInOut(duration: 4.5)
        }
    }

    private func blob(_ color: Color, side: CGFloat) -> some View {
        Circle()
            .fill(RadialGradient(colors: [color, color.opacity(0)], center: .center,
                                 startRadius: 0, endRadius: side / 2))
            .frame(width: side, height: side)
    }
}

private extension Currency {
    /// Два цвета подсветки — из флага страны; у доллара — зелень купюр и синева.
    var glowColors: (Color, Color) {
        switch self {
        case .usd: (rgb(0x2E9E5B), rgb(0x3C6FD1))
        case .lira: (rgb(0xE30A17), rgb(0xFF8A65))
        case .eur: (rgb(0x2551C9), rgb(0xFFCC00))
        case .rub: (rgb(0x1C57C9), rgb(0xD52B1E))
        case .uzs: (rgb(0x0099B5), rgb(0x1EB53A))
        case .aed: (rgb(0x00843D), rgb(0xEF3340))
        }
    }

    private func rgb(_ hex: UInt32) -> Color {
        Color(uiColor: UIColor(hex: hex))
    }
}
