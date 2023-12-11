import Foundation

internal struct ThreeDSecureAuthenticateRequest: Codable {
    let token: String
    let clientAuthRequest: String
}
