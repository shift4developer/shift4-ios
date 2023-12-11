import Foundation
import UIKit

internal final class CheckoutManager {
    private let apiProvider = APIProvider()
    private let threeDManager: ThreeDManager

    init(threeDManager: ThreeDManager) {
        self.threeDManager = threeDManager
    }

    internal func pay(
        token: Token,
        checkoutRequest: CheckoutRequest,
        email: String,
        remember: Bool = false,
        cvc: String? = nil,
        sms: SMS? = nil,
        amount: Int? = nil,
        currency: String? = nil,
        shipping: Shipping?,
        billing: Billing?,
        navigationControllerFor3DS: UIViewController,
        completion: @escaping (PaymentResult?, Shift4Error?) -> Void
    ) {
        apiProvider.checkoutRequestDetails(checkoutRequest: checkoutRequest) { [weak self] details, detailsError in
            guard let self else { return }
            guard let details else { completion(nil, detailsError); return }
            guard details.threeDSecureRequired else {
                self.apiProvider.pay(
                    token: token,
                    checkoutRequest: checkoutRequest,
                    sessionId: details.sessionId,
                    email: email,
                    remember: remember,
                    cvc: cvc,
                    sms: sms,
                    amount: checkoutRequest.subscription != nil ? nil : amount,
                    shipping: shipping,
                    billing: billing,
                    completion: completion
                )
                return
            }

            self.apiProvider.threeDSecureCheck(token: token, amount: amount ?? checkoutRequest.amount, currency: currency ?? checkoutRequest.currency) { [weak self] initResponse, initializationError in
                guard let self else { return }
                guard let initResponse else { completion(nil, initializationError); return }
                let enrolled = initResponse.token.threeDSecureInfo?.enrolled ?? false

                if checkoutRequest.requireEnrolledCard, !enrolled {
                    completion(nil, .enrolledCardIsRequired)
                    return
                }

                guard enrolled, initResponse.version.hasPrefix("2") else {
                    self.apiProvider.pay(
                        token: token,
                        checkoutRequest: checkoutRequest,
                        sessionId: details.sessionId,
                        email: email,
                        remember: remember,
                        cvc: cvc,
                        sms: sms,
                        amount: checkoutRequest.subscription != nil ? nil : amount,
                        shipping: shipping,
                        billing: billing,
                        completion: completion
                    )
                    return
                }

                do {
                    let threeDSecureWarnings = try self.threeDManager.initializeSDK(
                        cardBrand: initResponse.token.brand,
                        certificate: initResponse.directoryServerCertificate,
                        sdkLicense: initResponse.sdkLicense ?? .empty,
                        bundleIdentifier: Shift4SDK.shared.bundleIdentifier ?? .empty
                    )
                    try self.threeDManager.createTransaction(
                        version: initResponse.version,
                        cardBrand: initResponse.token.brand
                    )
                    guard let authRequestParam = try self.threeDManager.getAuthenticationRequestParameters()?.getAuthRequest(), !authRequestParam.isEmpty else {
                        if let warning = threeDSecureWarnings.first {
                            completion(nil, .threeDError(with: warning))
                        } else {
                            completion(nil, .unknown3DSecureError)
                        }
                        return
                    }

                    try self.threeDManager.showProgressDialog()
                    self.apiProvider.threeDSecureAuthenticate(token: initResponse.token, authenticationParameters: authRequestParam) { [weak self] authenticationResult, authenticationError in
                        guard let self else { return }
                        guard let result = authenticationResult else {
                            self.threeDManager.cancelProgressDialog()
                            completion(nil, authenticationError)
                            return
                        }

                        switch result.ares.transStatus {
                        case .correct, .attemptPerformed, .unknown:
                            self.apiProvider.threeDSecureComplete(token: initResponse.token) { [weak self] securedToken, _ in
                                self?.apiProvider.pay(
                                    token: securedToken ?? initResponse.token,
                                    checkoutRequest: checkoutRequest,
                                    sessionId: details.sessionId,
                                    email: email,
                                    remember: remember,
                                    cvc: cvc,
                                    sms: sms,
                                    amount: checkoutRequest.subscription != nil ? nil : amount,
                                    shipping: shipping,
                                    billing: billing
                                ) { [weak self] paymentResult, paymentError in
                                    self?.threeDManager.cancelProgressDialog()
                                    self?.threeDManager.closeTransaction()
                                    completion(paymentResult, paymentError)
                                }
                            }
                        case .incorrect, .technicalProblem, .rejected:
                            if checkoutRequest.requireSuccessfulLiabilityShiftForEnrolledCard {
                                self.threeDManager.cancelProgressDialog()
                                self.threeDManager.closeTransaction()
                                completion(nil, .successfulLiabilityShiftIsRequired)
                                return
                            } else {
                                self.apiProvider.threeDSecureComplete(token: initResponse.token) { [weak self] securedToken, _ in
                                    self?.apiProvider.pay(
                                        token: securedToken ?? initResponse.token,
                                        checkoutRequest: checkoutRequest,
                                        sessionId: details.sessionId,
                                        email: email,
                                        remember: remember,
                                        cvc: cvc,
                                        sms: sms,
                                        amount: checkoutRequest.subscription != nil ? nil : amount,
                                        shipping: shipping,
                                        billing: billing
                                    ) { [weak self] paymentResult, paymentError in
                                        self?.threeDManager.cancelProgressDialog()
                                        self?.threeDManager.closeTransaction()
                                        completion(paymentResult, paymentError)
                                    }
                                }
                            }
                        case .challenge, .dChallenge:
                            let resp = authenticationResult?.ares.clientAuthResponse.fromBase64() ?? .empty
                            self.threeDManager.startChallenge(resp, navigationControllerFor3DS.parent!) { [weak self] _, error in
                                self?.threeDManager.cancelProgressDialog()
                                self?.threeDManager.closeTransaction()
                                if let error {
                                    completion(nil, error)
                                    return
                                }

                                guard let self else { return }
                                self.apiProvider.threeDSecureComplete(token: initResponse.token) { [weak self] securedToken, _ in
                                    if let securedToken,
                                       securedToken.threeDSecureInfo?.liabilityShift == .failed,
                                       checkoutRequest.requireSuccessfulLiabilityShiftForEnrolledCard
                                    {
                                        completion(nil, .successfulLiabilityShiftIsRequired)
                                    } else {
                                        self?.apiProvider.pay(
                                            token: securedToken ?? initResponse.token,
                                            checkoutRequest: checkoutRequest,
                                            sessionId: details.sessionId,
                                            email: email,
                                            remember: remember,
                                            cvc: cvc,
                                            sms: sms,
                                            amount: checkoutRequest.subscription != nil ? nil : amount,
                                            shipping: shipping,
                                            billing: billing
                                        ) { paymentResult, paymentError in
                                            completion(paymentResult, paymentError)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    completion(nil, Shift4Error(error: error))
                }
            }
        }
    }

    internal func pay(
        tokenRequest: TokenRequest,
        checkoutRequest: CheckoutRequest,
        email: String,
        remember: Bool = false,
        cvc: String? = nil,
        sms: SMS? = nil,
        amount: Int? = nil,
        currency: String? = nil,
        shipping: Shipping?,
        billing: Billing?,
        navigationControllerFor3DS: UIViewController,
        completion: @escaping (PaymentResult?, Shift4Error?) -> Void
    ) {
        apiProvider.createToken(with: tokenRequest) { [weak self] token, error in
            guard let self else { return }
            if let token {
                self.pay(token: token, checkoutRequest: checkoutRequest, email: email, remember: remember, cvc: cvc, sms: sms, amount: amount, currency: currency, shipping: shipping, billing: billing, navigationControllerFor3DS: navigationControllerFor3DS, completion: completion)
            } else {
                completion(nil, error)
            }
        }
    }

    internal func checkoutRequestDetails(
        checkoutRequest: CheckoutRequest,
        completion: @escaping (CheckoutRequestDetails?, Shift4Error?) -> Void
    ) {
        apiProvider.checkoutRequestDetails(checkoutRequest: checkoutRequest, completion: completion)
    }

    internal func lookup(
        email: String,
        completion: @escaping (LookupResult?, Shift4Error?) -> Void
    ) {
        apiProvider.lookup(email: email, completion: completion)
    }

    internal func savedToken(
        email: String,
        completion: @escaping (Token?, Shift4Error?) -> Void
    ) {
        apiProvider.savedToken(email: email, completion: completion)
    }

    internal func sendSMS(
        email: String,
        completion: @escaping (SMS?, Shift4Error?) -> Void
    ) {
        apiProvider.sendSMS(email: email, completion: completion)
    }

    internal func verifySMS(
        code: String,
        sms: SMS,
        completion: @escaping (VerifySMSResponse?, Shift4Error?) -> Void
    ) {
        apiProvider.verifySMS(code: code, sms: sms, completion: completion)
    }
}
