import Foundation
import Shift43DS
import UIKit

@objc(S4Error)
public final class Shift4Error: NSObject, Codable {
    public enum ErrorType: String, Codable {
        case invalidRequest = "invalid_request"
        case cardError = "card_error"
        case gatewayError = "gateway_error"
        case invalidVerificationCode = "invalid-verification-code"
        case network

        case unknown
        case sdk
        case threeDSecure

        public init(from decoder: Decoder) throws {
            self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
        }
    }

    public enum ErrorCode: String, Codable {
        case invalidNumber = "invalid_number"
        case invalidExpiryMonth = "invalid_expiry_month"
        case invalidExpiryYear = "invalid_expiry_year"
        case invalidCVC = "invalid_cvc"
        case incorrectCVC = "incorrect_cvc"
        case incorrectZip = "incorrect_zip"
        case expiredCard = "expired_card"
        case insufficientFunds = "insufficient_funds"
        case lostOrStolen = "lost_or_stolen"
        case suspectedFraud = "suspected_fraud"
        case cardDeclined = "card_declined"
        case processingError = "processing_error"
        case blacklisted
        case expiredToken = "expired_token"
        case limitExcedeed = "limit_exceeded"
        case invalidVerificationCode = "verification_code_invalid"
        case verificationCodeRequired = "verification_code_required"
        case enrolledCardIsRequired
        case successfulLiabilityShiftIsRequired
        case authenticationRequired = "authentication_required"
        case invalidEmail = "invalid_email"
        case unsupportedValue
        case incorrectCheckoutRequest
        case deviceJailbroken
        case integrityTampered
        case simulator
        case osNotSupported
        case timeout

        case requestTimedOut = "request_timedout"
        case poorConnection = "poor_connection"
        case unknownConnectionError = "unknown_connection_error"

        case anotherOperation

        case unknown

        public init(from decoder: Decoder) throws {
            self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
        }
    }

    let type: ErrorType
    let code: ErrorCode?
    let message: String

    init(type: ErrorType, code: ErrorCode?, message: String) {
        if type == .invalidRequest, message.hasPrefix("email: ") {
            self.type = type
            self.code = .invalidEmail
            self.message = message.replacingOccurrences(of: "email: ", with: "")
        } else {
            self.type = type
            self.code = code
            self.message = message
        }
    }

    internal init(error: Error) {
        type = .unknown
        code = nil
        message = error.localizedDescription
    }

    internal static var unknown: Shift4Error {
        Shift4Error(type: .unknown, code: nil, message: .localized("unknown_error"))
    }

    internal static var unknown3DSecureError: Shift4Error {
        Shift4Error(type: .threeDSecure, code: .unknown, message: "3D Secure Authorization error. Try again or contact support.")
    }

    internal static func protocol3dSecureError(protocolEvent: ProtocolErrorEvent) -> Shift4Error {
        Shift4Error(type: .threeDSecure, code: .unknown, message: protocolEvent.getErrorMessage().getErrorDescription())
    }

    internal static func runtime3dSecureError(runtimeEvent: RuntimeErrorEvent) -> Shift4Error {
        Shift4Error(type: .threeDSecure, code: .unknown, message: runtimeEvent.getErrorMessage())
    }

    internal static var threeDSTimeout: Shift4Error {
        Shift4Error(type: .threeDSecure, code: .timeout, message: "3D Secure Authorization timeout.")
    }

    internal static func unsupportedValue(value: String) -> Shift4Error {
        Shift4Error(type: .sdk, code: .unsupportedValue, message: "Unsupported value: \(value)")
    }

    internal static var incorrectCheckoutRequest: Shift4Error {
        Shift4Error(type: .sdk, code: .incorrectCheckoutRequest, message: "Incorrect checkout request")
    }

    internal static var enrolledCardIsRequired: Shift4Error {
        Shift4Error(type: .invalidRequest, code: .enrolledCardIsRequired, message: "The charge requires cardholder authentication.")
    }

    internal static var successfulLiabilityShiftIsRequired: Shift4Error {
        Shift4Error(type: .invalidRequest, code: .successfulLiabilityShiftIsRequired, message: "The charge requires cardholder authentication.")
    }

    internal static func connectionError(with error: Error) -> Shift4Error {
        guard let urlError = error as? URLError else {
            return Shift4Error(type: .network, code: .unknownConnectionError, message: "")
        }

        if urlError.isTimedOut {
            return Shift4Error(type: .network, code: .requestTimedOut, message: "")
        }

        return Shift4Error(type: .network, code: .unknownConnectionError, message: "")
    }

    internal static func threeDError(with warning: Warning) -> Shift4Error {
        switch warning.getID() {
        case "SW01": return Shift4Error(type: .threeDSecure, code: .deviceJailbroken, message: warning.getMessage())
        case "SW02": return Shift4Error(type: .threeDSecure, code: .integrityTampered, message: warning.getMessage())
        case "SW03": return Shift4Error(type: .threeDSecure, code: .simulator, message: warning.getMessage())
        case "SW05": return Shift4Error(type: .threeDSecure, code: .osNotSupported, message: warning.getMessage())
        default: return Shift4Error(type: .threeDSecure, code: .unknown, message: warning.getMessage())
        }
    }

    internal static var busy: Shift4Error {
        Shift4Error(type: .sdk, code: .anotherOperation, message: "Another task is in progress.")
    }

    @objc public func localizedMessage() -> String {
        let notFoundToken = "_NOT_FOUND_"
        let key = (code ?? .unknown).rawValue.components(separatedBy: ".").last ?? ""
        let result = String.localized(key, value: notFoundToken)
        if result == notFoundToken {
            return message.isEmpty ? Shift4Error.unknown.message : message
        } else {
            return result
        }
    }

    @objc
    public func dictionary() -> [String: Any] {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        } catch {
            return [:]
        }
    }
}

extension URLError {
    var isTimedOut: Bool {
        code.rawValue == NSURLErrorTimedOut
    }

    var isPoorConnection: Bool {
        let poorConnectionCodes = [
            NSURLErrorCannotFindHost,
            NSURLErrorCannotConnectToHost,
            NSURLErrorNetworkConnectionLost,
            NSURLErrorNotConnectedToInternet,
        ]

        return poorConnectionCodes.contains(code.rawValue)
    }
}
