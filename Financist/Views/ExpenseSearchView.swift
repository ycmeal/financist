import SwiftUI

/// Поиск по тратам — отдельным листом по кнопке-лупе, чтобы верх «Трат» оставался картинкой.
struct ExpenseSearchView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var isSearching = false
    @State private var editing: Expense?
    @State private var keys = NoteKeys()

    private var trimmed: String { query.trimmingCharacters(in: .whitespaces) }

    private var results: [Expense] {
        guard !trimmed.isEmpty else { return [] }
        let sound = SuggestionEngine.key(trimmed)
        return store.vault.expenses
            .filter {
                $0.note.localizedCaseInsensitiveContains(trimmed)
                    || store.category(for: $0.categoryID).name.localizedCaseInsensitiveContains(trimmed)
                    // По звучанию: «мигрос» находит Migros, «apteka» — «Аптека».
                    || (!sound.isEmpty && keys[$0.note].contains(sound))
            }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            List(results) { expense in
                Button { editing = expense } label: { ExpenseRow(expense: expense, showDate: true) }
                    .tint(Color.primary)
            }
            .overlay {
                if trimmed.isEmpty {
                    ContentUnavailableView("Поиск по тратам", systemImage: "magnifyingglass",
                                           description: Text("Место или категория: Migros, аптека, такси. Можно по-русски: «мигрос» найдёт Migros."))
                } else if results.isEmpty {
                    ContentUnavailableView.search(text: trimmed)
                }
            }
            .warmListBackground()
            .navigationTitle("Поиск")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, isPresented: $isSearching,
                        placement: .navigationBarDrawer(displayMode: .always), prompt: "Migros, аптека, такси")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                }
            }
            .sheet(item: $editing) { ExpenseFormView(expense: $0) }
            .undoToast()
            .task {
                // Сразу ставим курсор в поле поиска, когда лист уже открылся.
                try? await Task.sleep(for: .milliseconds(350))
                isSearching = true
            }
        }
    }
}

/// Ключи названий для поиска по звучанию — считаются один раз на название: одно место встречается много раз.
final class NoteKeys {
    private var cache: [String: String] = [:]

    subscript(_ note: String) -> String {
        if let key = cache[note] { return key }
        let key = SuggestionEngine.key(note)
        cache[note] = key
        return key
    }
}
