import Foundation

@objc(S4TokenRequest)
internal class TokenRequest: NSObject, Codable {
    enum CodingKeys: String, CodingKey {
        case number
        case expirationMonth = "expMonth"
        case expirationYear = "expYear"
        case cvc
        case cardholder = "cardholderName"
    }

    let number: String
    let expirationMonth: String
    let expirationYear: String
    let cvc: String
    let cardholder: String?

    @objc public init(
        number: String,
        expirationMonth: String,
        expirationYear: String,
        cvc: String,
        cardholder: String? = nil
    ) {
        self.number = number
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvc = cvc
        self.cardholder = cardholder
    }
}
