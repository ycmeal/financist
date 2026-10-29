import Foundation

/// Пиксельные места для шапки «Трат», 96×84 точки. Небо — по времени суток (рассвет, день, закат, ночь):
/// днём солнце идёт по дуге, ночью луна и звёзды; облака плывут, вода блестит, лодки плывут, флаг развевается.
/// У каждой страны свои места — Стамбул, Каппадокия, Самарканд, Хива, Москва… — с каждым входом следующее.
/// Сами рисунки — в PixelData.swift (собираются скриптом из tools/pixel-art вместе с кликабельным макетом),
/// здесь — как их рисовать. Тот же алгоритм — в макете: правки делать в обоих местах, тесты сверяют кадры.
enum PixelCity {
    static let cols = 96
    static let rows = 84
    static let flagWidth = 15
    static let flagHeight = 10

    // MARK: Что лежит в PixelData.swift

    /// Цвет днём и как материал ведёт себя после заката.
    struct Material {
        enum Kind { case solid, window, lamp, glow }
        let color: UInt32
        let kind: Kind

        init(_ color: UInt32, _ kind: Kind = .solid) {
            self.color = color
            self.kind = kind
        }
    }

    /// Шаг рисования места. depth: 0 — ближе всего, 4 — у горизонта, в дымке.
    enum Op {
        /// flags: 1 — отразить по горизонтали, 2 — ночью подсвечено прожекторами.
        case sprite(String, x: Int, bottom: Int, depth: Int, flags: Int)
        case water(top: Int, bottom: Int, from: Int = 0, to: Int = 96, lagoon: Bool = false)
        /// Плывёт через кадр и возвращается с другой стороны; speed < 0 — влево. Несколько имён — шаги.
        /// dayOnly — ночью не видно (парапланы).
        case boat([String], bottom: Int, speed: Double, offset: Double, depth: Int, fps: Double = 0, dayOnly: Bool = false)
        case anim([String], x: Int, bottom: Int, depth: Int, fps: Double)
        /// Воздушный шар: медленно вверх-вниз; ночью не летает.
        case bob(String, x: Int, bottom: Int, depth: Int, amp: Int, period: Double)
        /// Эйфелева башня мерцает первые пять минут каждого часа после заката.
        case sparkle(String, x: Int, bottom: Int)
        case birds(row: Int, count: Int, speed: Double)
        case flag(x: Int, top: Int, bottom: Int, depth: Int)
    }

    struct Scene {
        /// Где кончается небо.
        let horizon: Int
        /// Ряды облаков.
        let clouds: [Int]
        let ops: [Op]
    }

    struct Flag {
        let colors: [Character: UInt32]
        let rows: String
    }

    // MARK: Страна → место и флаг

    /// Место страны для этого входа в приложение: места идут по очереди, с каждым входом — следующее.
    static func scene(for code: String?, visit: Int) -> String {
        let list = places[code ?? ""] ?? places[""] ?? ["city"]
        return list[(visit % list.count + list.count) % list.count]
    }

    /// Свой постоянный рисунок окон и звёзд у каждой страны.
    static func seed(for code: String?) -> Int {
        (code ?? "XX").unicodeScalars.reduce(7) { $0 &* 31 &+ Int($1.value) }
    }

    /// Флаг страны: flagWidth × flagHeight цветов построчно.
    static func flagPixels(_ code: String) -> [UInt32]? {
        guard let flag = flags[code] else { return nil }
        var pixels: [UInt32] = []
        for ch in flag.rows where ch != "\n" {
            guard let color = flag.colors[ch] else { return nil }
            pixels.append(color)
        }
        return pixels.count == flagWidth * flagHeight ? pixels : nil
    }

    // MARK: Кадр

    /// Кадр: цвета 0xRRGGBB построчно сверху вниз. `sun` — 0…1 по дуге или nil (тогда луна),
    /// `time` — секунды от полуночи (облака, вода, флаг, звёзды).
    static func render(scene id: String, part: DayPart, sun: Double?, flag: [UInt32]?, time: Double, seed: Int) -> [UInt32] {
        var frame = Frame(light: Light.of(part), part: part, time: time, seed: seed)
        frame.draw(scenes[id] ?? scenes["city"], sun: sun, flag: flag)
        return frame.px
    }

