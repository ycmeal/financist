// Linux stand-ins for Apple-only APIs used by the storage code. Each one can be steered by tests
// to simulate a locked phone, a flaky Keychain, a lost key, and so on.
import Foundation

// MARK: - Test environment

public enum TestEnvironment {
    public nonisolated(unsafe) static var directory = FileManager.default.temporaryDirectory
        .appendingPathComponent("financist-tests", isDirectory: true)
}

// MARK: - Keychain

public typealias OSStatus = Int32
public let errSecSuccess: OSStatus = 0
public let errSecItemNotFound: OSStatus = -25300
public let errSecDuplicateItem: OSStatus = -25299
public let errSecInteractionNotAllowed: OSStatus = -25308

public enum KeyStore {
    public enum Mode {
        case normal
        /// iPhone locked: every access fails with errSecInteractionNotAllowed.
        case locked
        /// Keychain answers with an arbitrary error.
        case failing(OSStatus)
        /// The key exists but the Keychain wrongly says "not found" (known iOS prewarm bug class).
        case transientNotFound
    }

    public nonisolated(unsafe) static var stored: Data?
    public nonisolated(unsafe) static var mode: Mode = .normal
    public nonisolated(unsafe) static var createdKeys = 0

    static func existing() throws -> SymmetricKey? {
        switch mode {
        case .locked: throw VaultError.keychain(errSecInteractionNotAllowed)
        case .failing(let status): throw VaultError.keychain(status)
        case .transientNotFound: return nil
        case .normal: return stored.map { SymmetricKey(data: $0) }
        }
    }

    static func create() throws -> SymmetricKey {
        switch mode {
        case .locked: throw VaultError.keychain(errSecInteractionNotAllowed)
        case .failing(let status): throw VaultError.keychain(status)
        case .normal, .transientNotFound:
            // Like SecItemAdd: an existing item means "duplicate", nothing is overwritten.
            if stored != nil { throw VaultError.keychain(errSecDuplicateItem) }
        }
        let key = SymmetricKey(size: .bits256)
        stored = key.withUnsafeBytes { Data($0) }
        createdKeys += 1
        return key
    }

    static func delete() {
        stored = nil
    }
}

// MARK: - Security / CommonCrypto stand-ins used by BackupCrypto

public let kSecRandomDefault: OpaquePointer? = nil

public func SecRandomCopyBytes(_ rnd: OpaquePointer?, _ count: Int, _ bytes: UnsafeMutableRawPointer) -> Int32 {
    for i in 0..<count { bytes.storeBytes(of: UInt8.random(in: 0...255), toByteOffset: i, as: UInt8.self) }
    return errSecSuccess
}

public typealias CCPBKDFAlgorithm = UInt32
public typealias CCPseudoRandomAlgorithm = UInt32
public let kCCPBKDF2 = 2
public let kCCPRFHmacAlgSHA256 = 3
public let kCCSuccess = 0

/// PBKDF2-HMAC-SHA256 with the CommonCrypto signature.
public func CCKeyDerivationPBKDF(_ algorithm: CCPBKDFAlgorithm,
                                 _ password: UnsafePointer<Int8>?, _ passwordLen: Int,
                                 _ salt: UnsafePointer<UInt8>?, _ saltLen: Int,
                                 _ prf: CCPseudoRandomAlgorithm, _ rounds: UInt32,
                                 _ derivedKey: UnsafeMutablePointer<UInt8>?, _ derivedKeyLen: Int) -> Int32 {
    let pw = password.map { Data(bytes: $0, count: passwordLen) } ?? Data()
    let saltData = salt.map { Data(bytes: $0, count: saltLen) } ?? Data()
    var output = Data()
    var block: UInt32 = 1
    while output.count < derivedKeyLen {
        var be = block.bigEndian
        var u = TestCrypto.hmac(key: pw, data: saltData + Data(bytes: &be, count: 4))
        var t = u
        if rounds > 1 {
            for _ in 1..<rounds {
                u = TestCrypto.hmac(key: pw, data: u)
                for i in 0..<t.count { t[i] ^= u[i] }
            }
        }
        output += t
        block += 1
    }
    output.prefix(derivedKeyLen).withUnsafeBytes { raw in
        derivedKey?.update(from: raw.bindMemory(to: UInt8.self).baseAddress!, count: derivedKeyLen)
    }
    return Int32(kCCSuccess)
}

// MARK: - UIKit

public final class UIApplication {
    public nonisolated(unsafe) static let shared = UIApplication()
    public var isProtectedDataAvailable = true
}

// MARK: - SwiftUI

public struct Color: Hashable {
    let name: String
    static let green = Color(name: "green"), mint = Color(name: "mint"), teal = Color(name: "teal")
    static let cyan = Color(name: "cyan"), blue = Color(name: "blue"), indigo = Color(name: "indigo")
    static let purple = Color(name: "purple"), pink = Color(name: "pink"), red = Color(name: "red")
    static let orange = Color(name: "orange"), yellow = Color(name: "yellow"), brown = Color(name: "brown")
    static let gray = Color(name: "gray")
}

/// Same cases and raw values as the app's Palette (colors are UI-only).
enum Palette: String, Codable, CaseIterable, Identifiable {
    case sage, terracotta, honey, plum, sea, classic
    var id: Self { self }
}

extension Array {
    /// SwiftUI's `move(fromOffsets:toOffset:)`.
    mutating func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        let moving = source.map { self[$0] }
        var result: [Element] = []
        var insertAt = destination
        for (index, element) in enumerated() {
            if index == destination { result.append(contentsOf: moving) }
            if !source.contains(index) { result.append(element) } else if index < destination { insertAt -= 1 }
        }
        if destination >= count { result.append(contentsOf: moving) }
        _ = insertAt
        self = result
    }
}

// MARK: - Services not under test

enum Reminders {
    static let addAction = "add"
    nonisolated(unsafe) static var eveningSchedules = 0
    static func scheduleEvening(_ enabled: Bool, minutes: Int, hasExpensesToday: Bool) { eveningSchedules += 1 }
    static func scheduleRecurring(_ payments: [RecurringPayment]) {}
    static func requestPermission() async -> Bool { true }
}

@MainActor
enum AddRequest {
    static var pending = false
}

/// Controllable rates source: latest rates, rates by day, and an on/off switch for the network.
enum RatesService {
    struct DayRates {
        let day: String
        let rates: [Currency: Decimal]
    }

    nonisolated(unsafe) static var online = true
    nonisolated(unsafe) static var latest: DayRates?
    nonisolated(unsafe) static var byDay: [String: [Currency: Decimal]] = [:]
    nonisolated(unsafe) static var requestedDays: [String] = []

    static func reset() {
        online = true
        latest = nil
        byDay = [:]
        requestedDays = []
    }

    static func fetchLatest() async throws -> DayRates {
        guard online, let latest else { throw URLError(.notConnectedToInternet) }
        return latest
    }

    static func fetch(day: String) async throws -> DayRates {
        requestedDays.append(day)
        guard online, let rates = byDay[day] else { throw URLError(.resourceUnavailable) }
        return DayRates(day: day, rates: rates)
    }
}

extension URL {
    func startAccessingSecurityScopedResource() -> Bool { false }
    func stopAccessingSecurityScopedResource() {}
}
