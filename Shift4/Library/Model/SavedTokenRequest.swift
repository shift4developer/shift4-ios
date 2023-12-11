import Foundation

internal struct SavedTokenRequest: Codable {
    let key: String
    let email: String
    let paymentUserAgent: String
}
