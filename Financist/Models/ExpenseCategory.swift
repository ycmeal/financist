import SwiftUI

struct ExpenseCategory: Identifiable, Codable, Hashable {
    /// Особые категории. Пока одна — «Подписка»: в ней можно записать пробную подписку с напоминанием.
    enum Kind: String, Codable {
        case subscription
    }

    var id = UUID()
    var name: String
    var symbol: String
    var colorName: String
    var kind: Kind?

    var color: Color { CategoryPalette.color(named: colorName) }
    var isSubscription: Bool { kind == .subscription }

    /// Короткие названия — чтобы помещались даже при крупном шрифте.
    static let defaults: [ExpenseCategory] = [
        .init(name: "Продукты", symbol: "cart.fill", colorName: "green"),
        .init(name: "Кафе", symbol: "cup.and.saucer.fill", colorName: "orange"),
        .init(name: "Доставка", symbol: "takeoutbag.and.cup.and.straw.fill", colorName: "red"),
        .init(name: "Транспорт", symbol: "car.fill", colorName: "indigo"),
        .init(name: "Жильё", symbol: "house.fill", colorName: "brown"),
        .init(name: "Связь", symbol: "antenna.radiowaves.left.and.right", colorName: "blue"),
        .init(name: "Здоровье", symbol: "cross.case.fill", colorName: "pink"),
        .init(name: "Покупки", symbol: "bag.fill", colorName: "teal"),
        .init(name: "Одежда", symbol: "tshirt.fill", colorName: "purple"),
        .init(name: "Для дома", symbol: "sofa.fill", colorName: "mint"),
        .init(name: "Досуг", symbol: "party.popper.fill", colorName: "yellow"),
        .init(name: "Подарки", symbol: "gift.fill", colorName: "red"),
        .init(name: "Поездки", symbol: "airplane", colorName: "cyan"),
        .subscription,
        .init(name: "Другое", symbol: "ellipsis.circle.fill", colorName: "gray"),
    ]

    /// Новая категория «Подписка» (каждый раз со своим id).
    static var subscription: ExpenseCategory {
        .init(name: "Подписка", symbol: "arrow.triangle.2.circlepath", colorName: "purple", kind: .subscription)
    }

    /// Значки, имена которых были написаны с ошибкой: такого символа нет, и на iPhone был пустой цветной квадрат.
    /// Старые файлы и файлы переноса читаются с исправленным именем.
    static let renamedSymbols = ["takeout.bag.and.cup.and.straw.fill": "takeoutbag.and.cup.and.straw.fill"]

    func fixingRenamedSymbol() -> ExpenseCategory {
        var copy = self
        copy.symbol = Self.renamedSymbols[symbol] ?? symbol
        return copy
    }

    static let otherName = "Другое"
    static let unknown = ExpenseCategory(name: "Без категории", symbol: "questionmark.circle.fill", colorName: "gray")
}

enum CategoryPalette {
    static let names = ["green", "mint", "teal", "cyan", "blue", "indigo", "purple", "pink", "red", "orange", "yellow", "brown", "gray"]

    static func color(named name: String) -> Color {
        switch name {
        case "green": .green
        case "mint": .mint
        case "teal": .teal
        case "cyan": .cyan
        case "blue": .blue
        case "indigo": .indigo
        case "purple": .purple
        case "pink": .pink
        case "red": .red
        case "orange": .orange
        case "yellow": .yellow
        case "brown": .brown
        default: .gray
        }
    }

    static let symbols = [
        "cart.fill", "basket.fill", "fork.knife", "cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill",
        "wineglass.fill", "birthday.cake.fill", "carrot.fill", "fish.fill", "leaf.fill",
        "car.fill", "bus.fill", "tram.fill", "airplane", "fuelpump.fill", "parkingsign.circle.fill",
        "house.fill", "sofa.fill", "bolt.fill", "drop.fill", "flame.fill", "wifi", "phone.fill",
        "antenna.radiowaves.left.and.right", "cross.case.fill", "pills.fill", "heart.fill",
        "bag.fill", "tshirt.fill", "shoe.fill", "gift.fill", "party.popper.fill", "film.fill",
        "book.fill", "newspaper.fill", "graduationcap.fill", "pawprint.fill", "figure.walk",
        "dumbbell.fill", "scissors", "comb.fill", "wrench.and.screwdriver.fill", "hammer.fill",
        "creditcard.fill", "banknote.fill", "building.columns.fill", "arrow.triangle.2.circlepath", "hands.and.sparkles.fill",
        "sparkles", "star.fill", "ellipsis.circle.fill",
    ]
}
