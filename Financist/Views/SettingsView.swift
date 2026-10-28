import SwiftUI

struct SettingsView: View {
    @Environment(AppStore.self) private var store
    @State private var confirmWipe = false
    @State private var confirmWipeAgain = false

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            Form {
                Section {
                    NavigationLink { PaletteView() } label: {
                        LabeledContent {
                            Text(store.palette.title)
                        } label: {
                            SettingsLabel("Оформление", symbol: "paintpalette.fill", color: "orange")
                        }
                    }
                }

                Section {
                    Picker(selection: $store.displayCurrency) {
                        ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
                    } label: {
                        SettingsLabel("Валюта итогов", symbol: "dollarsign.circle.fill", color: "green")
                    }
                } footer: {
                    Text("В ней показываются все итоги и графики.")
                }

                Section {
                    NavigationLink { CategoriesView() } label: {
                        SettingsLabel("Категории", symbol: "square.grid.2x2.fill", color: "orange")
                    }
                    NavigationLink { RatesView() } label: {
                        SettingsLabel("Курсы валют", symbol: "arrow.left.arrow.right", color: "blue")
                    }
                }

                Section {
                    NavigationLink { RecurringListView() } label: {
                        SettingsLabel("Регулярные платежи", symbol: "repeat", color: "indigo")
                    }
                    Toggle(isOn: reminderBinding) {
                        SettingsLabel("Напомнить вечером", symbol: "bell.fill", color: "red")
                    }
                    if store.eveningReminder {
                        DatePicker("Во сколько", selection: $store.eveningTime,
                                   in: reminderRange, displayedComponents: .hourAndMinute)
                    }
                } header: {
                    Text("Помощники")
                } footer: {
                    Text("Вечером iPhone пошутит и спросит, всё ли записано. Не позже 21:00, без сумм в тексте.")
                }

                Section {
                    NavigationLink { TransferView() } label: {
                        SettingsLabel("Перенос на новый iPhone", symbol: "iphone.and.arrow.forward", color: "teal")
                    }
                    NavigationLink { QuickInputView() } label: {
                        SettingsLabel("Быстрый ввод", symbol: "bolt.fill", color: "purple")
                    }
                    if !store.vault.trash.isEmpty {
                        NavigationLink { TrashView() } label: {
                            LabeledContent {
                                Text("\(store.vault.trash.count)")
                            } label: {
                                SettingsLabel("Недавно удалённые", symbol: "trash.fill", color: "gray")
                            }
                        }
                    }
                } footer: {
                    if transferFileIsOld {
                        Text("Файл переноса давно не сохраняли. Если с телефоном что-то случится, траты можно вернуть только из него.")
                    }
                }

                Section {
                    Toggle(isOn: lockBinding) {
                        SettingsLabel("Вход по \(DeviceAuth.biometryName)", symbol: "faceid", color: "green")
                    }
                    .disabled(!DeviceAuth.isAvailable)
                    NavigationLink { PrivacyPolicyView() } label: {
                        SettingsLabel("Конфиденциальность", symbol: "hand.raised.fill", color: "blue")
                    }
                } header: {
                    Text("Защита")
                } footer: {
                    Text("Все данные хранятся только на этом iPhone в зашифрованном виде и никуда не отправляются.")
                }

                Section {
                    Button("Удалить все данные", role: .destructive) { confirmWipe = true }
                } footer: {
                    Text("Financist \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                }
            }
            .warmListBackground()
            .navigationTitle("Настройки")
            // Два шага, чтобы не стереть всё случайным касанием.
            .confirmationDialog("Удалить все траты и категории?", isPresented: $confirmWipe, titleVisibility: .visible) {
                Button("Удалить всё", role: .destructive) { confirmWipeAgain = true }
            } message: {
                Text("Удалятся и все копии на этом iPhone.")
            }
            .alert("Точно удалить всё?", isPresented: $confirmWipeAgain) {
                Button("Удалить навсегда", role: .destructive) { store.resetAll() }
                Button("Отмена", role: .cancel) {}
            } message: {
                Text("Это нельзя отменить. Вернуть траты можно будет только из файла переноса.")
            }
        }
    }

    /// Мягкая подсказка: трат уже много, а файла переноса нет больше месяца.
    private var transferFileIsOld: Bool {
        guard store.vault.expenses.count >= 20 else { return false }
        guard let last = store.vault.lastTransferFileAt else { return true }
        return Date.now.timeIntervalSince(last) > 30 * 86_400
    }

    /// С 17:00 до 21:00 — позже напоминать не будем.
    private var reminderRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let from = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: .now) ?? .now
        let to = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: .now) ?? .now
        return from...to
    }

    private var reminderBinding: Binding<Bool> {
        Binding(
            get: { store.eveningReminder },
            set: { enable in
                Task { @MainActor in
                    if enable { guard await Reminders.requestPermission() else { return } }
                    store.eveningReminder = enable
                }
            }
        )
    }

    private var lockBinding: Binding<Bool> {
        Binding(
            get: { store.lockEnabled },
            set: { enable in
                Task { @MainActor in
                    // Подтверждаем личность и при включении, и при выключении.
                    if await DeviceAuth.authenticate(reason: enable ? "Включить вход по Face ID" : "Выключить вход по Face ID") {
                        store.lockEnabled = enable
                    }
                }
            }
        )
    }
}

/// Пункт настроек с цветным значком, как в «Настройках» iOS.
struct SettingsLabel: View {
    let title: String
    let symbol: String
    let color: String

    init(_ title: String, symbol: String, color: String) {
        self.title = title
        self.symbol = symbol
        self.color = color
    }

    var body: some View {
        Label {
            Text(title)
        } icon: {
            CategoryIcon(category: ExpenseCategory(name: title, symbol: symbol, colorName: color))
        }
    }
}

/// Пошаговая инструкция: номер в кружке и текст.
struct StepRow: View {
    let number: Int
    let text: String

    var body: some View {
        Label {
            Text(text)
        } icon: {
            Image(systemName: "\(number).circle.fill")
                .font(.title2)
                .foregroundStyle(.tint)
        }
        .padding(.vertical, 2)
    }
}

/// Выбор палитры: кружки светлого и тёмного варианта, название, галочка.
struct PaletteView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        Form {
            Section {
                ForEach(Palette.allCases) { palette in
                    Button {
                        withAnimation(.snappy) { store.palette = palette }
                    } label: {
                        HStack(spacing: 12) {
                            HStack(spacing: -8) {
                                Circle().fill(palette.accent)
                                Circle().fill(palette.background)
                                    .environment(\.colorScheme, .light)
                            }
                            .frame(width: 44, height: 26)
                            .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(palette.title)
                                Text(palette.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer(minLength: 0)
                            if palette == store.palette {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .tint(Color.primary)
                    .accessibilityAddTraits(palette == store.palette ? .isSelected : [])
                }
            } footer: {
                Text("Тёмная тема включается вместе с системной.")
            }
        }
        .warmListBackground()
        .navigationTitle("Оформление")
        .navigationBarTitleDisplayMode(.inline)
    }
}
