import LocalAuthentication
import SwiftUI
import UIKit

struct RootView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.scenePhase) private var scenePhase
    @State private var didStart = false
    @State private var isAuthenticating = false
    @State private var offerLock = false

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
            case .failed(let failure):
                LoadFailedView(failure: failure)
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
        .onReceive(NotificationCenter.default.publisher(for: TrialRequest.notification)) { _ in
            store.consumeTrialRequest()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background && store.lockEnabled { store.isLocked = true }
            updateCover()
            if phase == .active {
                // Открыть данные, если ещё не открыты; досохранить; обновить копии и напоминания.
                store.appBecameActive()
                if store.isLocked { authenticate() }
                Task { await store.refreshRates(force: false) }
            } else {
                // Уходим в фон — последняя попытка сохранить, если раньше не вышло.
                store.retryUnsavedChanges()
            }
        }
        .onChange(of: store.isLocked) { updateCover() }
        .alert("Защитить траты?", isPresented: $offerLock) {
            Button("Включить") { enableLock() }
            Button("Не сейчас", role: .cancel) {}
        } message: {
            Text("Тогда открыть Financist сможете только вы — по \(DeviceAuth.biometryName), даже если телефон разблокирован. Выключить можно в Настройках.")
        }
        .alert("Данные открыты из копии", isPresented: $store.recoveredFromBackup) {
            Button("Понятно", role: .cancel) {}
        } message: {
            Text("Основной файл был повреждён, поэтому траты открыты из последней копии на телефоне. Проверьте, все ли последние траты на месте.")
        }
        .alert("Траты вернулись", isPresented: Binding(get: { store.recoveredExpenses != nil },
                                                       set: { if !$0 { store.recoveredExpenses = nil } })) {
            Button("Хорошо", role: .cancel) {}
        } message: {
            Text("Нашлись траты, которые раньше не читались: \(Fmt.count(store.recoveredExpenses ?? 0, "трата", "траты", "трат")). Они снова на месте.")
        }
        .alert("Траты пока не сохранились", isPresented: Binding(get: { store.saveProblem != nil },
                                                                 set: { if !$0 { store.saveProblem = nil } })) {
            Button("Попробовать ещё раз") { store.retryUnsavedChanges() }
            Button("Позже", role: .cancel) {}
        } message: {
            switch store.saveProblem {
            case .outOfSpace:
                Text("На iPhone закончилось место. Освободите немного места (например, удалите старые видео) — Financist сохранит всё сам. Не закрывайте приложение до этого.")
            case .other(let detail):
                Text("Не закрывайте приложение — Financist попробует ещё раз.\n\n\(detail)")
            case nil:
                Text("")
            }
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
        .glassTabBar()
    }

    /// Запуск после того, как данные открыты: замок, отложенный ввод траты, курсы.
    private func start() {
        guard !didStart else { return }
        didStart = true
        store.isLocked = store.lockEnabled
        updateCover()
        if store.isLocked { authenticate() }
        store.consumeAddRequest()
        store.consumeTrialRequest()
        ShareFile.cleanUp()
        BuildAge.recordLaunch()
        Task { await store.refreshRates(force: false) }
        offerLockIfNeeded()
    }

    /// Один раз предлагаем вход по Face ID. Не мешаем, если приложение открыли сразу на ввод траты.
    private func offerLockIfNeeded() {
        let key = "lock.offered"
        guard !store.lockEnabled, DeviceAuth.isAvailable, !UserDefaults.standard.bool(forKey: key) else { return }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 800_000_000)
            // Ссылка из виджета или файл переноса могут прийти чуть позже запуска. Если сейчас открыто
            // что-то другое, спросим при следующем запуске.
            guard !store.lockEnabled, !store.isAddingExpense, store.pendingRestore == nil,
                  !store.recoveredFromBackup, store.recoveredExpenses == nil, store.saveProblem == nil
            else { return }
            UserDefaults.standard.set(true, forKey: key)
            offerLock = true
        }
    }

    private func enableLock() {
        Task { @MainActor in
            if await DeviceAuth.authenticate(reason: "Включить вход по \(DeviceAuth.biometryName)") {
                store.lockEnabled = true
            }
        }
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

/// Данные не открылись. Ничего не удаляем: «попробовать ещё раз», файл переноса
/// или «начать заново» — при этом старые файлы остаются и вернутся сами, если снова прочитаются.
private struct LoadFailedView: View {
    @Environment(AppStore.self) private var store
    let failure: LoadFailure
    @State private var showImporter = false
    @State private var confirmFresh = false
    @State private var error: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: failure == .newerVersion ? "arrow.down.app.fill" : "externaldrive.badge.exclamationmark")
                    .font(.largeTitle)
                    .foregroundStyle(.tint)
                Text(failure == .newerVersion ? "Нужна новая версия" : "Не получилось открыть траты")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text(explanation)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button {
                    store.loadIfNeeded()
                } label: {
                    Text("Попробовать ещё раз").frame(maxWidth: 320)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                if case .unreadable(let detail) = failure {
                    Button("Загрузить файл переноса") { showImporter = true }
                    Button("Начать заново, сохранив старые файлы") { confirmFresh = true }
                        .font(.subheadline)
                    Text(detail)
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                }
                if let error {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .background(store.palette.background.ignoresSafeArea())
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.financistBackup, .data]) { result in
            if case .success(let url) = result { store.handle(url: url) }
        }
        .confirmationDialog("Начать заново?", isPresented: $confirmFresh, titleVisibility: .visible) {
            Button("Начать заново") {
                do { try store.startFreshKeepingOldFiles() } catch { self.error = error.localizedDescription }
            }
        } message: {
            Text("Старые файлы не удаляются. Если они когда-нибудь снова прочитаются, траты из них вернутся сами.")
        }
    }

    private var explanation: String {
        switch failure {
        case .newerVersion:
            "Траты записаны более новой версией Financist. Обновите приложение в TestFlight — всё откроется, ничего не потеряется."
        case .unreadable:
            "Ничего не удалено — данные на месте. Попробуйте ещё раз или перезапустите приложение. Если не поможет, можно загрузить файл переноса: траты из него добавятся."
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
        default: return "код-паролю"
        }
    }

    static func authenticate(reason: String) async -> Bool {
        let context = LAContext()
        // Если код-пароль на iPhone сняли, блокировать нечем — пускаем.
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else { return true }
        return (try? await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)) ?? false
    }
}
