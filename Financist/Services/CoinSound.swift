import AudioToolbox
import Foundation

/// Тот же звон монеток, что у напоминаний, — чтобы услышать его сразу, когда включаете напоминание.
/// Системный звук: тихий режим и громкость iPhone он уважает.
enum CoinSound {
    private static let id: SystemSoundID? = {
        guard let url = Bundle.main.url(forResource: "coins", withExtension: "wav") else { return nil }
        var id: SystemSoundID = 0
        return AudioServicesCreateSystemSoundID(url as CFURL, &id) == kAudioServicesNoError ? id : nil
    }()

    static func play() {
        if let id { AudioServicesPlaySystemSound(id) }
    }
}
