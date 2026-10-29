import SwiftUI

/// Пиксельная картинка во всю ширину вверху «Трат» — прямо под строкой состояния и Dynamic Island.
/// Место — страны, где тратили в последний раз (у каждой страны свои места, они меняются по дням),
/// небо, солнце, луна и звёзды — по часам телефона, флаг — нарисованный вручную флаг этой страны.
/// Внизу картинка плавно уходит в фон экрана. Если включено «Уменьшение движения», картинка не шевелится.
struct CityBackdrop: View {
    let place: Place?
    @Environment(\.colorScheme) private var scheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.palette) private var palette

    var body: some View {
        let flag = place.flatMap { PixelCity.flagPixels($0.code) }
        let seed = PixelCity.seed(for: place?.code)
        TimelineView(.animation(minimumInterval: 0.25, paused: reduceMotion)) { context in
            let date = context.date
            let pixels = PixelCity.render(scene: PixelCity.scene(for: place?.code, day: PixelCity.day(date)),
                                          part: DayPart(date), sun: DayPart.sunProgress(date), flag: flag,
                                          time: date.timeIntervalSince(Calendar.current.startOfDay(for: date)), seed: seed)
            if let image = Self.image(pixels) {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(CGFloat(PixelCity.cols) / CGFloat(PixelCity.rows), contentMode: .fit)
            }
        }
        // В тёмной теме картинка приглушена, а под строкой состояния — лёгкая дымка цвета фона,
        // чтобы часы и батарея читались на любом небе.
        .overlay { if scheme == .dark { Color.black.opacity(0.28) } }
        .overlay(alignment: .top) {
            LinearGradient(colors: [palette.background.opacity(0.55), .clear], startPoint: .top, endPoint: .bottom)
                .frame(height: 100)
        }
        .mask {
            LinearGradient(stops: [.init(color: .black, location: 0.74), .init(color: .clear, location: 1)],
                           startPoint: .top, endPoint: .bottom)
        }
        .accessibilityHidden(true)
    }

    private static func image(_ pixels: [UInt32]) -> CGImage? {
        var bytes = [UInt8](repeating: 255, count: pixels.count * 4)
        for (i, v) in pixels.enumerated() {
            bytes[i * 4] = UInt8((v >> 16) & 0xFF)
            bytes[i * 4 + 1] = UInt8((v >> 8) & 0xFF)
            bytes[i * 4 + 2] = UInt8(v & 0xFF)
        }
        guard let provider = CGDataProvider(data: Data(bytes) as CFData),
              let space = CGColorSpace(name: CGColorSpace.sRGB)
        else { return nil }
        return CGImage(width: PixelCity.cols, height: PixelCity.rows, bitsPerComponent: 8, bitsPerPixel: 32,
                       bytesPerRow: PixelCity.cols * 4, space: space,
                       bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue),
                       provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)
    }
}

/// Приветствие на небе: «Добрый день», день недели и страна с курсом местной валюты.
/// На светлом небе текст тёмный, на тёмном — белый.
struct CityGreeting: View {
    @Environment(AppStore.self) private var store
    @Environment(\.colorScheme) private var scheme
    let place: Place?

    var body: some View {
        TimelineView(.everyMinute) { context in
            let now = context.date
            let part = DayPart(now)
            let onLightSky = (part == .day || part == .dawn) && scheme == .light
            VStack(alignment: .leading, spacing: 3) {
                Text(RuDate.greeting(now))
                    .font(.title.weight(.bold))
                Text(RuDate.weekdayAndDay(now))
                    .font(.subheadline.weight(.medium))
                if let line = placeLine {
                    Text(line)
                        .font(.subheadline.weight(.semibold))
                        .monospacedDigit()
                }
            }
            .foregroundStyle(onLightSky ? Color(red: 0.11, green: 0.2, blue: 0.31) : Color.white)
            .shadow(color: onLightSky ? .white.opacity(0.6) : .black.opacity(0.45), radius: 2, y: 1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .combine)
        }
    }

    /// «Турция · 1 $ = 49,8 ₺»; для долларовых стран — только название.
    private var placeLine: String? {
        guard let place else { return nil }
        guard let currency = place.currency, currency != .usd else { return place.country }
        return "\(place.country) · 1 $ = \(Fmt.rate(store.vault.rates.rate(currency))) \(currency.symbol)"
    }
}
