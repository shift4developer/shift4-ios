import Foundation

internal struct Subscription: Equatable {
    internal let planId: String
}

internal struct CompleteSubscription: Codable {
    internal struct Plan: Codable {
        internal let amount: Int
        internal let currency: String
    }

    internal var readable: String {
        CurrencyFormatter.format(amount: NSDecimalNumber(integerLiteral: plan.amount), code: plan.currency)
    }

    internal let plan: Plan
}

internal struct Donation: Equatable {
    internal let amount: Int
    internal let currency: String

    internal var readable: String {
        CurrencyFormatter.format(amount: NSDecimalNumber(integerLiteral: amount), code: currency)
    }
}

@objc(S4CheckoutRequest)
public class CheckoutRequest: NSObject {
    @objc public init(content: String) {
        self.content = content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    internal let content: String
}

extension CheckoutRequest {
    var amount: Int {
        guard let charge = jsonDict["charge"] as? [String: Any] else { return 0 }
        guard let amount = charge["amount"] as? Int else { return 0 }
        return amount
    }

    var currency: String {
        guard let charge = jsonDict["charge"] as? [String: Any] ?? jsonDict["customCharge"] as? [String: Any] else { return "" }
        guard let currency = charge["currency"] as? String else { return "" }
        return currency
    }

    var threeDSecure: Bool {
        guard let threeDSecure = jsonDict["threeDSecure"] as? [String: Any] else { return false }
        guard let enable = threeDSecure["enable"] as? Bool else { return false }
        return enable
    }

    var requireEnrolledCard: Bool {
        guard let threeDSecure = jsonDict["threeDSecure"] as? [String: Any] else { return true }
        guard let enable = threeDSecure["requireEnrolledCard"] as? Bool else { return true }
        return enable
    }

    var requireSuccessfulLiabilityShiftForEnrolledCard: Bool {
        guard let threeDSecure = jsonDict["threeDSecure"] as? [String: Any] else { return true }
        guard let enable = threeDSecure["requireSuccessfulLiabilityShiftForEnrolledCard"] as? Bool else { return true }
        return enable
    }

    var readable: String {
        CurrencyFormatter.format(amount: NSDecimalNumber(integerLiteral: amount), code: currency)
    }

    var rememberMe: Bool {
        jsonDict["rememberMe"] as? Bool ?? false
    }

    var termsAndConditions: String? {
        jsonDict["termsAndConditionsUrl"] as? String
    }

    var customerId: String? {
        jsonDict["customerId"] as? String
    }

    var crossSaleOfferIds: [String]? {
        jsonDict["crossSaleOfferIds"] as? [String]
    }

    var correct: Bool {
        !jsonDict.isEmpty
    }

    var donations: [Donation]? {
        guard let customCharge = jsonDict["customCharge"] as? [String: Any] else { return nil }
        guard let amountOptions = customCharge["amountOptions"] as? [Int] else { return nil }
        guard let currency = customCharge["currency"] as? String else { return nil }

        let result = amountOptions.map { Donation(amount: $0, currency: currency) }
        return result.isEmpty ? nil : result
    }

    var customDonation: (Int, Int)? {
        guard let customCharge = jsonDict["customCharge"] as? [String: Any] else { return nil }
        guard let customAmount = customCharge["customAmount"] as? [String: Int] else { return nil }
        guard let min = customAmount["min"], let max = customAmount["max"] else { return nil }

        return (min, max)
    }

    var subscription: Subscription? {
        guard let subscription = jsonDict["subscription"] as? [String: Any] else { return nil }
        guard let planId = subscription["planId"] as? String else { return nil }
        return Subscription(planId: planId)
    }

    private var jsonDict: [String: Any] {
        guard let decodedData = Data(base64Encoded: content) else { return [:] }
        let decoded = String(data: decodedData, encoding: .utf8)
        guard let json = decoded?.components(separatedBy: "|").last else { return [:] }
        return ((try? JSONSerialization.jsonObject(with: json.data(using: .utf8) ?? Data(), options: [])) as? [String: Any]) ?? [:]
    }
}
