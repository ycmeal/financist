import SwiftUI

/// Поиск по тратам — отдельным листом по кнопке-лупе, чтобы верх «Трат» оставался картинкой.
struct ExpenseSearchView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var isSearching = false
    @State private var editing: Expense?
    @State private var keys = NoteKeys()
    /// Известные места с их написаниями — для «карфур» → Carrefour. Считаются один раз при открытии.
    @State private var places: [Suggestion] = []

    private var trimmed: String { query.trimmingCharacters(in: .whitespaces) }

    /// Как подсказки «На что?»: по-русски и латиницей, по известным написаниям и по категории.
    private var results: [Expense] {
        let search = SearchQuery(trimmed, places: places)
        guard !search.isEmpty else { return [] }
        return store.vault.expenses
            .filter { expense in
                let category = store.category(for: expense.categoryID).name
                return search.matches(note: expense.note, noteKey: keys[expense.note],
                                      category: category, categoryKey: keys[category])
            }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        let found = results
        let display = store.displayCurrency
        NavigationStack {
            List {
                if !found.isEmpty {
                    Section {
                        ForEach(found) { expense in
                            Button { editing = expense } label: { ExpenseRow(expense: expense, showDate: true) }
                                .tint(Color.primary)
                        }
                    } header: {
                        // Сколько всего: «22 траты · 3 450 ₺».
                        Text("\(Fmt.count(found.count, "трата", "траты", "трат")) · \(display.format(found.total(in: display).rounded(scale: 2)))")
                            .monospacedDigit()
                    }
                }
            }
            .overlay {
                if trimmed.isEmpty {
                    ContentUnavailableView("Поиск по тратам", systemImage: "magnifyingglass",
                                           description: Text("Место или категория: Migros, аптека, такси. Можно по-русски: «мигрос» найдёт Migros, «карфур» — Carrefour."))
                } else if found.isEmpty {
                    ContentUnavailableView.search(text: trimmed)
                }
            }
            .onAppear {
                if places.isEmpty { places = store.suggestions }
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
