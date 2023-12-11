import Foundation

extension String {
    static func localized(_ key: String, value: String? = nil) -> String {
        Bundle.shift4.localizedString(forKey: key, value: value, table: nil)
    }
}
