import SwiftUI

struct WidgetGuideView: View {
    var body: some View {
        Form {
            Section {
                Label {
                    Text("Одно касание на экране блокировки — и сразу открывается ввод траты.")
                } icon: {
                    Image(systemName: "plus.circle.fill").foregroundStyle(.tint)
                }
            }

            Section("Виджет под часами") {
                StepRow(number: 1, text: "Заблокируйте iPhone и нажмите на экран, чтобы он загорелся.")
                StepRow(number: 2, text: "Нажмите и подержите палец на экране блокировки.")
                StepRow(number: 3, text: "Нажмите «Настроить», затем «Экран блокировки».")
                StepRow(number: 4, text: "Нажмите на рамку под часами.")
                StepRow(number: 5, text: "Найдите Financist и выберите «Новая трата».")
                StepRow(number: 6, text: "Нажмите «Готово».")
            }

            Section {
                StepRow(number: 1, text: "На экране «Настроить» нажмите «−» у фонарика или камеры внизу.")
                StepRow(number: 2, text: "Нажмите «+» на освободившемся месте.")
                StepRow(number: 3, text: "Найдите Financist → «Новая трата».")
            } header: {
                Text("Кнопка вместо фонарика")
            } footer: {
                Text("Нужна iOS 18 или новее.")
            }

            Section {
                Label {
                    Text("Виджет не показывает никаких сумм — на экране блокировки их никто не увидит.")
                } icon: {
                    Image(systemName: "eye.slash.fill").foregroundStyle(.green)
                }
            }
        }
        .warmListBackground()
        .navigationTitle("Виджет")
        .navigationBarTitleDisplayMode(.inline)
    }
}
