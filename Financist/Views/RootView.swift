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
        Group {
            switch store.loadState {
            case .ready:
                tabs
            case .waiting:
                // iPhone ещё заблокирован или данные открываются — показываем только фон.
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(store.palette.background.ignoresSafeArea())
            case .failed(let message):
                LoadFailedView(message: message)
            }
        }
        .sheet(item: $store.pendingRestore) { RestoreView(data: $0.data) }
        .onAppear { store.loadIfNeeded() }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)) { _ in
            store.loadIfNeeded()
        }
        .onChange(of: store.loadState) { _, state in
            if state == .ready { start() }
        }
        .onReceive(NotificationCenter.default.publisher(for: AddRequest.notification)) { _ in
            store.consumeAddRequest()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background && store.lockEnabled { store.isLocked = true }
            updateCover()
            if phase == .active {
                store.loadIfNeeded()
                if store.isLocked { authenticate() }
                Task { await store.refreshRates(force: false) }
                // Новый день — переставляем вечерние напоминания на неделю вперёд.
                store.refreshReminders()
            }
        }
        .onChange(of: store.isLocked) { updateCover() }
        .alert("Данные открыты из страховочной копии", isPresented: $store.recoveredFromBackup) {
            Button("Понятно", role: .cancel) {}
        } message: {
            Text("Основной файл не прочитался, поэтому траты открыты из копии, сделанной при прошлом запуске. Проверьте, все ли последние траты на месте.")
        }
    }

    private var tabs: some View {
        @Bindable var store = store
        return TabView(selection: $store.selectedTab) {
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
    }

    /// Запуск после того, как данные открыты: замок, отложенный ввод траты, курсы.
    private func start() {
        guard !didStart else { return }
        didStart = true
        store.isLocked = store.lockEnabled
        updateCover()
        if store.isLocked { authenticate() }
        store.consumeAddRequest()
        Task { await store.refreshRates(force: false) }
    }

    /// Экран блокировки и шторка живут в отдельном окне поверх всего,
    /// включая открытые формы, — иначе они бы выглядывали из-под замка.
    private func updateCover() {
        if store.isLocked {
            CoverWindow.shared.show(LockView { authenticate() }.palette(store.palette))
        } else if scenePhase == .background {
            // Скрывает суммы в переключателе приложений.
            CoverWindow.shared.show(PrivacyCover().palette(store.palette))
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

/// Данные не открылись. Ничего не удаляем — только «попробовать ещё раз» или файл переноса.
private struct LoadFailedView: View {
    @Environment(AppStore.self) private var store
    let message: String
    @State private var showImporter = false

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "externaldrive.badge.exclamationmark")
                    .font(.largeTitle)
                    .foregroundStyle(.tint)
                Text("Не получилось открыть траты")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text("Ничего не удалено — данные на месте. Попробуйте ещё раз или перезапустите приложение. Если не поможет, траты можно вернуть из файла переноса.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button {
                    store.loadIfNeeded()
                } label: {
                    Text("Попробовать ещё раз").frame(maxWidth: 320)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Button("Загрузить файл переноса") { showImporter = true }
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .background(store.palette.background.ignoresSafeArea())
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.financistBackup, .data]) { result in
            if case .success(let url) = result { store.handle(url: url) }
        }
    }
}

struct PrivacyCover: View {
    @Environment(\.palette) private var palette

    var body: some View {
        ZStack {
            palette.background.ignoresSafeArea()
            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .foregroundStyle(.tint)
        }
    }
}

struct LockView: View {
    @Environment(\.palette) private var palette
    let onUnlockTap: () -> Void

    var body: some View {
        ZStack {
            palette.background.ignoresSafeArea()
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
