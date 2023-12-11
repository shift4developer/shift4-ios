import CryptoKit
import Foundation

internal final class APIProvider {
    private enum Endpoint {
        case API
        case BackOffice

        var path: String {
            switch self {
            case .API: return APIConfig.apiURL
            case .BackOffice: return APIConfig.backOfficeURL
            }
        }
    }

    private enum Method: String {
        case POST
        case GET
    }

    private let session: URLSession

    init() {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.waitsForConnectivity = true
        sessionConfiguration.timeoutIntervalForRequest = 60
        sessionConfiguration.allowsCellularAccess = true
        if #available(iOS 13.0, *) {
            sessionConfiguration.allowsExpensiveNetworkAccess = true
            sessionConfiguration.allowsConstrainedNetworkAccess = true
        }

        session = URLSession(configuration: sessionConfiguration)
    }

    internal func createToken(
        with request: TokenRequest,
        completion: @escaping (Token?, Shift4Error?) -> Void
    ) {
        performAPICall(method: .POST, endpoint: .API, path: "tokens", request: request, completion: completion)
    }

    internal func pay(
        token: Token,
        checkoutRequest: CheckoutRequest,
        sessionId: String,
        email: String,
        remember: Bool,
        cvc: String?,
        sms: SMS?,
        amount: Int?,
        shipping: Shipping?,
        billing: Billing?,
        completion: @escaping (PaymentResult?, Shift4Error?) -> Void
    ) {
        let request = PaymentRequest(
            key: Shift4SDK.shared.publicKey ?? "",
            email: email,
            checkoutRequest: checkoutRequest,
            tokenID: token.id,
            sessionID: sessionId,
            rememberMe: remember,
            cvc: cvc,
            sms: sms,
            customAmount: amount,
            shipping: shipping,
            billing: billing
        )
        performAPICall(method: .POST, endpoint: .BackOffice, path: "checkout/pay", request: request) { (result: PaymentResult?, error: Shift4Error?) in
            completion(result?.withEmail(email: email), error)
        }
    }

    internal func checkoutRequestDetails(checkoutRequest: CheckoutRequest, completion: @escaping (CheckoutRequestDetails?, Shift4Error?) -> Void) {
        let request = CheckoutRequestDetailsRequest(key: Shift4SDK.shared.publicKey ?? "", checkoutRequest: checkoutRequest.content)
        performAPICall(method: .POST, endpoint: .BackOffice, path: "checkout/forms", request: request, completion: completion)
    }

    internal func lookup(email: String, completion: @escaping (LookupResult?, Shift4Error?) -> Void) {
        let request = LookupRequest(key: Shift4SDK.shared.publicKey ?? "", email: email)
        performAPICall(method: .POST, endpoint: .BackOffice, path: "checkout/lookup", request: request, completion: completion)
    }

    internal func savedToken(email: String, completion: @escaping (Token?, Shift4Error?) -> Void) {
        let request = SavedTokenRequest(key: Shift4SDK.shared.publicKey ?? "", email: email, paymentUserAgent: UserAgentProvider.short)
        performAPICall(method: .POST, endpoint: .BackOffice, path: "checkout/tokens", request: request, completion: completion)
    }

    internal func sendSMS(email: String, completion: @escaping (SMS?, Shift4Error?) -> Void) {
        let request = SendSMSRequest(key: Shift4SDK.shared.publicKey ?? "", email: email)
        performAPICall(method: .POST, endpoint: .BackOffice, path: "checkout/verification-sms", request: request, completion: completion)
    }

    internal func verifySMS(code: String, sms: SMS, completion: @escaping (VerifySMSResponse?, Shift4Error?) -> Void) {
        let request = VerifySMSRequest(code: code)
        performAPICall(method: .POST, endpoint: .BackOffice, path: "checkout/verification-sms/\(sms.id)", request: request, completion: completion)
    }

    internal func threeDSecureCheck(token: Token, amount: Int, currency: String, completion: @escaping (ThreeDSecureInitResult?, Shift4Error?) -> Void) {
        let request = ThreeDSecureRequest(card: token.id, amount: amount, currency: currency)
        performAPICall(method: .POST, endpoint: .API, path: "3d-secure", request: request, completion: completion)
    }

    internal func threeDSecureAuthenticate(token: Token, authenticationParameters: String, completion: @escaping (ThreeDSecureAuthentication?, Shift4Error?) -> Void) {
        let request = ThreeDSecureAuthenticateRequest(token: token.id, clientAuthRequest: authenticationParameters.toBase64())
        performAPICall(method: .POST, endpoint: .API, path: "3d-secure/v2/authenticate", request: request, completion: completion)
    }

    internal func threeDSecureComplete(token: Token, completion: @escaping (Token?, Shift4Error?) -> Void) {
        let request = ThreeDSecureCompleteRequest(token: token.id)
        performAPICall(method: .POST, endpoint: .API, path: "3d-secure/v2/challenge-complete", request: request, completion: completion)
    }

    private func performAPICall<Response: Codable>(
        method: Method,
        endpoint: Endpoint,
        path: String,
        request: some Encodable,
        completion: @escaping (Response?, Shift4Error?) -> Void
    ) {
        guard let url = URL(string: endpoint.path) else {
            DispatchQueue.main.async {
                completion(nil, .unknown)
            }
            return
        }

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(request)
            urlRequest.httpBody = data
            urlRequest.setValue(APIConfig.backOfficeURL,
                                forHTTPHeaderField: "Referer")
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Content-Type")
            if endpoint == .API {
                urlRequest.setValue(
                    "Basic \(Data(((Shift4SDK.shared.publicKey ?? "") + ":").utf8).base64EncodedString())",
                    forHTTPHeaderField: "Authorization"
                )
            }
            urlRequest.setValue(UserAgentProvider.userAgent, forHTTPHeaderField: "user-agent")
        } catch {
            DispatchQueue.main.async {
                completion(nil, .unknown)
            }
        }
        let task = session.dataTask(with: urlRequest, completionHandler: { data, _, error in
            DispatchQueue.main.async {
                if let error {
                    completion(nil, .connectionError(with: error))
                } else if let data {
                    let decoder = JSONDecoder()
                    if let decodedError = try? decoder.decode(GatewayErrorResponse.self, from: data) {
                        completion(nil, decodedError.toShift4Error())
                    } else if let decodedAPIError = try? decoder.decode(APIErrorResponse.self, from: data) {
                        completion(nil, decodedAPIError.toShift4Error())
                    } else if let simpleError = try? decoder.decode(SimpleAPIErrorResponse.self, from: data) {
                        completion(nil, simpleError.toShift4Error())
                    } else {
                        do {
                            let decodedToken = try decoder.decode(Response.self, from: data)
                            completion(decodedToken, nil)
                        } catch {
                            completion(nil, .unknown)
                        }
                    }
                }
            }
        })

        task.resume()
    }

    private struct APIErrorResponse: Codable {
        let error: Shift4Error

        func toShift4Error() -> Shift4Error {
            Shift4Error(type: error.type, code: error.code, message: error.message)
        }
    }

    private struct SimpleAPIErrorResponse: Codable {
        let error: String

        func toShift4Error() -> Shift4Error {
            Shift4Error(type: .unknown, code: Shift4Error.ErrorCode(rawValue: error), message: .empty)
        }
    }

    private struct GatewayErrorResponse: Codable {
        let error: String
        let errorMessage: String

        func toShift4Error() -> Shift4Error {
            Shift4Error(type: .unknown, code: nil, message: errorMessage)
        }
    }
}
