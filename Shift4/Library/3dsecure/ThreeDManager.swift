import Foundation
import Shift43DS
import UIKit

internal final class ThreeDManager {
    private var threeDS2Service: ThreeDS2Service?
    private var sdkTransaction: Transaction?
    private var sdkProgressDialog: ProgressDialog?
    private let style: Shift4Style
    private var statusReceiver: StatusReceiver!

    init(style: Shift4Style) {
        self.style = style
    }

    func initializeSDK(cardBrand: String, certificate: DirectoryServerCertificate?, sdkLicense _: String, bundleIdentifier: String) throws -> [Warning] {
        threeDS2Service = ThreeDS2Service()
        guard let certificate else { return [] }

        let directoryServerInfoList = [DirectoryServerInfo(RID: directoryServerID(for: cardBrand.lowercased()),
                                                           publicKey: certificate.certificate,
                                                           CAs: certificate.caCertificates)]

        let excludedParameters: [String] = [
            "C007",
            "C009",
        ]

        let configParameters = ConfigParameters(
            bundleIdentifier: bundleIdentifier,
            directoryServerInfo: directoryServerInfoList,
            excludedDeviceParameters: excludedParameters
        )

        try threeDS2Service?.initialize(
            configParameters: configParameters,
            locale: nil,
            uiCustomization: ThreeDUICustomizationFactory(style: style).uiCustomization()
        )

        return try threeDS2Service?.getWarnings().filter { $0.getID() != "SW04" } ?? []
    }

    func showProgressDialog() throws {
        sdkProgressDialog = try sdkTransaction?.getProgressView()
        sdkProgressDialog?.show()
    }

    func cancelProgressDialog() {
        sdkProgressDialog?.close()
        sdkProgressDialog = nil
    }

    func createTransaction(version: String, cardBrand: String) throws {
        sdkTransaction = try threeDS2Service!.createTransaction(directoryServerID: directoryServerID(for: cardBrand.lowercased()), messageVersion: version)
    }

    func getAuthenticationRequestParameters() throws -> AuthenticationRequestParameters? {
        if sdkTransaction == nil {
            return nil
        }
        return try sdkTransaction!.getAuthenticationRequestParameters()
    }

    func startChallenge(_ authResponse: String, _ navigationController: UIViewController, _ completion: @escaping (Bool, Shift4Error?) -> Void) {
        statusReceiver = StatusReceiver(
            completion: completion,
            closeTransaction: { [weak self] in self?.closeTransaction() }
        )
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let challengeParameters = try ChallengeParameters(threeDSServerAuthResponse: authResponse, threeDSRequestorAppURL: "")
                try self.sdkTransaction?.doChallenge(
                    challengeParameters: challengeParameters,
                    challengeStatusReceiver: self.statusReceiver!,
                    timeout: 5,
                    inViewController: navigationController
                )
            } catch {
                DispatchQueue.main.async {
                    completion(false, Shift4Error.unknown)
                }
            }
        }
    }

    func closeTransaction() {
        try? sdkTransaction?.close()

        sdkTransaction = nil
        threeDS2Service = nil
        statusReceiver = nil

        cancelProgressDialog()
    }

    final class StatusReceiver: ChallengeStatusReceiver {
        var completion: ((Bool, Shift4Error?) -> Void)?
        let closeTransaction: () -> Void

        init(completion: @escaping (Bool, Shift4Error?) -> Void, closeTransaction: @escaping () -> Void) {
            self.completion = completion
            self.closeTransaction = closeTransaction
        }

        func completed(completionEvent _: CompletionEvent) {
            DispatchQueue.main.async {
                self.completion?(true, nil)
                self.completion = nil
                self.closeTransaction()
            }
        }

        func cancelled() {
            DispatchQueue.main.async {
                self.completion?(false, nil)
                self.completion = nil
                self.closeTransaction()
            }
        }

        func timedout() {
            DispatchQueue.main.async {
                self.completion?(false, .threeDSTimeout)
                self.completion = nil
                self.closeTransaction()
            }
        }

        func protocolError(protocolErrorEvent: ProtocolErrorEvent) {
            DispatchQueue.main.async {
                self.completion?(false, .protocol3dSecureError(protocolEvent: protocolErrorEvent))
                self.completion = nil
                self.closeTransaction()
            }
        }

        func runtimeError(runtimeErrorEvent: RuntimeErrorEvent) {
            DispatchQueue.main.async {
                self.completion?(false, .runtime3dSecureError(runtimeEvent: runtimeErrorEvent))
                self.completion = nil
                self.closeTransaction()
            }
        }
    }

    private func directoryServerID(for cardBrand: String) -> String {
        switch cardBrand {
        case "visa": return "A000000003"
        case "mastercard": return "A000000004"
        case "amex": return "A000000025"
        default: return "unknown"
        }
    }
}
