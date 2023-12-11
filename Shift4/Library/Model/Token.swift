import Foundation

@objc(S4Token)
public class Token: NSObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case created
        case objectType
        case first6
        case last4
        case fingerprint
        case expirationMonth = "expMonth"
        case expirationYear = "expYear"
        case cardholder = "cardholderName"
        case brand
        case type
        case country
        case used
        case threeDSecureInfo
    }

    @objc public let id: String
    public let created: Int?
    @objc public let objectType: String?
    @objc public let first6: String?
    @objc public let last4: String?
    @objc public let fingerprint: String?
    @objc public let expirationMonth: String?
    @objc public let expirationYear: String?
    @objc public let cardholder: String?
    @objc public let brand: String
    @objc public let type: String?
    @objc public let country: String?
    public let used: Bool?

    @objc public let threeDSecureInfo: ThreeDSecureInfo?
}
