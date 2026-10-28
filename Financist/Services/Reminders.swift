import Foundation
import UserNotifications

/// Локальные напоминания. Создаются и показываются самим iPhone — никаких серверов.
/// В тексте нет сумм и названий: уведомление видно на экране блокировки.
enum Reminders {
    static let addAction = "add"

    static func requestPermission() async -> Bool {
        (try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])) ?? false
    }

    static func scheduleEvening(_ enabled: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["evening"])
        guard enabled else { return }
        let content = UNMutableNotificationContent()
        content.title = "Financist"
        content.body = "Записали сегодняшние траты?"
        content.sound = .default
        content.userInfo = ["action": addAction]
        var time = DateComponents()
        time.hour = 21
        center.add(UNNotificationRequest(identifier: "evening", content: content,
                                         trigger: UNCalendarNotificationTrigger(dateMatching: time, repeats: true)))
    }

    /// Одно ежемесячное напоминание на каждый день, когда есть регулярный платёж.
    static func scheduleRecurring(_ payments: [RecurringPayment]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: (1...28).map { "recurring-\($0)" })
        for day in Set(payments.map(\.day)) {
            let content = UNMutableNotificationContent()
            content.title = "Financist"
            content.body = "Сегодня регулярный платёж. Откройте, чтобы записать."
            content.sound = .default
            var time = DateComponents()
            time.day = day
            time.hour = 10
            center.add(UNNotificationRequest(identifier: "recurring-\(day)", content: content,
                                             trigger: UNCalendarNotificationTrigger(dateMatching: time, repeats: true)))
        }
    }
}

/// Просьба открыть ввод траты — из уведомления, Siri или кнопки действия.
/// Флаг нужен, когда приложение запускается с нуля и экран ещё не готов.
@MainActor
enum AddRequest {
    static let notification = Notification.Name("financist.add-request")
    static var pending = false

    static func send() {
        pending = true
        NotificationCenter.default.post(name: notification, object: nil)
    }
}
