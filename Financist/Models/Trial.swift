import Foundation

/// Пробная подписка: пока бесплатно, а в указанный день спишут деньги.
/// За выбранное число дней iPhone напомнит, а в «Подписках» на главном экране будет «Пора решить»,
/// пока не нажмут «Я решил оплатить» или «Я отменил».
struct Trial: Identifiable, Codable, Hashable {
    enum Decision: String, Codable {
        /// Оставил подписку: в день списания трата запишется сама.
        case keep
        /// Отменил: денег не спишут, трата не записывается.
        case cancel
    }

    /// У записанной траты тот же id: так она не задвоится при переносе на другой iPhone.
    var id = UUID()
    /// Название: «YouTube Premium».
    var note: String
    /// Сколько спишут после пробного периода.
    var amount: Decimal
    var currency: Currency
    var categoryID: UUID
    /// День списания (начало дня).
    var chargeDate: Date
    /// За сколько дней до списания напомнить.
    var remindDaysBefore: Int
    var decision: Decision?
    var decidedAt: Date?
    /// Трата за списание уже записана — второй раз не пишется, даже если её удалили.
    var chargeRecorded = false

    static let reminderChoices = [1, 2, 3, 5, 7]
    static let defaultReminder = 2
    /// Час напоминания — утром, чтобы успеть отменить.
    static let reminderHour = 10

    /// Название для экрана: комментарий или «Пробная подписка».
    var title: String { note.isEmpty ? "Пробная подписка" : note }

    /// День напоминания (начало дня).
    var remindDay: Date {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: chargeDate)
        return calendar.date(byAdding: .day, value: -remindDaysBefore, to: day) ?? day
    }

    /// Когда прислать уведомление: в 10:00 дня напоминания.
    var reminderDate: Date? {
        Calendar.current.date(bySettingHour: Self.reminderHour, minute: 0, second: 0, of: remindDay)
    }

    /// Настал день напоминания, а решения ещё нет — в «Подписках» на главном экране «Пора решить».
    func needsDecision(now: Date = .now) -> Bool {
        decision == nil && now >= remindDay
    }

    /// Сколько дней до списания: 0 — сегодня, отрицательное — день уже прошёл.
    func daysUntilCharge(now: Date = .now) -> Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: calendar.startOfDay(for: now),
                                       to: calendar.startOfDay(for: chargeDate)).day ?? 0
    }

    /// Подпись под выбором даты: когда придёт напоминание и что будет дальше.
    static func reminderNote(chargeDate: Date, remindDaysBefore: Int, now: Date = .now) -> String {
        let probe = Trial(note: "", amount: 0, currency: .usd, categoryID: UUID(),
                          chargeDate: Calendar.current.startOfDay(for: chargeDate), remindDaysBefore: remindDaysBefore)
        guard let fire = probe.reminderDate, fire > now else {
            return "Пора решать уже сейчас: «Подписки» на главном экране будут напоминать, пока не решите."
        }
        let day = Calendar.current.isDate(fire, inSameDayAs: now) ? "сегодня" : RuDate.day(fire)
        return "Напомню \(day) в \(reminderHour):00. Пока не решите, «Подписки» на главном экране будут напоминать."
    }

    /// «Спишут завтра», «Спишут 28 ноября · через 3 дня», «Списание было 28 ноября».
    func chargeText(now: Date = .now) -> String {
        let days = daysUntilCharge(now: now)
        switch days {
        case ..<0: return "Списание было \(RuDate.day(chargeDate))"
        case 0: return "Спишут сегодня"
        case 1: return "Спишут завтра"
        case 2...7: return "Спишут \(RuDate.day(chargeDate)) · через \(Fmt.count(days, "день", "дня", "дней"))"
        default: return "Спишут \(RuDate.day(chargeDate))"
        }
    }
}

// Чтение старых и будущих файлов: необязательные поля — со значениями по умолчанию.
extension Trial {
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        note = try c.decodeIfPresent(String.self, forKey: .note) ?? ""
        amount = try c.decode(Decimal.self, forKey: .amount)
        currency = try c.decode(Currency.self, forKey: .currency)
        categoryID = try c.decode(UUID.self, forKey: .categoryID)
        chargeDate = try c.decode(Date.self, forKey: .chargeDate)
        remindDaysBefore = try c.decodeIfPresent(Int.self, forKey: .remindDaysBefore) ?? Trial.defaultReminder
        decision = try c.decodeIfPresent(Decision.self, forKey: .decision)
        decidedAt = try c.decodeIfPresent(Date.self, forKey: .decidedAt)
        chargeRecorded = try c.decodeIfPresent(Bool.self, forKey: .chargeRecorded) ?? false
    }
}

extension Vault {
    /// Особая категория «Подписка» есть всегда. В старые данные она добавляется один раз (перед «Другое»);
    /// если уже есть своя категория «Подписка» или «Подписки», особой становится она — траты не трогаются.
    /// true — если что-то поменялось.
    mutating func ensureSubscriptionCategory() -> Bool {
        if categories.contains(where: \.isSubscription) { return false }
        if let index = categories.firstIndex(where: { Self.sameName($0.name, "Подписка") || Self.sameName($0.name, "Подписки") }) {
            categories[index].kind = .subscription
        } else {
            let other = categories.firstIndex { $0.name == ExpenseCategory.otherName } ?? categories.endIndex
            categories.insert(.subscription, at: other)
        }
        return true
    }
}