    /// Стабильное «случайное» число для клетки — как в макете (32-битная арифметика).
    static func hash(_ x: Int, _ y: Int, _ s: Int) -> UInt32 {
        var h = Int32(truncatingIfNeeded: x) &* 374_761_393
            &+ Int32(truncatingIfNeeded: y) &* 668_265_263
            &+ Int32(truncatingIfNeeded: s) &* 2_147_483_647
        h = (h ^ Int32(bitPattern: UInt32(bitPattern: h) >> 13)) &* 1_274_126_177
        return UInt32(bitPattern: h ^ Int32(bitPattern: UInt32(bitPattern: h) >> 16))
    }

    /// a → b на долю k. Округление — как Math.round в макете.
    static func mix(_ a: UInt32, _ b: UInt32, _ k: Double) -> UInt32 {
        func channel(_ shift: UInt32) -> Double {
            let ca = Int(a >> shift & 255), cb = Int(b >> shift & 255)
            return Double(ca) + Double(cb - ca) * k
        }
        return pack(channel(16), channel(8), channel(0))
    }

    static func multiply(_ c: UInt32, _ m: [Double]) -> UInt32 {
        pack(min(255, Double(c >> 16 & 255) * m[0]), min(255, Double(c >> 8 & 255) * m[1]), min(255, Double(c & 255) * m[2]))
    }

    private static func pack(_ r: Double, _ g: Double, _ b: Double) -> UInt32 {
        UInt32((r + 0.5).rounded(.down)) << 16 | UInt32((g + 0.5).rounded(.down)) << 8 | UInt32((b + 0.5).rounded(.down))
    }

    // MARK: Разобранные рисунки

    struct Sprite {
        let width: Int
        let height: Int
        /// ASCII-символы построчно; «.» — пусто.
        let cells: [UInt8]

        init(_ text: String) {
            let lines = text.split(separator: "\n").map { Array($0.utf8) }
            width = lines.first?.count ?? 0
            height = lines.count
            cells = lines.flatMap { $0 }
        }

        subscript(x: Int, y: Int) -> UInt8 { cells[y * width + x] }
    }

    static let parsedSprites: [String: Sprite] = sprites.mapValues(Sprite.init)
    private static let parsedClouds: [Sprite] = clouds.map(Sprite.init)
    /// Материал по ASCII-коду символа.
    private static let materialTable: [Material?] = (0..<128).map { code in
        materials[Character(Unicode.Scalar(UInt8(code)))]
    }
    private static let dot = UInt8(ascii: ".")

    /// Свет времени суток: фигуры умножаются на `tint`, дальние тонут в дымке `haze`.
    struct Light {
        let sky: [UInt32]
        let tint, flood, flagTint: [Double]
        let haze: UInt32
        let hazeK: Double
        let sun, sunHi, glow, moon, moonShade, star, starDim: UInt32
        let cloud: [UInt32]
        let water, lagoon: [UInt32]
        let foam, glint: UInt32
        /// Сколько окон из ста горит.
        let windows: Int
        let lamp, lamp2, bird: UInt32

        static func of(_ part: DayPart) -> Light {
            switch part {
            case .day: day
            case .dawn: dawn
            case .dusk: dusk
            case .night: night
            }
        }

        static let day = Light(
            sky: [0x4FA3E3, 0x63AEE8, 0x79BAEC, 0x8FC6F0, 0xA6D2F3, 0xBEDEF5],
            tint: [1, 1, 1], flood: [1, 1, 1], flagTint: [1, 1, 1], haze: 0xBEDEF5, hazeK: 0.6,
            sun: 0xFFE27A, sunHi: 0xFFF8D6, glow: 0, moon: 0xF4F1DE, moonShade: 0xC9C5A8, star: 0xFFFFFF, starDim: 0xBEDEF5,
            cloud: [0xFFFFFF, 0xF1F7FB, 0xD2E3EF],
            water: [0x8CC6E8, 0x5DA2D2, 0x4686BE], lagoon: [0x8FE0E0, 0x4CC3D2, 0x2E9FBF], foam: 0xDDF0FA, glint: 0xFFF7D8,
            windows: 0, lamp: 0xFFD877, lamp2: 0xFFE9A6, bird: 0x3E4A5C)

