import SwiftUI

extension View {
    /// Плашка внизу после удаления траты: таймер и «Вернуть». Ставится на `NavigationStack` вкладки,
    /// поэтому стоит над панелью вкладок и не закрывает её.
    func undoToast() -> some View {
        modifier(UndoToastModifier())
    }
}

private struct UndoToastModifier: ViewModifier {
    @Environment(AppStore.self) private var store

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom) {
                if let deletion = store.lastDeletion {
                    UndoToast(deletion: deletion)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.snappy, value: store.lastDeletion?.id)
    }
}

/// «Удалено: Migros · Вернуть» с кругом-таймером. Через 6 секунд уходит сама.
private struct UndoToast: View {
    @Environment(AppStore.self) private var store
    @Environment(\.palette) private var palette
    let deletion: AppStore.Deletion

    var body: some View {
        TimelineView(.periodic(from: deletion.date, by: 0.2)) { context in
            let left = max(0, AppStore.undoSeconds - context.date.timeIntervalSince(deletion.date))
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.25), lineWidth: 3)
                    Circle()
                        .trim(from: 0, to: left / AppStore.undoSeconds)
                        .stroke(palette.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(left.rounded(.up)))")
                        .font(.caption.weight(.bold))
                        .monospacedDigit()
                }
                .frame(width: 30, height: 30)
                .accessibilityHidden(true)

                Text(deletion.title)
                    .lineLimit(2)
                Spacer(minLength: 0)
                Button("Вернуть") {
                    withAnimation(.snappy) { store.undoLastDeletion() }
                }
                .fontWeight(.semibold)
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: .rect(cornerRadius: 18))
            .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
        }
        .task(id: deletion.id) {
            try? await Task.sleep(for: .seconds(AppStore.undoSeconds))
            guard !Task.isCancelled else { return }
            withAnimation(.snappy) { store.hideDeletion(deletion.id) }
        }
    }
}
