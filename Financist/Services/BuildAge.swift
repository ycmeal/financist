import Foundation

/// Сборка из TestFlight живёт 90 дней, потом перестаёт открываться (траты при этом остаются на телефоне).
/// Дату загрузки приложение узнать не может, поэтому считает от первого запуска этой сборки на телефоне —
/// с автообновлениями в TestFlight это почти одно и то же.
///
/// Хранится в UserDefaults: это не данные пользователя, а служебная дата, и формат файла с тратами
/// из-за неё не меняется.
enum BuildAge {
    static let warnAfterDays = 75
    static let snoozeDays = 3

    private static let tagKey = "build.tag"
    private static let firstLaunchKey = "build.firstLaunch"
    private static let snoozeKey = "build.warningSnoozedUntil"

    private static var currentTag: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "0"
        let build = info?["CFBundleVersion"] as? String ?? "0"
        return "\(version)-\(build)"
    }

    /// Запоминает первый запуск текущей сборки. Новая сборка — новый отсчёт.
    /// Вызывать, когда iPhone разблокирован (после открытия данных).
    static func recordLaunch(now: Date = .now, defaults: UserDefaults = .standard) {
        guard defaults.string(forKey: tagKey) != currentTag else { return }
        defaults.set(currentTag, forKey: tagKey)
        defaults.set(now, forKey: firstLaunchKey)
        defaults.removeObject(forKey: snoozeKey)
    }

    /// Показывать ли плашку «эта версия скоро перестанет открываться».
    static func shouldWarn(now: Date = .now, defaults: UserDefaults = .standard) -> Bool {
        #if DEBUG
        // При запуске из Xcode срок другой — не пугаем.
        return false
        #else
        return shouldWarn(firstLaunch: defaults.object(forKey: firstLaunchKey) as? Date,
                          snoozedUntil: defaults.object(forKey: snoozeKey) as? Date,
                          now: now)
        #endif
    }

    static func shouldWarn(firstLaunch: Date?, snoozedUntil: Date?, now: Date) -> Bool {
        guard let firstLaunch else { return false }
        if let snoozedUntil, snoozedUntil > now { return false }
        return now.timeIntervalSince(firstLaunch) >= Double(warnAfterDays) * 86_400
    }

    /// «Понятно» — спрятать на несколько дней.
    static func snooze(now: Date = .now, defaults: UserDefaults = .standard) {
        defaults.set(now.addingTimeInterval(Double(snoozeDays) * 86_400), forKey: snoozeKey)
    }
}
