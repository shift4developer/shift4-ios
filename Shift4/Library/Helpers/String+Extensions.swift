import Foundation
import UIKit

public extension String {
    static var empty: String { "" }

    func sanitized() -> String {
        replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: CharacterSet(charactersIn: "0123456789•").inverted)
    }

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        Data(utf8).base64EncodedString()
    }
}

public extension String? {
    var orEmpty: String {
        self ?? .empty
    }

    var isNilOrEmpty: Bool {
        self == nil || self == .empty
    }

    var isNotNilAndNotEmpty: Bool {
        guard let self else { return false }
        return !self.isEmpty
    }
}
