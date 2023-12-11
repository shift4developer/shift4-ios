import Foundation

final class Keychain {
    static var lastEmail: String? {
        get { UserDefaults.standard.string(forKey: "____SHIFT4_SDK_LAST_EMAIL") }
        set { UserDefaults.standard.set(newValue, forKey: "____SHIFT4_SDK_LAST_EMAIL") }
    }

    static func cleanSavedEmails() {
        Keychain.lastEmail = nil
    }
}
