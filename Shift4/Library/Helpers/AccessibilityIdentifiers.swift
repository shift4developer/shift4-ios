import Foundation

enum ThreeDSAccessibilityIdentifier {
    static let identifier = "ThreeDSAccessibilityIdentifier.identifier"
    static let scrollView = "ThreeDSAccessibilityIdentifier.scrollView"
    static let stack = "ThreeDSAccessibilityIdentifier.stack"
    static let title = "ThreeDSAccessibilityIdentifier.title"

    static let challengeInformationHeader = "ThreeDSAccessibilityIdentifier.challengeInformationHeader"
    static let challengeInformationText = "ThreeDSAccessibilityIdentifier.challengeInformationText"
    static let challengeInformationLabel = "ThreeDSAccessibilityIdentifier.challengeInformationLabel"

    static let challengeDataEntry = "ThreeDSAccessibilityIdentifier.challengeDataEntryOne"

    static let cancelButton = "ThreeDSAccessibilityIdentifier.cancel"
    static let submitButton = "ThreeDSAccessibilityIdentifier.submitButton"
    static let resendButton = "ThreeDSAccessibilityIdentifier.resendButton"
    static let oobButton = "ThreeDSAccessibilityIdentifier.oobButton"
}

enum AccessibilityIdentifier {
    enum PaymentViewController {
        static let identifier = "AccessibilityIdentifier.PaymentViewController.identifier"
        static let titleLabel = "AccessibilityIdentifier.PaymentViewController.titleLabel"
        static let descriptionLabel = "AccessibilityIdentifier.PaymentViewController.descriptionLabel"
        static let email = "AccessibilityIdentifier.PaymentViewController.email"
        static let cardNumber = "AccessibilityIdentifier.PaymentViewController.cardNumber"
        static let expiration = "AccessibilityIdentifier.PaymentViewController.expiration"
        static let cvc = "AccessibilityIdentifier.PaymentViewController.cvc"
        static let sms = "AccessibilityIdentifier.PaymentViewController.sms"
        static let button = "AccessibilityIdentifier.PaymentViewController.button"
        static let closeButton = "AccessibilityIdentifier.PaymentViewController.closeButton"
        static let rememberSwitch = "AccessibilityIdentifier.PaymentViewController.rememberSwitch"
        static let emailErrorLabel = "AccessibilityIdentifier.PaymentViewController.emailErrorLabel"
        static let cardErrorLabel = "AccessibilityIdentifier.PaymentViewController.cardErrorLabel"
        static let errorLabel = "AccessibilityIdentifier.PaymentViewController.errorLabel"
        static func donationCell(with title: String) -> String {
            "AccessibilityIdentifier.PaymentViewController.DonationCarousel." + title
        }

        enum Address {
            static let sameAddressSwitch = "AccessibilityIdentifier.PaymentViewController.Address.sameAddressSwitch"
            enum Billing {
                static let title = "AccessibilityIdentifier.PaymentViewController.Address.Billing.title"
                static let name = "AccessibilityIdentifier.PaymentViewController.Address.Billing.name"
                static let street = "AccessibilityIdentifier.PaymentViewController.Address.Billing.street"
                static let zip = "AccessibilityIdentifier.PaymentViewController.Address.Billing.zip"
                static let city = "AccessibilityIdentifier.PaymentViewController.Address.Billing.city"
                static let country = "AccessibilityIdentifier.PaymentViewController.Address.Billing.country"
                static let vat = "AccessibilityIdentifier.PaymentViewController.Address.Billing.vat"
            }

            enum Shipping {
                static let title = "AccessibilityIdentifier.PaymentViewController.Address.Shipping.title"
                static let name = "AccessibilityIdentifier.PaymentViewController.Address.Shipping.name"
                static let street = "AccessibilityIdentifier.PaymentViewController.Address.Shipping.street"
                static let zip = "AccessibilityIdentifier.PaymentViewController.Address.Shipping.zip"
                static let city = "AccessibilityIdentifier.PaymentViewController.Address.Shipping.city"
                static let country = "AccessibilityIdentifier.PaymentViewController.Address.Shipping.country"
            }
        }
    }
}
