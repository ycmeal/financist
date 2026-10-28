import AppIntents
import SwiftUI
import WidgetKit

/// Виджет — просто кнопка. Он не читает и не показывает траты,
/// поэтому на экране блокировки никто не увидит сумм.
struct AddExpenseEntry: TimelineEntry {
    let date: Date
}

struct AddExpenseProvider: TimelineProvider {
    func placeholder(in context: Context) -> AddExpenseEntry { AddExpenseEntry(date: .now) }

    func getSnapshot(in context: Context, completion: @escaping (AddExpenseEntry) -> Void) {
        completion(AddExpenseEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AddExpenseEntry>) -> Void) {
        completion(Timeline(entries: [AddExpenseEntry(date: .now)], policy: .never))
    }
}

struct AddExpenseWidgetView: View {
    @Environment(\.widgetFamily) private var family

    var body: some View {
        content
            .widgetURL(financistAddExpenseURL)
            .containerBackground(for: .widget) {
                if family == .systemSmall { Color("WidgetBackground") } else { Color.clear }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "plus")
                    .font(.title.weight(.semibold))
            }
            .widgetAccentable()
            .accessibilityLabel("Новая трата")
        case .accessoryRectangular:
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .widgetAccentable()
                VStack(alignment: .leading) {
                    Text("Трата")
                        .font(.headline)
                    Text("Записать")
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        case .accessoryInline:
            Label("Новая трата", systemImage: "plus.circle")
        default:
            VStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.tint)
                Text("Новая трата")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .fontDesign(.rounded)
        }
    }
}

struct AddExpenseWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "financist.add", provider: AddExpenseProvider()) { _ in
            AddExpenseWidgetView()
        }
        .configurationDisplayName("Новая трата")
        .description("Одно касание — и можно вводить трату.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline, .systemSmall])
    }
}

// MARK: - Кнопка на экране блокировки (вместо фонарика) и в Пункте управления, iOS 18+

@available(iOS 18.0, *)
struct AddExpenseControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "financist.add.control") {
            ControlWidgetButton(action: OpenAddExpenseIntent()) {
                Label("Новая трата", systemImage: "plus.circle.fill")
            }
        }
        .displayName("Новая трата")
        .description("Сразу открывает ввод траты.")
    }
}

@main
struct FinancistWidgets: WidgetBundle {
    var body: some Widget {
        AddExpenseWidget()
        if #available(iOS 18.0, *) {
            AddExpenseControl()
        }
    }
}
