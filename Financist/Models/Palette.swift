import SwiftUI
import UIKit

/// Цветовые палитры. Выбираются в «Настройки → Оформление», по умолчанию — шалфей.
/// У каждой есть светлый и тёмный вариант, iOS переключает их сама.
enum Palette: String, Codable, CaseIterable, Identifiable {
    case sage, terracotta, honey, plum, sea, classic

    var id: Self { self }

    var title: String {
        switch self {
        case .sage: "Шалфей"
        case .terracotta: "Терракота"
        case .honey: "Мёд"
        case .plum: "Слива"
        case .sea: "Море"
        case .classic: "Классика iOS"
        }
    }

    var subtitle: String {
        switch self {
        case .sage: "Спокойный зелёный, как сад"
        case .terracotta: "Тёплая глина и сливки"
        case .honey: "Золотистый и солнечный"
        case .plum: "Глубокий ягодный"
        case .sea: "Бирюза и бриз"
        case .classic: "Как стандартные приложения Apple"
        }
    }

    /// (акцент светлый, акцент тёмный, фон светлый, фон тёмный)
    private var hex: (UInt32, UInt32, UInt32, UInt32) {
        switch self {
        case .sage: (0x4F7D5C, 0x86B994, 0xF2F4EC, 0x161B17)
        case .terracotta: (0xD16B2E, 0xF58F4F, 0xFBF4EC, 0x1E1915)
        case .honey: (0xA86A00, 0xF2B53C, 0xFBF5E6, 0x1C170D)
        case .plum: (0x86447A, 0xD08FC4, 0xF7F1F4, 0x1B1419)
        case .sea: (0x17707F, 0x5CC0D1, 0xEDF4F4, 0x10191B)
        case .classic: (0x007AFF, 0x0A84FF, 0xF2F2F7, 0x000000)
        }
    }

    var accent: Color { Color(light: hex.0, dark: hex.1) }
    var background: Color { Color(light: hex.2, dark: hex.3) }
}

extension Color {
    init(light: UInt32, dark: UInt32) {
        self.init(UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

extension UIColor {
    convenience init(hex: UInt32) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255,
                  green: CGFloat((hex >> 8) & 0xFF) / 255,
                  blue: CGFloat(hex & 0xFF) / 255,
                  alpha: 1)
    }
}

private struct PaletteKey: EnvironmentKey {
    static let defaultValue: Palette = .sage
}

extension EnvironmentValues {
    var palette: Palette {
        get { self[PaletteKey.self] }
        set { self[PaletteKey.self] = newValue }
    }
}

extension View {
    /// Палитра для всего, что ниже: акцент (tint) и фон.
    func palette(_ palette: Palette) -> some View {
        environment(\.palette, palette).tint(palette.accent)
    }
}
