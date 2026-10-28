import SwiftUI

struct CategoriesView: View {
    @Environment(AppStore.self) private var store
    @State private var editing: ExpenseCategory?

    var body: some View {
        List {
            Section {
                ForEach(store.vault.categories) { category in
                    Button { editing = category } label: {
                        HStack(spacing: 12) {
                            CategoryIcon(category: category)
                            Text(category.name)
                            Spacer(minLength: 0)
                            let count = store.expenseCount(in: category.id)
                            if count > 0 {
                                Text("\(count)")
                                    .foregroundStyle(.secondary)
                                    .accessibilityLabel(Fmt.count(count, "трата", "траты", "трат"))
                            }
                        }
                    }
                    .tint(Color.primary)
                }
                .onMove { store.moveCategories(from: $0, to: $1) }
                .onDelete { offsets in
                    store.deleteCategories(ids: offsets.map { store.vault.categories[$0].id })
                }
            } footer: {
                Text("Если удалить категорию, её траты перейдут в «\(ExpenseCategory.otherName)».")
            }
        }
        .warmBackground()
        .navigationTitle("Категории")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { EditButton() }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editing = ExpenseCategory(name: "", symbol: "star.fill", colorName: "orange")
                } label: { Image(systemName: "plus") }
                    .accessibilityLabel("Новая категория")
            }
        }
        .sheet(item: $editing) { CategoryEditView(category: $0) }
    }
}

struct CategoryEditView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var category: ExpenseCategory
    @FocusState private var nameFocused: Bool
    private let onSave: (ExpenseCategory) -> Void

    init(category: ExpenseCategory, onSave: @escaping (ExpenseCategory) -> Void = { _ in }) {
        _category = State(initialValue: category)
        self.onSave = onSave
    }

    private var isNew: Bool { !store.vault.categories.contains { $0.id == category.id } }
    private var trimmedName: String { category.name.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 12) {
                        CategoryIcon(category: category)
                        TextField("Название", text: $category.name)
                            .focused($nameFocused)
                    }
                } footer: {
                    Text("Например: «Рынок», «Бензин», «Внуки».")
                }
                Section("Цвет") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44), spacing: 10)], spacing: 10) {
                        ForEach(CategoryPalette.names, id: \.self) { name in
                            Button { category.colorName = name } label: {
                                Image(systemName: category.colorName == name ? "checkmark.circle.fill" : "circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(CategoryPalette.color(named: name))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
                Section("Значок") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 48), spacing: 8)], spacing: 8) {
                        ForEach(CategoryPalette.symbols, id: \.self) { symbol in
                            let selected = category.symbol == symbol
                            Button { category.symbol = symbol } label: {
                                Image(systemName: symbol)
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, minHeight: 48)
                                    .foregroundStyle(selected ? category.color : .secondary)
                                    .background(selected ? category.color.opacity(0.2) : .clear,
                                                in: .rect(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .warmBackground()
            .navigationTitle(isNew ? "Новая категория" : "Категория")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        category.name = trimmedName
                        store.upsert(category)
                        onSave(category)
                        dismiss()
                    }
                    .disabled(trimmedName.isEmpty)
                }
            }
            .onAppear { if isNew { nameFocused = true } }
        }
    }
}
