import Foundation
import UserNotifications

/// Локальные напоминания. Создаются и показываются самим iPhone — никаких серверов.
/// В тексте нет сумм и названий трат: уведомление видно на экране блокировки.
enum Reminders {
    static let addAction = "add"
    static let trialAction = "trial"
    private static let daysAhead = 7
    private static let trialPrefix = "trial-"

    /// Если за день ничего не записано.
    static let quietDay: [(title: String, body: String)] = [
        ("О, бесплатный день — это круто! 🎉", "Но может, сегодня всё-таки были траты и ты просто забыл?"),
        ("Кошелёк сегодня отдыхал? 😌", "Если что-то покупал — запиши, пока помнишь."),
        ("Ни одной траты за день! 🏆", "Рекорд экономии или просто забыл записать?"),
        ("В Financist сегодня тишина 🤫", "Даже хлеба не купил? Загляни на минутку."),
        ("День без трат — красота 🌿", "Проверь на всякий случай: такси, кофе, магазин?"),
        ("Сегодня деньги целы? 💰", "Если нет — запиши, это быстро."),
    ]

    /// Если траты уже есть.
    static let busyDay: [(title: String, body: String)] = [
        ("Вечерняя сверка 📒", "Всё записал? Если что-то забыл — самое время."),
        ("Хороший был день 👍", "Загляни: может, кофе или такси ещё не записаны?"),
        ("Почти ночь 🌙", "Перед сном проверь, все ли траты на месте."),
        ("Минутка порядка ✨", "Сверь траты за сегодня — и можно отдыхать."),
    ]

    static func requestPermission() async -> Bool {
        (try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])) ?? false
    }

    /// Ставит напоминания на неделю вперёд, каждый день — новая шутка.
    /// Сегодняшний текст зависит от того, есть ли уже траты; на следующие дни — «тихий день»,
    /// и он верен, если приложение до вечера так и не открывали.
    static func scheduleEvening(_ enabled: Bool, minutes: Int, hasExpensesToday: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: (0..<daysAhead).map { "evening-\($0)" } + ["evening"])
        guard enabled else { return }

        let calendar = Calendar.current
        let clamped = min(21 * 60, minutes)
        for offset in 0..<daysAhead {
            guard let day = calendar.date(byAdding: .day, value: offset, to: calendar.startOfDay(for: .now)),
                  let fire = calendar.date(bySettingHour: clamped / 60, minute: clamped % 60, second: 0, of: day),
                  fire > .now
            else { continue }

            let texts = offset == 0 && hasExpensesToday ? busyDay : quietDay
            // Шутка зависит от даты: каждый день разная, но стабильная при пересборке.
            let dayNumber = calendar.ordinality(of: .day, in: .era, for: day) ?? offset
            let text = texts[dayNumber % texts.count]

            let content = UNMutableNotificationContent()
            content.title = text.title
            content.body = text.body
            content.sound = .default
            content.userInfo = ["action": addAction]
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fire)
            center.add(UNNotificationRequest(identifier: "evening-\(offset)", content: content,
                                             trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false)))
        }
    }

    /// Одно ежемесячное напоминание на каждый день, когда есть регулярный платёж.
    static func scheduleRecurring(_ payments: [RecurringPayment]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: (1...28).map { "recurring-\($0)" })
        for day in Set(payments.map(\.day)) {
            let content = UNMutableNotificationContent()
            content.title = "Пора платить по счетам 🧾"
            content.body = "Сегодня регулярный платёж. Открой — запишем в одно касание."
            content.sound = .default
            var time = DateComponents()
            time.day = day
            time.hour = 10
            center.add(UNNotificationRequest(identifier: "recurring-\(day)", content: content,
                                             trigger: UNCalendarNotificationTrigger(dateMatching: time, repeats: true)))
        }
    }

    /// Пробные подписки: одно напоминание в 10:00 за выбранное число дней до списания.
    /// Названия и суммы в тексте нет — уведомление видно на экране блокировки; подробности — в приложении.
    static func scheduleTrials(_ trials: [Trial]) {
        let center = UNUserNotificationCenter.current()
        let open = trials.filter { $0.decision == nil }
        Task {
            // Убираем все прежние, в том числе удалённых подписок, и ставим заново.
            let old = await center.pendingNotificationRequests().map(\.identifier).filter { $0.hasPrefix(trialPrefix) }
            center.removePendingNotificationRequests(withIdentifiers: old)
            let calendar = Calendar.current
            for trial in open {
                guard let fire = trial.reminderDate, fire > .now else { continue }
                let days = trial.remindDaysBefore
                let content = UNMutableNotificationContent()
                content.title = "Скоро конец пробного периода ⏳"
                content.body = days == 1
                    ? "Завтра спишут деньги за подписку. Оставляем или отменяем?"
                    : "Через \(Fmt.count(days, "день", "дня", "дней")) спишут деньги за подписку. Оставляем или отменяем?"
                content.sound = .default
                content.userInfo = ["action": trialAction, "trial": trial.id.uuidString]
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fire)
                try? await center.add(UNNotificationRequest(identifier: trialPrefix + trial.id.uuidString, content: content,
                                                            trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false)))
            }
        }
    }
}

/// Нажали на напоминание о пробной подписке: открыть вопрос «оставить или отменить» по ней.
/// Флаг нужен, когда приложение запускается с нуля и данные ещё не открыты.
@MainActor
enum TrialRequest {
    static let notification = Notification.Name("financist.trial-request")
    static var pending: UUID?

    static func send(_ id: UUID) {
        pending = id
        NotificationCenter.default.post(name: notification, object: nil)
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
