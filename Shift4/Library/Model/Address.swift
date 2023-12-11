import Foundation

internal struct Address: Codable {
    let line1: String
    let zip: String
    let city: String
    let country: String
}

extension Address: Equatable {
    static func == (lhs: Address, rhs: Address) -> Bool {
        lhs.line1 == rhs.line1 && lhs.zip == rhs.zip && lhs.city == rhs.city && lhs.country == rhs.country
    }
}
