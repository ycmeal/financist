import AppIntents

/// «Привет, Siri, новая трата в Financist» — и кнопка действия на iPhone 15 Pro и новее.
/// Интент выполняется внутри приложения и просто открывает ввод траты.
struct AddExpenseShortcutIntent: AppIntent {
    static var title: LocalizedStringResource = "Новая трата"
    static var description = IntentDescription("Открывает Financist сразу на вводе траты.")
    static var openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        AddRequest.send()
        return .result()
    }
}

struct FinancistShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddExpenseShortcutIntent(),
            phrases: [
                "Новая трата в \(.applicationName)",
                "Записать трату в \(.applicationName)",
            ],
            shortTitle: "Новая трата",
            systemImageName: "plus.circle.fill"
        )
    }
}
