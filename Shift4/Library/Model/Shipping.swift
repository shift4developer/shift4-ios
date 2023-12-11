import Foundation

internal struct Shipping: Codable {
    let name: String
    let address: Address
}

extension Shipping: Equatable {
    static func == (lhs: Shipping, rhs: Shipping) -> Bool {
        lhs.name == rhs.name && lhs.address == rhs.address
    }
}
