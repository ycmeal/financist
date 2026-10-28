import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(AppStore.self) private var store

    @State private var export: ExportItem?
    @State private var askBackupPassword = false
    @State private var backupPassword = ""
    @State private var showImporter = false
    @State private var importedData: Data?
    @State private var askRestorePassword = false
    @State private var restorePassword = ""
    @State private var confirmWipe = false
    @State private var message: String?

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            Form {
                Section {
                    Picker("Валюта ввода", selection: $store.inputCurrency) {
                        ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
                    }
                    Picker("Показывать траты в", selection: $store.displayCurrency) {
                        ForEach(Currency.allCases) { Text("\($0.flag) \($0.code)").tag($0) }
                    }
                } header: {
                    Text("Валюты")
                } footer: {
                    Text("Валюта ввода подставляется в новую трату. Итоги и графики считаются в валюте отображения по курсу на дату каждой траты.")
                }

                Section {
                    NavigationLink("Категории") { CategoriesView() }
                }

                Section {
                    Toggle(isOn: lockBinding) {
                        Label("Блокировка (\(DeviceAuth.biometryName))", systemImage: "faceid")
                    }
                    .disabled(!DeviceAuth.isAvailable)
                } header: {
                    Text("Защита")
                } footer: {
                    Text(DeviceAuth.isAvailable
                         ? "Приложение будет запрашивать Face ID или код-пароль при каждом открытии."
                         : "Чтобы включить блокировку, установи код-пароль на iPhone.")
                }

                Section {
                    Button {
                        export = ExportItem(document: DataDocument(data: store.csv()), type: .commaSeparatedText,
                                            filename: "Financist-\(Date.now.formatted(.iso8601.year().month().day())).csv")
                    } label: {
                        Label("Экспорт в CSV", systemImage: "tablecells")
                    }
                    Button {
                        backupPassword = ""
                        askBackupPassword = true
                    } label: {
                        Label("Создать резервную копию", systemImage: "lock.doc")
                    }
                    .alert("Пароль для копии", isPresented: $askBackupPassword) {
                        SecureField("Пароль (минимум 6 символов)", text: $backupPassword)
                        Button("Отмена", role: .cancel) {}
                        Button("Создать") { makeBackup() }
                    } message: {
                        Text("Копия будет зашифрована этим паролем. Без него восстановить данные невозможно — запомни его.")
                    }
                    Button {
                        showImporter = true
                    } label: {
                        Label("Восстановить из копии", systemImage: "arrow.down.doc")
                    }
                    .fileImporter(isPresented: $showImporter, allowedContentTypes: [.item]) { result in
                        readBackup(result)
                    }
                    .alert("Пароль от копии", isPresented: $askRestorePassword) {
                        SecureField("Пароль", text: $restorePassword)
                        Button("Отмена", role: .cancel) { importedData = nil }
                        Button("Восстановить", role: .destructive) { restore() }
                    } message: {
                        Text("Текущие данные на этом iPhone будут заменены данными из копии.")
                    }
                } header: {
                    Text("Данные")
                } footer: {
                    Text("Траты хранятся только на этом iPhone и не попадают в iCloud. Если телефон потеряется, данные можно вернуть только из резервной копии — сохраняй её, например, в «Файлы». CSV-экспорт не зашифрован.")
                }

                Section {
                    NavigationLink("Политика конфиденциальности") { PrivacyPolicyView() }
                    Button("Удалить все данные", role: .destructive) { confirmWipe = true }
                } footer: {
                    Text("Financist \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                }
            }
            .navigationTitle("Настройки")
            .fileExporter(isPresented: exportBinding, document: export?.document,
                          contentType: export?.type ?? .data, defaultFilename: export?.filename) { result in
                if case .failure(let error) = result { message = error.localizedDescription }
                export = nil
            }
            .confirmationDialog("Удалить все траты, категории и ключ шифрования?",
                                isPresented: $confirmWipe, titleVisibility: .visible) {
                Button("Удалить всё", role: .destructive) { store.resetAll() }
            } message: {
                Text("Это необратимо.")
            }
            .alert("Financist", isPresented: messageBinding) {
                Button("OK") { message = nil }
            } message: {
                Text(message ?? "")
            }
        }
    }

    private var lockBinding: Binding<Bool> {
        Binding(
            get: { store.lockEnabled },
            set: { enable in
                Task { @MainActor in
                    // Подтверждаем личность и при включении, и при выключении.
                    if await DeviceAuth.authenticate(reason: enable ? "Включить блокировку" : "Выключить блокировку") {
                        store.lockEnabled = enable
                    }
                }
            }
        )
    }

    private var exportBinding: Binding<Bool> {
        Binding(get: { export != nil }, set: { if !$0 { export = nil } })
    }

    private var messageBinding: Binding<Bool> {
        Binding(get: { message != nil }, set: { if !$0 { message = nil } })
    }

    private func makeBackup() {
        guard backupPassword.count >= 6 else {
            message = "Пароль слишком короткий — нужно минимум 6 символов."
            return
        }
        do {
            let data = try store.backup(password: backupPassword)
            backupPassword = ""
            export = ExportItem(document: DataDocument(data: data), type: .data,
                                filename: "Financist-\(Date.now.formatted(.iso8601.year().month().day())).fnbackup")
        } catch {
            message = error.localizedDescription
        }
    }

    private func readBackup(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            let scoped = url.startAccessingSecurityScopedResource()
            defer { if scoped { url.stopAccessingSecurityScopedResource() } }
            do {
                importedData = try Data(contentsOf: url)
                restorePassword = ""
                askRestorePassword = true
            } catch {
                message = error.localizedDescription
            }
        case .failure(let error):
            message = error.localizedDescription
        }
    }

    private func restore() {
        guard let data = importedData else { return }
        do {
            try store.restore(from: data, password: restorePassword)
            message = "Данные восстановлены: \(store.vault.expenses.count) \(Fmt.plural(store.vault.expenses.count, "трата", "траты", "трат"))."
        } catch {
            message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        importedData = nil
        restorePassword = ""
    }
}

struct ExportItem {
    var document: DataDocument
    var type: UTType
    var filename: String
}

struct DataDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.data] }
    static var writableContentTypes: [UTType] { [.data, .commaSeparatedText] }

    var data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}
