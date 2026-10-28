import LocalAuthentication
import SwiftUI

struct RootView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.scenePhase) private var scenePhase
    @State private var isLocked = false
    @State private var didStart = false

    var body: some View {
        TabView {
            ExpensesView()
                .tabItem { Label("Траты", systemImage: "list.bullet.rectangle") }
            AnalyticsView()
                .tabItem { Label("Анализ", systemImage: "chart.pie") }
            RatesView()
                .tabItem { Label("Курсы", systemImage: "arrow.left.arrow.right") }
            SettingsView()
                .tabItem { Label("Настройки", systemImage: "gear") }
        }
        .overlay {
            if isLocked {
                LockView { isLocked = false }
            } else if scenePhase != .active {
                // Скрывает суммы в переключателе приложений.
                PrivacyCover()
            }
        }
        .onAppear {
            guard !didStart else { return }
            didStart = true
            isLocked = store.lockEnabled
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background && store.lockEnabled { isLocked = true }
            if phase == .active { Task { await store.refreshRates(force: false) } }
        }
        .task { await store.refreshRates(force: false) }
        .alert("Не удалось открыть данные", isPresented: .constant(store.loadError != nil)) {
            Button("Удалить и начать заново", role: .destructive) { store.resetAll() }
            Button("Позже", role: .cancel) { store.loadError = nil }
        } message: {
            Text((store.loadError ?? "") + "\n\nМожно восстановить данные из резервной копии в Настройках.")
        }
    }
}

struct PrivacyCover: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            Image(systemName: "lock.shield")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
    }
}

struct LockView: View {
    let onUnlock: () -> Void

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("Financist заблокирован")
                    .font(.headline)
                Button("Разблокировать") { unlock() }
                    .buttonStyle(.borderedProminent)
            }
        }
        .onAppear { unlock() }
    }

    private func unlock() {
        Task { @MainActor in
            if await DeviceAuth.authenticate(reason: "Открыть Financist") { onUnlock() }
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
        default: return "Код-пароль"
        }
    }

    static func authenticate(reason: String) async -> Bool {
        let context = LAContext()
        // Если код-пароль на iPhone сняли, блокировать нечем — пускаем.
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else { return true }
        return (try? await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)) ?? false
    }
}
