import ImageIO
import SwiftUI
import UIKit
import Vision

/// Читает сумму и название магазина с фото чека. Распознавание текста — встроенный
/// в iOS Vision, работает прямо на iPhone. Фото нигде не сохраняется.
enum ReceiptScanner {
    struct Result {
        var amount: Decimal?
        var merchant: String?
    }

    static func scan(_ image: UIImage) async -> Result {
        guard let cgImage = image.cgImage else { return Result() }
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let request = VNRecognizeTextRequest()
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = false
                let wanted = ["tr-TR", "ru-RU", "en-US"]
                let supported = (try? request.supportedRecognitionLanguages()) ?? []
                request.recognitionLanguages = wanted.filter(supported.contains)
                let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation)
                try? handler.perform([request])
                let lines = (request.results ?? []).compactMap { $0.topCandidates(1).first?.string }
                continuation.resume(returning: parse(lines))
            }
        }
    }

    /// Слова, после которых на чеке стоит итоговая сумма.
    private static let totalWords = ["GENEL TOPLAM", "TOPLAM", "ODENECEK", "TOTAL", "ИТОГО", "ИТОГ",
                                     "К ОПЛАТЕ", "JAMI", "SUMMA", "TUTAR"]

    static func parse(_ lines: [String]) -> Result {
        let upper = lines.map { $0.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).uppercased() }
        var amount: Decimal?
        // Идём снизу вверх: итог обычно в конце чека. Строки с налогом (KDV, НДС) пропускаем.
        for index in upper.indices.reversed() where amount == nil {
            let line = upper[index]
            guard totalWords.contains(where: { line.contains($0) }), !line.contains("KDV"), !line.contains("НДС") else { continue }
            amount = numbers(in: lines[index]).last
                ?? (index + 1 < lines.count ? numbers(in: lines[index + 1]).last : nil)
        }
        if amount == nil {
            amount = lines.flatMap(numbers(in:)).max()
        }
        let merchant = lines.prefix(4).first { line in
            line.filter(\.isLetter).count >= 3 && line.filter(\.isNumber).count < 3
        }
        return Result(amount: amount, merchant: merchant?.trimmingCharacters(in: .whitespaces))
    }

    /// Суммы с копейками: «1.234,56», «1 234.56», «*450,00».
    static func numbers(in line: String) -> [Decimal] {
        let pattern = #"\d{1,3}(?:[ . ]\d{3})*[.,]\d{2}(?!\d)|\d+[.,]\d{2}(?!\d)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(line.startIndex..., in: line)
        return regex.matches(in: line, range: range).compactMap { match in
            guard let r = Range(match.range, in: line) else { return nil }
            var text = String(line[r]).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\u{00A0}", with: "")
            // Последний разделитель — копейки, остальные — тысячи.
            let decimalSeparator = text[text.index(text.endIndex, offsetBy: -3)]
            let thousands: Character = decimalSeparator == "," ? "." : ","
            text.removeAll { $0 == thousands }
            text = text.replacingOccurrences(of: ",", with: ".")
            return Decimal(string: text, locale: Locale(identifier: "en_US_POSIX"))
        }
    }
}

extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}

/// Камера (или галерея, если камеры нет, например в симуляторе).
struct CameraPicker: UIViewControllerRepresentable {
    let onImage: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onImage: onImage) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ controller: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onImage: (UIImage?) -> Void

        init(onImage: @escaping (UIImage?) -> Void) {
            self.onImage = onImage
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            onImage(info[.originalImage] as? UIImage)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onImage(nil)
        }
    }
}
