import Foundation

internal struct ThreeDSecureRequest: Encodable {
    let paymentUserAgent = UserAgentProvider.short
    let card: String
    let amount: Int
    let currency: String
    let platform = "ios"
}
