import SwiftUI

/// Шапка «Трат»: где отец сейчас и который там час, на фоне неба за окном.
/// Небо меняется со временем суток, днём солнце идёт по дуге, ночью — луна.
/// Страна — по часовому поясу iPhone, без геолокации и интернета. Внизу — курс местной валюты.
struct PlaceHeader: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        TimelineView(.everyMinute) { context in
            let now = context.date
            let zone = TimeZone.autoupdatingCurrent
            let place = Place.from(timeZone: zone)
            VStack(alignment: .leading, spacing: 6) {
                Text(place.map { "\($0.flag) \($0.country)" } ?? Place.city(of: zone))
                    .font(.headline)
                Text(RuDate.time(now))
                    .font(.largeTitle.weight(.semibold))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                Text("\(RuDate.weekdayAndDay(now)) · \(RuDate.greeting(now))")
                    .font(.subheadline)
                if let rate = localRate(place) {
                    Text(rate)
                        .font(.subheadline.weight(.semibold))
                        .monospacedDigit()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.22), in: .capsule)
                        .padding(.top, 4)
                }
            }
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.18), radius: 2, y: 1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background { Sky(part: DayPart(now), sun: DayPart.sunProgress(now)) }
            .clipShape(.rect(cornerRadius: 20))
            .accessibilityElement(children: .combine)
        }
    }

    /// «1 $ = 49,80 ₺» — если местная валюта есть в приложении и это не доллар.
    private func localRate(_ place: Place?) -> String? {
        guard let currency = place?.currency, currency != .usd else { return nil }
        return "1 $ = \(Fmt.rate(store.vault.rates.rate(currency))) \(currency.symbol)"
    }
}

/// Небо по времени суток. Днём солнце на дуге справа (чтобы не мешать тексту), ночью луна.
private struct Sky: View {
    let part: DayPart
    /// 0 — восход, 1 — закат; nil — солнца нет.
    let sun: Double?
    @ScaledMetric(relativeTo: .largeTitle) private var size: CGFloat = 40

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                if let sun {
                    // Дуга вверху справа, над строкой с датой: ниже утром и вечером, выше всего днём.
                    let x = geo.size.width * (0.62 + 0.30 * sun)
                    let y = geo.size.height * (0.46 - 0.30 * sin(.pi * sun))
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: size))
                        .foregroundStyle(Color(red: 1, green: 0.86, blue: 0.42))
                        .position(x: x, y: y)
                } else {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: size * 0.9))
                        .foregroundStyle(.white.opacity(0.9))
                        .position(x: geo.size.width * 0.84, y: geo.size.height * 0.3)
                }
            }
        }
        .accessibilityHidden(true)
    }

    private var colors: [Color] {
        switch part {
        case .morning: [Color(red: 0.78, green: 0.40, blue: 0.31), Color(red: 0.42, green: 0.55, blue: 0.84)]
        case .day: [Color(red: 0.18, green: 0.43, blue: 0.71), Color(red: 0.36, green: 0.61, blue: 0.86)]
        case .evening: [Color(red: 0.76, green: 0.38, blue: 0.24), Color(red: 0.42, green: 0.30, blue: 0.58)]
        case .night: [Color(red: 0.11, green: 0.14, blue: 0.31), Color(red: 0.23, green: 0.23, blue: 0.47)]
        }
    }
}
