import Foundation
import UIKit

@objc(Shift4SDK)
public final class Shift4SDK: NSObject {
    @objc public static let shared = Shift4SDK()
    @objc public var publicKey: String?
    @objc public var bundleIdentifier: String?
    @objc public let style: Shift4Style

    private let apiProvider = APIProvider()
    private var busy = false
    private var authenticator: ThreeDAuthenticator?

    override private init() {
        FontsLoader.loadFontsIfNeeded()
        style = Shift4Style()
    }

    @objc public func showCheckoutViewController(
        in viewController: UIViewController,
        checkoutRequest: CheckoutRequest,
        merchantName: String,
        description: String,
        merchantLogo: UIImage? = nil,
        collectShippingAddress: Bool = false,
        collectBillingAddress: Bool = false,
        email: String? = nil,
        completion: @escaping (PaymentResult?, Shift4Error?) -> Void
    ) {
        checkIsConfigured()

        if !checkoutRequest.correct { completion(nil, .incorrectCheckoutRequest); return }
        if checkoutRequest.termsAndConditions != nil { completion(nil, .unsupportedValue(value: "termsAndConditionsUrl")); return }
        if checkoutRequest.crossSaleOfferIds != nil { completion(nil, .unsupportedValue(value: "crossSaleOfferIds")); return }

        let threeDManager = ThreeDManager(style: style)
        let checkoutManager = CheckoutManager(threeDManager: threeDManager)

        let checkoutViewController = CheckoutViewController(
            checkoutRequest: checkoutRequest,
            merchantName: merchantName,
            description: description,
            merchantLogo: merchantLogo,
            collectShippingAddress: collectShippingAddress,
            collectBillingAddress: collectBillingAddress,
            email: email,
            style: style,
            checkoutManager: checkoutManager,
            completion: completion
        )

        let drawer = BottomDrawerViewController(contentViewController: checkoutViewController)
        drawer.modalPresentationStyle = .custom
        drawer.transitioningDelegate = BottomDrawerTransitioningDelegate.shared
        drawer.modalPresentationCapturesStatusBarAppearance = true
        viewController.present(drawer, animated: true, completion: nil)
    }

    @objc public func cleanSavedCards() {
        Keychain.cleanSavedEmails()
    }

    private func checkIsConfigured() {
        if (publicKey ?? "").isEmpty {
            fatalError("You must set Shift4SDK.shared.publicKey before using SDK.")
        }
        if (bundleIdentifier ?? "").isEmpty {
            fatalError("You must set Shift4SDK.shared.bundleIdentifier before using SDK.")
        }
    }
}
