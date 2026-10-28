import AppIntents
import Foundation

/// Ссылка, по которой приложение сразу открывает ввод новой траты.
let financistAddExpenseURL = URL(string: "financist://add")!

/// Интент кнопки на экране блокировки. Входит и в приложение, и в виджет:
/// интенты, которые открывают приложение, должны быть в обоих таргетах.
@available(iOS 18.0, *)
struct OpenAddExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Новая трата"
    static var description = IntentDescription("Открывает Financist сразу на вводе траты.")
    static var openAppWhenRun = true
    static var isDiscoverable = false

    func perform() async throws -> some IntentResult & OpensIntent {
        .result(opensIntent: OpenURLIntent(financistAddExpenseURL))
    }
}