        static let dawn = Light(
            sky: [0x5767B4, 0x7676C0, 0x9C86C6, 0xC898C0, 0xEDAFAA, 0xFFCC9E],
            tint: [0.96, 0.84, 0.88], flood: [0.96, 0.84, 0.88], flagTint: [0.98, 0.9, 0.92], haze: 0xF2BBA8, hazeK: 0.55,
            sun: 0xFFB869, sunHi: 0xFFE3B0, glow: 0xFFD8A8, moon: 0xF4F1DE, moonShade: 0xC9C5A8, star: 0xFFFFFF, starDim: 0xC9C6EC,
            cloud: [0xFFEDE6, 0xFFD6CF, 0xE6AFB6],
            water: [0xEDB2A8, 0x9D8CC0, 0x7471AE], lagoon: [0xF0BDB0, 0x93A9C8, 0x6C86B4], foam: 0xFFE1D0, glint: 0xFFE2A8,
            windows: 30, lamp: 0xFFD877, lamp2: 0xFFE9A6, bird: 0x4B4766)

        static let dusk = Light(
            sky: [0x2A2766, 0x45307C, 0x713C8A, 0xA84B82, 0xDA6670, 0xFF9662],
            tint: [0.8, 0.6, 0.7], flood: [0.8, 0.6, 0.7], flagTint: [0.92, 0.8, 0.84], haze: 0xE07872, hazeK: 0.5,
            sun: 0xFF7A3D, sunHi: 0xFFC07A, glow: 0xFFAE6E, moon: 0xF4F1DE, moonShade: 0xC9C5A8, star: 0xFFFFFF, starDim: 0xB9A6D6,
            cloud: [0xFFB59A, 0xF08E8A, 0xB0607E],
            water: [0xE8806E, 0x8A4E84, 0x4F3A74], lagoon: [0xE9907A, 0x7E6596, 0x4B4A7E], foam: 0xFFB384, glint: 0xFFC27E,
            windows: 50, lamp: 0xFFD06A, lamp2: 0xFFE39A, bird: 0x3A2C4E)

        static let night = Light(
            sky: [0x050920, 0x09102C, 0x0E1739, 0x141F47, 0x1A2856, 0x223266],
            tint: [0.22, 0.26, 0.42], flood: [0.62, 0.52, 0.4], flagTint: [0.72, 0.7, 0.72], haze: 0x223266, hazeK: 0.45,
            sun: 0xFFE27A, sunHi: 0xFFF8D6, glow: 0, moon: 0xF5F2DC, moonShade: 0xC8C4A6, star: 0xFFFFFF, starDim: 0x8FA2DA,
            cloud: [0x2E3B6E, 0x253260, 0x1C2850],
            water: [0x1D2B5A, 0x152149, 0x0F1838], lagoon: [0x1B3460, 0x15294F, 0x0F1E3E], foam: 0x33467E, glint: 0xCFD3B8,
            windows: 45, lamp: 0xFFD46A, lamp2: 0xFFE6A0, bird: 0)
    }

    /// Флаг на ветру: столбцы смещаются по `wave`, складки светлее или темнее.
    private static let wave = [0, 1, 1, 1, 0, 0, -1, -1, -1, 0]
    private static let folds = [1.12, 1, 1, 0.86, 1, 0.86, 1, 1, 1.12, 1]

    /// Один кадр в работе.
    private struct Frame {
        let light: Light
        let part: DayPart
        let time: Double
        let seed: Int
        var px = [UInt32](repeating: 0, count: PixelCity.cols * PixelCity.rows)
        private var cache: [Int: UInt32] = [:]
        private var horizon = 1

