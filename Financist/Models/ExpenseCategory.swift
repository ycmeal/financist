import SwiftUI

struct ExpenseCategory: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var symbol: String
    var colorName: String

    var color: Color { CategoryPalette.color(named: colorName) }

    static let defaults: [ExpenseCategory] = [
        .init(name: "Продукты", symbol: "cart.fill", colorName: "green"),
        .init(name: "Рестораны", symbol: "fork.knife", colorName: "orange"),
        .init(name: "Доставка", symbol: "takeout.bag.and.cup.and.straw.fill", colorName: "red"),
        .init(name: "Развлечения", symbol: "party.popper.fill", colorName: "purple"),
        .init(name: "Связь", symbol: "antenna.radiowaves.left.and.right", colorName: "blue"),
        .init(name: "Жильё", symbol: "house.fill", colorName: "brown"),
        .init(name: "Здоровье", symbol: "cross.case.fill", colorName: "pink"),
        .init(name: "Покупки", symbol: "bag.fill", colorName: "teal"),
        .init(name: "Транспорт", symbol: "car.fill", colorName: "indigo"),
        .init(name: "Другое", symbol: "ellipsis.circle.fill", colorName: "gray"),
    ]

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
        "cart.fill", "fork.knife", "takeout.bag.and.cup.and.straw.fill", "cup.and.saucer.fill",
        "wineglass.fill", "birthday.cake.fill", "box.truck.fill", "party.popper.fill",
        "film.fill", "gamecontroller.fill", "music.note", "antenna.radiowaves.left.and.right",
        "wifi", "phone.fill", "house.fill", "bolt.fill", "drop.fill", "cross.case.fill",
        "pills.fill", "stethoscope", "heart.fill", "bag.fill", "tshirt.fill", "gift.fill",
        "car.fill", "bus.fill", "tram.fill", "airplane", "fuelpump.fill", "book.fill",
        "graduationcap.fill", "pawprint.fill", "dumbbell.fill", "scissors",
        "figure.and.child.holdinghands", "wrench.and.screwdriver.fill", "creditcard.fill",
        "banknote.fill", "sparkles", "ellipsis.circle.fill",
    ]
}
