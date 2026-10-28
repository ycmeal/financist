import SwiftUI
import UIKit

@main
struct FinancistApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .fontDesign(.rounded)
                .onOpenURL { store.handle(url: $0) }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    /// Сторонние клавиатуры могут отправлять набранное в сеть — внутри приложения
    /// разрешена только системная клавиатура iOS.
    func application(_ application: UIApplication,
                     shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        extensionPointIdentifier != .keyboard
    }
}
