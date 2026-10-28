import SwiftUI

/// Все способы быстро открыть ввод траты: виджет, кнопка на экране блокировки, Siri, кнопка действия.
struct QuickInputView: View {
    var body: some View {
        Form {
            Section("Виджет под часами") {
                StepRow(number: 1, text: "Подержите палец на экране блокировки.")
                StepRow(number: 2, text: "«Настроить» → «Экран блокировки».")
                StepRow(number: 3, text: "Нажмите на рамку под часами.")
                StepRow(number: 4, text: "Выберите Financist → «Новая трата».")
            }

            Section {
                StepRow(number: 1, text: "На том же экране нажмите «−» у фонарика или камеры.")
                StepRow(number: 2, text: "Нажмите «+» и выберите Financist → «Новая трата».")
            } header: {
                Text("Кнопка вместо фонарика")
            } footer: {
                Text("Нужна iOS 18 или новее.")
            }

            Section("Siri") {
                Text("«Привет, Siri, новая трата в Financist»")
            }

            Section {
                StepRow(number: 1, text: "«Настройки» iPhone → «Кнопка действия».")
                StepRow(number: 2, text: "«Быстрая команда» → Financist → «Новая трата».")
            } header: {
                Text("Кнопка действия")
            } footer: {
                Text("Есть на iPhone 15 Pro и новее.")
            }

            Section {
                Label {
                    Text("Виджет и Siri только открывают ввод. Сумм они не видят и не показывают.")
                } icon: {
                    Image(systemName: "eye.slash.fill").foregroundStyle(.green)
                }
            }
        }
        .warmListBackground()
        .navigationTitle("Быстрый ввод")
        .navigationBarTitleDisplayMode(.inline)
    }
}
