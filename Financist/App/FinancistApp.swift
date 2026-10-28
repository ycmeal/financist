import SwiftUI
import UIKit
import UserNotifications

@main
struct FinancistApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .palette(store.palette)
                .fontDesign(.rounded)
                .onOpenURL { store.handle(url: $0) }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    /// Сторонние клавиатуры могут отправлять набранное в сеть — внутри приложения
    /// разрешена только системная клавиатура iOS.
    func application(_ application: UIApplication,
                     shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        extensionPointIdentifier != .keyboard
    }

    /// Нажатие на вечернее напоминание сразу открывает ввод траты.
    /// Напоминание о регулярном платеже просто открывает приложение — там ждёт карточка.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let action = response.notification.request.content.userInfo["action"] as? String
        guard action == Reminders.addAction else { return }
        await MainActor.run { AddRequest.send() }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
