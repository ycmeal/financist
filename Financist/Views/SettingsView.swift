import SwiftUI

struct SettingsView: View {
    @Environment(AppStore.self) private var store
    @State private var confirmWipe = false

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            Form {
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
                    NavigationLink { BudgetView() } label: {
                        SettingsLabel("Бюджет на месяц", symbol: "gauge.with.needle.fill", color: "green")
                    }
                    NavigationLink { RecurringListView() } label: {
                        SettingsLabel("Регулярные платежи", symbol: "repeat", color: "indigo")
                    }
                    Toggle(isOn: reminderBinding) {
                        SettingsLabel("Напомнить вечером", symbol: "bell.fill", color: "red")
                    }
                    NavigationLink { SiriGuideView() } label: {
                        SettingsLabel("Siri и кнопка действия", symbol: "mic.fill", color: "pink")
                    }
                } header: {
                    Text("Помощники")
                } footer: {
                    Text("В 21:00 iPhone спросит, записали ли вы траты. Напоминания создаёт сам телефон.")
                }

                Section {
                    NavigationLink { TransferView() } label: {
                        SettingsLabel("Перенос на новый iPhone", symbol: "iphone.and.arrow.forward", color: "teal")
                    }
                    NavigationLink { WidgetGuideView() } label: {
                        SettingsLabel("Виджет на экран блокировки", symbol: "lock.rectangle.on.rectangle.fill", color: "purple")
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
            .confirmationDialog("Удалить все траты и категории?", isPresented: $confirmWipe, titleVisibility: .visible) {
                Button("Удалить всё", role: .destructive) { store.resetAll() }
            } message: {
                Text("Вернуть их можно будет только из файла переноса.")
            }
        }
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
