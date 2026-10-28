import Foundation

/// День для курсов: «2026-10-28».
enum RateDay {
    static func key(_ date: Date, utc: Bool = false) -> String {
        var calendar = Calendar(identifier: .gregorian)
        if utc { calendar.timeZone = TimeZone(identifier: "UTC")! }
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        func padded(_ value: Int?, _ width: Int) -> String {
            let text = String(value ?? 0)
            return String(repeating: "0", count: max(0, width - text.count)) + text
        }
        return "\(padded(c.year, 4))-\(padded(c.month, 2))-\(padded(c.day, 2))"
    }
}