        init(light: Light, part: DayPart, time: Double, seed: Int) {
            self.light = light
            self.part = part
            self.time = time
            self.seed = seed
        }

        private var dark: Bool { part == .dusk || part == .night }

        mutating func set(_ x: Int, _ y: Int, _ v: UInt32) {
            if x >= 0, x < PixelCity.cols, y >= 0, y < PixelCity.rows { px[y * PixelCity.cols + x] = v }
        }

        /// Небо: шесть полос до горизонта, на стыках — «шахматка».
        func sky(_ x: Int, _ y: Int) -> UInt32 {
            let h = horizon
            if y >= h { return light.sky[5] }
            let band = y * 6 / h
            let first = (band * h + 5) / 6
            if band > 0, y == first, (x + y) % 2 == 0 { return light.sky[band - 1] }
            if band > 0, y == first + 1, x % 4 == (y % 2) * 2 { return light.sky[band - 1] }
            return light.sky[band]
        }

        mutating func disk(_ cx: Double, _ cy: Double, _ r: Double, _ paint: (inout Frame, Int, Int, Double, Double, Double) -> Void) {
            for y in Int((cy - r - 1).rounded(.down))...Int((cy + r + 1).rounded(.up)) {
                for x in Int((cx - r - 1).rounded(.down))...Int((cx + r + 1).rounded(.up)) {
                    let dx = Double(x) + 0.5 - cx, dy = Double(y) + 0.5 - cy, d2 = dx * dx + dy * dy
                    if d2 <= r * r { paint(&self, x, y, dx, dy, d2) }
                }
            }
        }

        /// Цвет материала в этом свете: окна вечером горят, фонари светят.
        mutating func color(_ ch: UInt8, _ depth: Int, _ lit: Bool, _ x: Int, _ y: Int) -> UInt32 {
            guard let m = PixelCity.materialTable[Int(ch & 127)] else { return 0 }
            if m.kind == .window, part != .day, Int(PixelCity.hash(x, y, seed + 7) % 100) < light.windows {
                return PixelCity.hash(x, y, seed + 11) % 4 == 0 ? light.lamp2 : light.lamp
            }
            if m.kind == .lamp, dark { return light.lamp }
            if m.kind == .glow, dark { return m.color }
            let key = Int(ch) << 4 | depth << 1 | (lit ? 1 : 0)
            if let c = cache[key] { return c }
            let c = PixelCity.mix(PixelCity.multiply(m.color, lit ? light.flood : light.tint), light.haze,
                                  Double(depth) * light.hazeK / 4)
            cache[key] = c
            return c
        }

        mutating func sprite(_ s: Sprite, _ x0: Int, _ bottom: Int, _ depth: Int, _ flags: Int) {
            let flip = flags & 1 != 0, lit = flags & 2 != 0
            for dy in 0..<s.height {
                let y = bottom - s.height + dy
                guard y >= 0, y < PixelCity.rows else { continue }
                for dx in 0..<s.width {
                    let ch = s[flip ? s.width - 1 - dx : dx, dy]
                    let x = x0 + dx
                    if ch != PixelCity.dot, x >= 0, x < PixelCity.cols { set(x, y, color(ch, depth, lit, x, y)) }
                }
            }
        }

        func frame(_ names: [String], _ fps: Double) -> Sprite? {
            guard !names.isEmpty else { return nil }
            let i = names.count == 1 ? 0 : Int((time * fps).rounded(.down)) % names.count
            return PixelCity.parsedSprites[names[i]]
        }

