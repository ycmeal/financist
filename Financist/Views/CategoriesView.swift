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
                            Spacer()
                            let count = store.expenseCount(in: category.id)
                            if count > 0 {
                                Text("\(count)")
                                    .foregroundStyle(.secondary)
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
                Text("При удалении категории её траты переедут в «\(ExpenseCategory.otherName)».")
            }
        }
        .navigationTitle("Категории")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { EditButton() }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editing = ExpenseCategory(name: "", symbol: "sparkles", colorName: "blue")
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

    init(category: ExpenseCategory) {
        _category = State(initialValue: category)
    }

    private var isNew: Bool { !store.vault.categories.contains { $0.id == category.id } }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 12) {
                        CategoryIcon(category: category)
                        TextField("Название", text: $category.name)
                    }
                }
                Section("Цвет") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                        ForEach(CategoryPalette.names, id: \.self) { name in
                            Button { category.colorName = name } label: {
                                Image(systemName: category.colorName == name ? "checkmark.circle.fill" : "circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(CategoryPalette.color(named: name))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
                Section("Значок") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(CategoryPalette.symbols, id: \.self) { symbol in
                            Button { category.symbol = symbol } label: {
                                Image(systemName: symbol)
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, minHeight: 36)
                                    .foregroundStyle(category.symbol == symbol ? category.color : .secondary)
                                    .background {
                                        if category.symbol == symbol {
                                            RoundedRectangle(cornerRadius: 8).fill(category.color.opacity(0.2))
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(isNew ? "Новая категория" : "Категория")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        category.name = category.name.trimmingCharacters(in: .whitespacesAndNewlines)
                        store.upsert(category)
                        dismiss()
                    }
                    .disabled(category.name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
