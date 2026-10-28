# Copies the app's storage and model sources into this test package, replacing Apple-only parts
# (Keychain, UIKit, SwiftUI, CryptoKit) with the controllable stand-ins in Shims.swift and TestCrypto.swift.
import re, pathlib
APP = pathlib.Path(__file__).resolve().parent.parent / 'Financist'
OUT = pathlib.Path(__file__).parent / 'Sources/FinancistCore'

def copy(rel, transform=lambda s: s):
    s = (APP / rel).read_text()
    (OUT / pathlib.Path(rel).name).write_text(transform(s))

def no_ui(s):
    s = s.replace('import UIKit\n', '')
    if 'import Foundation\n' in s:
        return s.replace('import SwiftUI\n', '')
    return s.replace('import SwiftUI\n', 'import Foundation\n')

copy('Models/Currency.swift')
copy('Models/Expense.swift')
copy('Models/VaultMerge.swift')
copy('Models/Formatting.swift')
copy('Models/Suggestions.swift')
copy('Models/ExpenseCategory.swift', no_ui)
copy('Services/BuildAge.swift')

def store(s):
    s = s.replace('import CommonCrypto\n', '').replace('import Security\n', '')
    s = s.replace('import CryptoKit\n', '')
    # The real Keychain is replaced by a controllable fake in Shims.swift.
    start = s.index('/// Ключ шифрования (AES-256) хранится')
    end = s.index('/// Хранилище на диске.')
    s = s[:start] + s[end:]
    # Each test uses its own folder.
    s = re.sub(r'static let directory = FileManager\.default\.urls\(for: \.applicationSupportDirectory, in: \.userDomainMask\)\[0\]\n\s*\.appendingPathComponent\("Financist", isDirectory: true\)',
               'static var directory: URL { TestEnvironment.directory }', s)
    assert 'TestEnvironment.directory' in s
    return s
copy('Storage/EncryptedStore.swift', store)
copy('Storage/AppStore.swift', no_ui)
print('synced')
