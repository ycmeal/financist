import LocalAuthentication
import SwiftUI
import UIKit

struct RootView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.scenePhase) private var scenePhase
    @State private var didStart = false
    @State private var isAuthenticating = false

    var body: some View {
        @Bindable var store = store
        TabView(selection: $store.selectedTab) {
            ExpensesView()
                .tabItem { Label("Траты", systemImage: "list.bullet.rectangle.portrait") }
                .tag(AppTab.expenses)
            StatsView()
                .tabItem { Label("Итоги", systemImage: "chart.pie.fill") }
                .tag(AppTab.stats)
            SettingsView()
                .tabItem { Label("Настройки", systemImage: "gearshape") }
                .tag(AppTab.settings)
        }
        .sheet(item: $store.pendingRestore) { RestoreView(data: $0.data) }
        .onAppear {
            guard !didStart else { return }
            didStart = true
            store.isLocked = store.lockEnabled
            updateCover()
            if store.isLocked { authenticate() }
            store.consumeAddRequest()
        }
        .onReceive(NotificationCenter.default.publisher(for: AddRequest.notification)) { _ in
            store.consumeAddRequest()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background && store.lockEnabled { store.isLocked = true }
            updateCover()
            if phase == .active {
                if store.isLocked { authenticate() }
                Task { await store.refreshRates(force: false) }
                // Новый день — переставляем вечерние напоминания на неделю вперёд.
                store.refreshReminders()
            }
        }
        .onChange(of: store.isLocked) { updateCover() }
        .task { await store.refreshRates(force: false) }
        .alert("Не удалось открыть данные", isPresented: .constant(store.loadError != nil)) {
            Button("Удалить и начать заново", role: .destructive) { store.resetAll() }
            Button("Позже", role: .cancel) { store.loadError = nil }
        } message: {
            Text((store.loadError ?? "") + "\n\nДанные можно вернуть из файла переноса: Настройки → Перенос на новый iPhone.")
        }
    }

    /// Экран блокировки и шторка живут в отдельном окне поверх всего,
    /// включая открытые формы, — иначе они бы выглядывали из-под замка.
    private func updateCover() {
        if store.isLocked {
            CoverWindow.shared.show(LockView { authenticate() })
        } else if scenePhase == .background {
            // Скрывает суммы в переключателе приложений.
            CoverWindow.shared.show(PrivacyCover())
        } else {
            CoverWindow.shared.hide()
        }
    }

    private func authenticate() {
        guard !isAuthenticating else { return }
        isAuthenticating = true
        Task { @MainActor in
            if await DeviceAuth.authenticate(reason: "Открыть Financist") { store.isLocked = false }
            isAuthenticating = false
        }
    }
}

@MainActor
final class CoverWindow {
    static let shared = CoverWindow()
    private var window: UIWindow?

    func show(_ view: some View) {
        guard let scene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first else { return }
        let window = self.window ?? UIWindow(windowScene: scene)
        window.windowLevel = .alert + 1
        window.rootViewController = UIHostingController(rootView: AnyView(view.fontDesign(.rounded)))
        window.isHidden = false
        self.window = window
    }

    func hide() {
        window?.isHidden = true
        window = nil
    }
}

struct PrivacyCover: View {
    var body: some View {
        ZStack {
            Color.cozyBackground.ignoresSafeArea()
            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .foregroundStyle(.tint)
        }
    }
}

struct LockView: View {
    let onUnlockTap: () -> Void

    var body: some View {
        ZStack {
            Color.cozyBackground.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.tint)
                Text("Financist")
                    .font(.title.bold())
                Button(action: onUnlockTap) {
                    Text("Открыть").frame(maxWidth: 280)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
    }
}

enum DeviceAuth {
    /// Face ID / Touch ID с запасным вариантом — код-пароль iPhone.
    static var isAvailable: Bool {
        LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }

    static var biometryName: String {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .opticID: return "Optic ID"
        default: return "код-пароль"
        }
    }

    static func authenticate(reason: String) async -> Bool {
        let context = LAContext()
        // Если код-пароль на iPhone сняли, блокировать нечем — пускаем.
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else { return true }
        return (try? await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)) ?? false
    }
}
