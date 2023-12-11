import Foundation

@objc(S4CardExpiration)
public class CardExpiration: NSObject, Codable {
    @objc public let month: String
    @objc public let year: String
}

@objc(S4Card)
public class Card: NSObject, Codable {
    @objc public let last2: String?
    @objc public let last4: String?
    @objc public let brand: String
    @objc public let expiration: CardExpiration?

    internal init(last2: String? = nil, last4: String? = nil, brand: String, expiration: CardExpiration? = nil) {
        self.last2 = last2
        self.last4 = last4
        self.brand = brand
        self.expiration = expiration
    }
}
