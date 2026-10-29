import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let financistBackup = UTType(exportedAs: "com.ycmeal.financist.backup")
}

extension View {
    /// Фон палитры вместо серого для списков и форм.
    func warmListBackground() -> some View {
        modifier(PaletteListBackground())
    }
}

private struct PaletteListBackground: ViewModifier {
    @Environment(\.palette) private var palette

    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(palette.background.ignoresSafeArea())
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
            .background(category.color, in: .rect(cornerRadius: size * 0.26))
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

extension View {
    /// В iOS 26 системная панель вкладок стеклянная (Liquid Glass) сама по себе — достаточно собрать
    /// приложение в Xcode 26. Здесь только сворачиваем её при прокрутке вниз, как в стандартных приложениях.
    /// В старых Xcode этой функции нет, поэтому код спрятан за проверкой версии компилятора.
    @ViewBuilder
    func glassTabBar() -> some View {
        #if compiler(>=6.2)
        if #available(iOS 26.0, *) {
            self.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            self
        }
        #else
        self
        #endif
    }
}

extension View {
    /// Откуда «вырастает» экран (iOS 18): кнопка или строка. На iOS 17 — обычное появление.
    @ViewBuilder
    func zoomSource(_ id: some Hashable, in namespace: Namespace.ID) -> some View {
        #if compiler(>=6.0)
        if #available(iOS 18.0, *) {
            self.matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
        #else
        self
        #endif
    }

    /// Экран, который «вырастает» из `zoomSource` с тем же id и сворачивается обратно.
    @ViewBuilder
    func zoomDestination(_ id: some Hashable, in namespace: Namespace.ID) -> some View {
        #if compiler(>=6.0)
        if #available(iOS 18.0, *) {
            self.navigationTransition(.zoom(sourceID: id, in: namespace))
        } else {
            self
        }
        #else
        self
        #endif
    }
}
