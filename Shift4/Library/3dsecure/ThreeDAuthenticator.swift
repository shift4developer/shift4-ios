import Foundation
import UIKit

internal final class ThreeDAuthenticator {
    private let apiProvider = APIProvider()
    private let threeDManager: ThreeDManager

    let style: Shift4Style

    init(style: Shift4Style, threeDManager: ThreeDManager) {
        self.style = style
        self.threeDManager = threeDManager
    }

    @objc public func authenticate(
        token: Token,
        amount: Int,
        currency: String,
        viewController: UIViewController,
        bundleIdentifier: String?,
        completion: @escaping (Token?, Shift4Error?) -> Void
    ) {
        apiProvider.threeDSecureCheck(token: token, amount: amount, currency: currency) { [weak self] initResponse, initializationError in
            guard let self else { return }
            guard let initResponse else { completion(nil, initializationError); return }

            guard initResponse.token.threeDSecureInfo?.enrolled ?? false, initResponse.version.hasPrefix("2") else {
                completion(initResponse.token, nil)
                return
            }

            do {
                let threeDSecureWarnings = try self.threeDManager.initializeSDK(
                    cardBrand: initResponse.token.brand,
                    certificate: initResponse.directoryServerCertificate,
                    sdkLicense: initResponse.sdkLicense ?? .empty,
                    bundleIdentifier: bundleIdentifier ?? .empty
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
                    case .correct, .incorrect, .attemptPerformed, .technicalProblem, .rejected, .unknown:
                        self.apiProvider.threeDSecureComplete(token: initResponse.token) { securedToken, _ in
                            self.threeDManager.cancelProgressDialog()
                            completion(securedToken, nil)
                        }

                    case .challenge, .dChallenge:
                        let resp = authenticationResult?.ares.clientAuthResponse.fromBase64() ?? .empty
                        self.threeDManager.startChallenge(resp, viewController) { [weak self] success, error in
                            if let error {
                                self?.threeDManager.cancelProgressDialog()
                                completion(nil, error)
                            }
                            if !success { completion(nil, nil); return }
                            guard let self else { return }
                            self.apiProvider.threeDSecureComplete(token: initResponse.token) { securedToken, _ in
                                self.threeDManager.cancelProgressDialog()
                                completion(securedToken, nil)
                            }
                        }
                    }
                }
            } catch {
                completion(nil, .unknown3DSecureError)
            }
        }
    }
}