        mutating func draw(_ scene: Scene?, sun: Double?, flag: [UInt32]?) {
            guard let scene else { return }
            let t = time, cols = PixelCity.cols, dot = PixelCity.dot
            horizon = max(1, scene.horizon)
            for y in 0..<PixelCity.rows { for x in 0..<cols { px[y * cols + x] = sky(x, y) } }

            // Звёзды — ниже строки состояния.
            if sun == nil {
                let twinkle = Int((t * 1.5).rounded(.down))
                for y in stride(from: 13, to: horizon - 3, by: 1) {
                    for x in 0..<cols {
                        let h = PixelCity.hash(x, y, seed)
                        if h % 61 == 0 {
                            set(x, y, (Int(h >> 8) + twinkle) % 4 == 0 ? light.starDim : light.star)
                        } else if h % 151 == 3 {
                            set(x, y, light.starDim)
                        }
                    }
                }
            }

            // Солнце на дуге справа от приветствия или месяц.
            let glintX: Double
            if let sun {
                let cx = 52 + 40 * sun, cy = 50 - 80 * sun * (1 - sun)
                let r = part == .day ? 3.5 : 4.5
                let glow = light.glow, core = light.sun, highlight = light.sunHi
                if glow != 0 {
                    disk(cx, cy, r + 3) { f, x, y, _, _, d2 in
                        if d2 <= (r + 1.5) * (r + 1.5) || (x + y) % 2 == 0 { f.set(x, y, glow) }
                    }
                }
                disk(cx, cy, r) { f, x, y, dx, dy, _ in f.set(x, y, dx + dy < -r * 0.6 ? highlight : core) }
                glintX = cx
            } else {
                let cx = 50.0, cy = 19.0, r = 3.5
                let moon = light.moon, shade = light.moonShade
                disk(cx, cy, r) { f, x, y, dx, _, _ in f.set(x, y, dx > r * 0.35 ? shade : moon) }
                disk(cx - 1.6, cy - 1.2, r * 0.93) { f, x, y, _, _, _ in f.set(x, y, f.sky(x, y)) }
                glintX = cx
            }

            // Облака медленно плывут вправо.
            for (i, row) in scene.clouds.enumerated() {
                let shape = PixelCity.parsedClouds[i % PixelCity.parsedClouds.count], w = shape.width, span = cols + w
                let start = Double(PixelCity.hash(i, 3, seed) % UInt32(span)) + t / (2.5 + Double(i))
                let x0 = Int(start.truncatingRemainder(dividingBy: Double(span)).rounded(.down)) - w
                for dy in 0..<shape.height {
                    for dx in 0..<w {
                        switch shape[dx, dy] {
                        case UInt8(ascii: "h"): set(x0 + dx, row + dy, light.cloud[0])
                        case UInt8(ascii: "x"): set(x0 + dx, row + dy, light.cloud[1])
                        case UInt8(ascii: "s"): set(x0 + dx, row + dy, light.cloud[2])
                        default: break
                        }
                    }
                }
            }

            for op in scene.ops {
                switch op {
                case let .sprite(name, x, bottom, depth, flags):
                    if let s = PixelCity.parsedSprites[name] { sprite(s, x, bottom, depth, flags) }

                case let .water(y0, y1, x0, x1, lagoon):
                    water(y0, y1, x0, x1, lagoon ? light.lagoon : light.water, glintX)

                case let .boat(names, bottom, speed, offset, depth, fps, dayOnly):
                    guard !(dayOnly && part == .night), let s = frame(names, fps) else { break }
                    let span = cols + s.width
                    let p = Int((offset + t * abs(speed)).truncatingRemainder(dividingBy: Double(span)).rounded(.down))
                    sprite(s, speed > 0 ? p - s.width : cols - p, bottom, depth, speed > 0 ? 0 : 1)

                case let .anim(names, x, bottom, depth, fps):
                    if let s = frame(names, fps) { sprite(s, x, bottom, depth, 0) }

                case let .bob(name, x, bottom, depth, amp, period):
                    guard part != .night, amp > 0, let s = PixelCity.parsedSprites[name] else { break }
                    let phase = Int((t / period).rounded(.down)) % (amp * 2)
                    sprite(s, x, bottom - (phase < amp ? phase : amp * 2 - phase), depth, 0)

                case let .sparkle(name, x0, bottom):
                    guard part == .night, Int((t / 60).rounded(.down)) % 60 < 5, let s = PixelCity.parsedSprites[name] else { break }
                    let step = Int((t * 4).rounded(.down))
                    for dy in 0..<s.height {
                        for dx in 0..<s.width where s[dx, dy] != dot {
                            let x = x0 + dx, y = bottom - s.height + dy
                            if PixelCity.hash(x, y, seed + step) % 9 == 0 { set(x, y, 0xFFFFFF) }
                        }
                    }

                case let .birds(row, count, speed):
                    let bird = light.bird
                    guard bird != 0 else { break }
                    let span = Double(cols + 40)
                    let flap = Int((t * 3).rounded(.down))
                    for i in 0..<count {
                        let start = Double(Int(PixelCity.hash(i, 5, seed) % 30) + i * 6) + t * speed
                        let x = Int(start.truncatingRemainder(dividingBy: span).rounded(.down)) - 20
                        let y = row + (i % 2) * 2 + Int(PixelCity.hash(i, 6, seed) % 3)
                        if (flap + i) % 2 == 0 {
                            set(x, y, bird); set(x + 1, y + 1, bird); set(x + 2, y, bird)
                        } else {
                            set(x, y + 1, bird); set(x + 1, y + 1, bird); set(x + 2, y + 1, bird)
                        }
                    }

                case let .flag(x, top, bottom, depth):
                    for y in stride(from: top, to: bottom, by: 1) { set(x, y, color(UInt8(ascii: "D"), depth, false, x, y)) }
                    set(x, top - 1, color(UInt8(ascii: "Y"), depth, false, x, top - 1))
                    guard let flag, flag.count == PixelCity.flagWidth * PixelCity.flagHeight else { break }
                    let phase = Int((t * 4).rounded(.down))
                    for fx in 0..<PixelCity.flagWidth {
                        let i = ((fx - phase) % 10 + 10) % 10
                        let shift = fx < 2 ? 0 : PixelCity.wave[i], fold = fx < 1 ? 1 : PixelCity.folds[i]
                        let tint = light.flagTint.map { $0 * fold }
                        for fy in 0..<PixelCity.flagHeight {
                            set(x + 1 + fx, top + fy + shift, PixelCity.multiply(flag[fy * PixelCity.flagWidth + fx], tint))
                        }
                    }
                }
            }
        }

