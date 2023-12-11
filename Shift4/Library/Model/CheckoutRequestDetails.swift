import Foundation

internal struct CheckoutRequestDetails: Codable {
    let sessionId: String
    let threeDSecureRequired: Bool
    let subscription: CompleteSubscription?
}
