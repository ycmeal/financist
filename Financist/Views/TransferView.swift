import SwiftUI
import UIKit

/// Перенос на новый iPhone: файл, зашифрованный паролем, + пошаговая инструкция.
struct TransferView: View {
    @Environment(AppStore.self) private var store
    @State private var askPassword = false
    @State private var password = ""
    @State private var passwordRepeat = ""
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
                    passwordRepeat = ""
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
                StepRow(number: 3, text: "Введите пароль. Траты из файла добавятся к тем, что уже есть, — ничего не пропадёт.")
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
                NavigationLink {
                    SafetyCopiesView()
                } label: {
                    Label("Копии на этом iPhone", systemImage: "clock.arrow.circlepath")
                }
            } footer: {
                Text("Financist сам хранит копии на телефоне: каждый день, каждую неделю и перед обновлениями. Из них можно вернуть траты.")
            }

            Section {
                Button {
                    ShareFile.cleanUp()
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
            SecureField("Ещё раз", text: $passwordRepeat)
            Button("Отмена", role: .cancel) {}
            Button("Сохранить") { makeBackup() }
        } message: {
            Text("Не короче \(BackupCrypto.minimumPasswordLength) символов и хотя бы одна буква. Лучше фраза из нескольких слов, например «чай у моря в Анталье». Запишите её — она понадобится на новом iPhone.")
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.financistBackup, .data]) { result in
            switch result {
            case .success(let url): store.handle(url: url)
            case .failure(let error): message = error.localizedDescription
            }
        }
        // Временный файл не удаляем при закрытии окна: AirDrop может ещё отправлять.
        // Он удаляется при следующем открытии этого экрана или приложения.
        .sheet(item: $shareFile) { file in
            ShareSheet(items: [file.url]) { completed in
                if completed && file.url.pathExtension == "fnbackup" { store.markTransferFileSaved() }
            }
            .presentationDetents([.medium, .large])
        }
        .onAppear(perform: ShareFile.cleanUp)
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
        if let problem = BackupCrypto.passwordProblem(password, repeated: passwordRepeat) {
            message = problem
            password = ""
            passwordRepeat = ""
            return
        }
        do {
            let data = try store.backup(password: password)
            password = ""
            passwordRepeat = ""
            ShareFile.cleanUp()
            shareFile = ShareFile.write(data, name: "Financist \(Self.today).fnbackup")
            if shareFile == nil { message = "Не удалось подготовить файл." }
        } catch {
            message = error.localizedDescription
        }
    }
}

/// Временный файл для отправки. Удаляется при следующем открытии экрана «Перенос» или приложения.
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

    /// Удаляет прошлые временные файлы для отправки.
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
    var onComplete: (Bool) -> Void = { _ in }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // completed = true, только если файл действительно отправили или сохранили.
        controller.completionWithItemsHandler = { _, completed, _, _ in
            DispatchQueue.main.async { onComplete(completed) }
        }
        return controller
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
    @State private var addedCount: Int?
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            Form {
                if let addedCount {
                    Section {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.green)
                            Text("Готово!")
                                .font(.title2.bold())
                            Text(addedCount > 0
                                 ? "Добавлено: \(Fmt.count(addedCount, "трата", "траты", "трат"))."
                                 : "Все траты из этого файла уже есть на телефоне.")
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
                        } else {
                            Text("Траты из файла добавятся к тем, что уже есть. Совпадающие не задвоятся, ничего не пропадёт.")
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
                    Button(addedCount == nil ? "Отмена" : "Закрыть") { dismiss() }
                }
            }
            .onAppear { focused = true }
        }
    }

    private func restore() {
        guard !password.isEmpty else { return }
        do {
            addedCount = try store.restore(from: data, password: password)
            error = nil
        } catch {
            self.error = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}

/// Копии на телефоне. Из любой можно добавить траты обратно — это ничего не удаляет.
struct SafetyCopiesView: View {
    @Environment(AppStore.self) private var store
    @State private var counts: [URL: Int?] = [:]
    @State private var message: String?

    var body: some View {
        let copies = store.safetyCopies
        List {
            Section {
                ForEach(copies) { copy in
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(copy.title)
                            Text(subtitle(copy))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 0)
                        if case .some(.some(_)) = counts[copy.url] {
                            Button("Вернуть") { merge(copy) }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                        }
                    }
                }
            } footer: {
                Text("«Вернуть» добавляет траты из копии к текущим. Совпадающие не задвоятся, ничего не удалится.")
            }
        }
        .warmListBackground()
        .overlay {
            if copies.isEmpty {
                ContentUnavailableView("Копий пока нет", systemImage: "clock.arrow.circlepath",
                                       description: Text("Они появятся сами после следующего запуска."))
            }
        }
        .navigationTitle("Копии на iPhone")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            for copy in copies { counts[copy.url] = store.expenseCount(in: copy) }
        }
        .alert("Financist", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: {
            Text(message ?? "")
        }
    }

    private func subtitle(_ copy: AppStore.SafetyCopy) -> String {
        let date = "\(RuDate.dayTitle(copy.date)), \(RuDate.time(copy.date))"
        switch counts[copy.url] {
        case .some(.some(let count)): return "\(date) · \(Fmt.count(count, "трата", "траты", "трат"))"
        case .some(.none): return "\(date) · сейчас не читается"
        case .none: return date
        }
    }

    private func merge(_ copy: AppStore.SafetyCopy) {
        do {
            let added = try store.mergeCopy(copy)
            message = added > 0
                ? "Добавлено: \(Fmt.count(added, "трата", "траты", "трат"))."
                : "Все траты из этой копии уже есть."
        } catch {
            message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}

/// «Недавно удалённые»: траты лежат здесь 30 дней, их можно вернуть.
struct TrashView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        let items = store.vault.trash.sorted { $0.deletedAt > $1.deletedAt }
        List {
            Section {
                ForEach(items) { deleted in
                    HStack(spacing: 12) {
                        ExpenseRow(expense: deleted.expense, showDate: true)
                        Button("Вернуть") {
                            withAnimation(.snappy) { store.restoreFromTrash(ids: [deleted.id]) }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
            } footer: {
                Text("Удалённые траты хранятся здесь \(DeletedExpense.keepDays) дней, потом исчезают сами.")
            }
        }
        .warmListBackground()
        .overlay {
            if items.isEmpty {
                ContentUnavailableView("Пусто", systemImage: "trash",
                                       description: Text("Здесь появятся удалённые траты."))
            }
        }
        .navigationTitle("Недавно удалённые")
        .navigationBarTitleDisplayMode(.inline)
    }
}