        /// Вода: светлее у горизонта, бегут блики, под солнцем или луной — сверкающая дорожка.
        mutating func water(_ y0: Int, _ y1: Int, _ x0: Int, _ x1: Int, _ tone: [UInt32], _ glintX: Double) {
            let n = y1 - y0, t = time, cols = PixelCity.cols
            guard n > 0, x0 < x1 else { return }
            for y in y0..<y1 {
                let f = Double((y - y0) * 6) / Double(n)
                let band = f < 1 ? 0 : f < 3 ? 1 : 2
                let edge = (f >= 1 && f < 1.5) || (f >= 3 && f < 3.5)
                for x in x0..<x1 { set(x, y, tone[edge && (x + y) % 2 == 0 ? band - 1 : band]) }
            }
            for y in stride(from: y0 + 1, to: y1, by: 1) {
                let dir = y % 2 == 0 ? 1 : -1
                let speed = 0.4 + Double(y % 3) * 0.3
                let count = 2 + (y - y0) / 4
                for k in 0..<count {
                    let len = 2 + Int(PixelCity.hash(k, y, seed) % 3), span = cols + len
                    let p = Int((Double(PixelCity.hash(y, k, seed + 3) % UInt32(span)) + t * speed).rounded(.down)) % span
                    let start = dir > 0 ? p - len : cols - p
                    for i in 0..<len where start + i >= x0 && start + i < x1 { set(start + i, y, light.foam) }
                }
            }
            guard glintX >= Double(x0), glintX < Double(x1) else { return }
            let step = Int((t * 3).rounded(.down)), center = Int(glintX.rounded(.down))
            for y in stride(from: y0 + 1, to: y1, by: 1) {
                let half = 1 + (y - y0) / 6
                for x in (center - half)...(center + half)
                where (x * 3 + y + step) % 4 != 0 && PixelCity.hash(x, y + step, seed) % 3 != 0 {
                    set(x, y, light.glint)
                }
            }
        }
    }
}
