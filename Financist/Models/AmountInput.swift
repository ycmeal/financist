import Foundation

/// Сумма с большой цифровой клавиатуры: цифры, одна запятая, копеек не больше, чем у валюты.
struct AmountInput: Equatable {
    enum Key: Equatable {
        case digit(Int)
        case comma
        case delete
    }

    /// Как набрано: «1250,5».
    private(set) var text = ""

    /// Самая большая сумма — 999 999 999.
    static let maxIntegerDigits = 9

    init() {}

    /// Сумма прошлой траты — для повтора: «12,5».
    init(amount: Decimal, fractionDigits: Int) {
        text = amount.inputString
        fit(fractionDigits: fractionDigits)
    }

    var isEmpty: Bool { text.isEmpty }

    /// Введённая сумма; ноль и пустое поле — не сумма.
    var value: Decimal? {
        guard let value = Decimal.parse(text), value > 0 else { return nil }
        return value
    }

    mutating func press(_ key: Key, fractionDigits: Int) {
        switch key {
        case .digit(let digit):
            guard (0...9).contains(digit) else { return }
            if let comma = text.firstIndex(of: ",") {
                guard text.distance(from: comma, to: text.endIndex) - 1 < fractionDigits else { return }
                text += String(digit)
            } else if text == "0" {
                text = String(digit)
            } else if text.count < Self.maxIntegerDigits {
                text += String(digit)
            }
        case .comma:
            guard fractionDigits > 0, !text.contains(",") else { return }
            text = (text.isEmpty ? "0" : text) + ","
        case .delete:
            if !text.isEmpty { text.removeLast() }
        }
    }

    /// Другая валюта: лишние знаки после запятой убираются (у сума копеек нет).
    mutating func fit(fractionDigits: Int) {
        guard let comma = text.firstIndex(of: ",") else { return }
        if fractionDigits <= 0 {
            text = String(text[..<comma])
            return
        }
        let digits = text.distance(from: comma, to: text.endIndex) - 1
        if digits > fractionDigits {
            text = String(text[..<text.index(comma, offsetBy: fractionDigits + 1)])
        }
    }

    /// Для экрана: тысячи через узкий пробел, дробная часть — как набрана. Пустое поле — «0».
    var display: String {
        guard !text.isEmpty else { return "0" }
        let parts = text.split(separator: ",", omittingEmptySubsequences: false)
        let integer = parts[0].isEmpty ? "0" : String(parts[0])
        var grouped = ""
        for (i, ch) in integer.reversed().enumerated() {
            if i > 0 && i % 3 == 0 { grouped.append("\u{202F}") }
            grouped.append(ch)
        }
        grouped = String(grouped.reversed())
        return parts.count > 1 ? grouped + "," + parts[1] : grouped
    }
}
