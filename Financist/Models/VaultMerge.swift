import Foundation

extension Vault {
    /// Добавляет данные из другого источника (файл переноса, копия на телефоне) к текущим.
    /// Ничего не удаляет и не заменяет: траты сравниваются по id, совпадающие не задваиваются,
    /// удалённые здесь (лежат в «Недавно удалённых») не воскрешаются.
    /// Возвращает, сколько трат добавилось.
    mutating func merge(_ incoming: Vault) -> Int {
        // Новый телефон: своих трат нет — берём всё из файла целиком (с категориями и настройками),
        // оставляя только местную настройку блокировки.
        if expenses.isEmpty && trash.isEmpty && recurring.isEmpty && trials.isEmpty {
            let lock = lockEnabled
            self = incoming
            lockEnabled = lock
            schemaVersion = Vault.currentSchema
            _ = ensureSubscriptionCategory()
            return incoming.expenses.count
        }

        // Категории: тот же id — та же; «Подписка» — в свою «Подписку»; то же название — сливаем
        // в существующую; иначе добавляем.
        var categoryMap: [UUID: UUID] = [:]
        let localSubscription = categories.first(where: \.isSubscription)
        for category in incoming.categories {
            if categories.contains(where: { $0.id == category.id }) {
                categoryMap[category.id] = category.id
            } else if category.isSubscription, let localSubscription {
                categoryMap[category.id] = localSubscription.id
            } else if let same = categories.first(where: { Self.sameName($0.name, category.name) }) {
                categoryMap[category.id] = same.id
            } else {
                categories.append(category)
                categoryMap[category.id] = category.id
            }
        }
        func mapped(_ expense: Expense) -> Expense {
            var copy = expense
            copy.categoryID = categoryMap[expense.categoryID] ?? expense.categoryID
            return copy
        }

        var known = Set(expenses.map(\.id)).union(trash.map(\.id))
        var added = 0
        for expense in incoming.expenses where !known.contains(expense.id) {
            expenses.append(mapped(expense))
            known.insert(expense.id)
            added += 1
        }
        for deleted in incoming.trash where !known.contains(deleted.id) {
            trash.append(DeletedExpense(expense: mapped(deleted.expense), deletedAt: deleted.deletedAt))
            known.insert(deleted.id)
        }
        for (day, dayRates) in incoming.rateHistory where rateHistory[day] == nil {
            rateHistory[day] = dayRates
        }
        let knownRecurring = Set(recurring.map(\.id))
        for payment in incoming.recurring where !knownRecurring.contains(payment.id) {
            var copy = payment
            copy.categoryID = categoryMap[payment.categoryID] ?? payment.categoryID
            recurring.append(copy)
        }
        // Пробные подписки: новые добавляем; решение, принятое на другом телефоне, переносим сюда,
        // а принятое здесь не отменяется.
        for trial in incoming.trials {
            if let index = trials.firstIndex(where: { $0.id == trial.id }) {
                if trials[index].decision == nil, trial.decision != nil {
                    trials[index].decision = trial.decision
                    trials[index].decidedAt = trial.decidedAt
                }
                trials[index].chargeRecorded = trials[index].chargeRecorded || trial.chargeRecorded
            } else {
                var copy = trial
                copy.categoryID = categoryMap[trial.categoryID] ?? trial.categoryID
                trials.append(copy)
            }
        }
        _ = ensureSubscriptionCategory()
        return added
    }

    static func sameName(_ a: String, _ b: String) -> Bool {
        a.trimmingCharacters(in: .whitespaces).lowercased() == b.trimmingCharacters(in: .whitespaces).lowercased()
    }

    /// Убирает из «Недавно удалённых» всё старше 30 дней. true — если что-то убрали.
    mutating func purgeOldTrash(now: Date = .now) -> Bool {
        let limit = now.addingTimeInterval(-Double(DeletedExpense.keepDays) * 86_400)
        let before = trash.count
        trash.removeAll { $0.deletedAt < limit }
        return trash.count != before
    }
}
