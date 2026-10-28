import SwiftUI
import UIKit

/// Перенос на новый iPhone: файл, зашифрованный паролем, + пошаговая инструкция.
struct TransferView: View {
    @Environment(AppStore.self) private var store
    @State private var askPassword = false
    @State private var password = ""
    @State private var shareFile: ShareFile?
    @State private var showImporter = false
    @State private var message: String?

    var body: some View {
        Form {
            Section {
                StepRow(number: 1, text: "Нажмите «Сохранить файл».")
                StepRow(number: 2, text: "Придумайте пароль и запишите его.")
                StepRow(number: 3, text: "Отправьте файл на новый iPhone через AirDrop или сохраните в «Файлы».")
                Button {
                    password = ""
                    askPassword = true
                } label: {
                    Label("Сохранить файл", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(store.vault.expenses.isEmpty)
            } header: {
                Text("На старом iPhone")
            } footer: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("В файле \(Fmt.count(store.vault.expenses.count, "трата", "траты", "трат")), категории и курсы.")
                    if let last = store.vault.lastTransferFileAt {
                        Text("Последний раз сохраняли: \(RuDate.dayTitle(last)).")
                    } else {
                        Text("Файл ещё ни разу не сохраняли.")
                    }
                }
            }

            Section {
                StepRow(number: 1, text: "Установите Financist.")
                StepRow(number: 2, text: "Откройте полученный файл — iPhone предложит Financist. Или нажмите «Загрузить файл» ниже.")
                StepRow(number: 3, text: "Введите пароль. Готово!")
                Button {
                    showImporter = true
                } label: {
                    Label("Загрузить файл", systemImage: "square.and.arrow.down")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            } header: {
                Text("На новом iPhone")
            }

            Section {
                Label {
                    Text("Файл зашифрован паролем. Без пароля его не откроет никто — даже разработчик. Пароль нигде не сохраняется, поэтому не теряйте его.")
                } icon: {
                    Image(systemName: "lock.shield.fill").foregroundStyle(.green)
                }
            }

            Section {
                Button {
                    shareFile = ShareFile.write(store.csv(), name: "Financist \(Self.today).csv")
                } label: {
                    Label("Таблица для Excel", systemImage: "tablecells")
                }
            } footer: {
                Text("Таблица не зашифрована — делитесь ей осторожно.")
            }
        }
        .warmListBackground()
        .navigationTitle("Перенос")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Пароль для файла", isPresented: $askPassword) {
            SecureField("Пароль", text: $password)
            Button("Отмена", role: .cancel) {}
            Button("Сохранить") { makeBackup() }
        } message: {
            Text("Не короче 4 символов. Запишите его — он понадобится на новом iPhone.")
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.financistBackup, .data]) { result in
            switch result {
            case .success(let url): store.handle(url: url)
            case .failure(let error): message = error.localizedDescription
            }
        }
        .sheet(item: $shareFile, onDismiss: ShareFile.cleanUp) { file in
            ShareSheet(items: [file.url])
                .presentationDetents([.medium, .large])
        }
        .alert("Financist", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: {
            Text(message ?? "")
        }
    }

    private static var today: String {
        Date.now.formatted(.iso8601.year().month().day())
    }

    private func makeBackup() {
        guard password.count >= 4 else {
            message = "Пароль слишком короткий — нужно хотя бы 4 символа."
            return
        }
        do {
            let data = try store.backup(password: password)
            password = ""
            shareFile = ShareFile.write(data, name: "Financist \(Self.today).fnbackup")
            if shareFile == nil { message = "Не удалось подготовить файл." }
        } catch {
            message = error.localizedDescription
        }
    }
}

/// Временный файл для отправки. Удаляется после закрытия окна «Поделиться».
struct ShareFile: Identifiable {
    let url: URL
    var id: URL { url }

    static func write(_ data: Data, name: String) -> ShareFile? {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        do {
            try data.write(to: url, options: [.atomic, .completeFileProtection])
            return ShareFile(url: url)
        } catch {
            return nil
        }
    }

    /// Удаляет временные файлы после отправки.
    static func cleanUp() {
        let dir = FileManager.default.temporaryDirectory
        let files = (try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)) ?? []
        for file in files where ["fnbackup", "csv"].contains(file.pathExtension) {
            try? FileManager.default.removeItem(at: file)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}

/// Восстановление из файла: открывается из «Загрузить файл» или из AirDrop.
struct RestoreView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    let data: Data
    @State private var password = ""
    @State private var error: String?
    @State private var restoredCount: Int?
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            Form {
                if let restoredCount {
                    Section {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.green)
                            Text("Готово!")
                                .font(.title2.bold())
                            Text("Загружено: \(Fmt.count(restoredCount, "трата", "траты", "трат")).")
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                    }
                } else {
                    Section {
                        SecureField("Пароль от файла", text: $password)
                            .focused($focused)
                            .submitLabel(.go)
                            .onSubmit(restore)
                    } footer: {
                        if let error {
                            Text(error).foregroundStyle(.red)
                        } else if !store.vault.expenses.isEmpty {
                            Text("Траты на этом iPhone (\(store.vault.expenses.count)) будут заменены данными из файла.")
                        }
                    }
                    Section {
                        Button { restore() } label: {
                            Text("Загрузить")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(password.isEmpty)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .warmListBackground()
            .navigationTitle("Загрузка трат")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(restoredCount == nil ? "Отмена" : "Закрыть") { dismiss() }
                }
            }
            .onAppear { focused = true }
        }
    }

    private func restore() {
        guard !password.isEmpty else { return }
        do {
            try store.restore(from: data, password: password)
            restoredCount = store.vault.expenses.count
            error = nil
        } catch {
            self.error = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}
