import Foundation

struct ThreeDSecureAuthentication: Codable {
    class Ares: NSObject, Codable {
        enum TransactionStatus: String, Codable {
            case correct = "Y"
            case incorrect = "N"
            case challenge = "C"
            case dChallenge = "D"
            case attemptPerformed = "A"
            case technicalProblem = "U"
            case rejected = "R"

            case unknown

            public init(from decoder: Decoder) throws {
                self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
            }
        }

        let messageVersion: String
        let clientAuthResponse: String
        let transStatus: TransactionStatus
    }

    let ares: Ares
}
