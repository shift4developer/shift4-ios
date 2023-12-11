import Foundation

internal struct Billing: Codable {
    let name: String
    let address: Address
    let vat: String?

    func toShipping() -> Shipping {
        Shipping(name: name, address: address)
    }
}

extension Billing: Equatable {
    static func == (lhs: Billing, rhs: Billing) -> Bool {
        lhs.name == rhs.name && lhs.address == rhs.address && lhs.vat == rhs.vat
    }
}
