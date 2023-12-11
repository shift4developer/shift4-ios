import Foundation

internal struct SendSMSRequest: Codable {
    let key: String
    let email: String
}
