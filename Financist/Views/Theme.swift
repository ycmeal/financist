import SwiftUI
import UniformTypeIdentifiers

extension Color {
    /// Тёплый кремовый фон (в тёмной теме — тёплый тёмный).
    static let cozyBackground = Color("WarmBackground")
}

extension UTType {
    static let financistBackup = UTType(exportedAs: "com.ycmeal.financist.backup")
}

extension View {
    /// Тёплый фон вместо серого для списков и форм.
    func warmListBackground() -> some View {
        scrollContentBackground(.hidden)
            .background(Color.cozyBackground.ignoresSafeArea())
    }
}

/// Значок категории в цветном скруглённом квадрате, как в «Настройках» iOS.
/// Растёт вместе с размером шрифта.
struct CategoryIcon: View {
    let category: ExpenseCategory
    @ScaledMetric(relativeTo: .body) private var size: CGFloat = 34

    var body: some View {
        Image(systemName: category.symbol)
            .font(.system(size: size * 0.5, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(category.color.gradient, in: .rect(cornerRadius: size * 0.26))
            .accessibilityHidden(true)
    }
}

/// При очень крупном шрифте ставит элементы друг под другом, иначе — в строку.
struct AdaptiveRow<Content: View>: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    var spacing: CGFloat = 12
    @ViewBuilder let content: Content

    var body: some View {
        let layout = typeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 6))
            : AnyLayout(HStackLayout(spacing: spacing))
        layout { content }
    }
}

struct DisplayCurrencyMenu: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        @Bindable var store = store
        Menu {
            Picker("Показывать в валюте", selection: $store.displayCurrency) {
                ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
            }
        } label: {
            Text(store.displayCurrency.code)
                .font(.subheadline.weight(.semibold))
        }
        .accessibilityLabel("Валюта итогов: \(store.displayCurrency.code)")
    }
}
