import Foundation

@objc(S4Customer)
public class Customer: NSObject, Codable {
    @objc public let id: String

    internal init(id: String) {
        self.id = id
    }
}

@objc(S4PaymentResult)
public class PaymentResult: NSObject, Codable {
    @objc public let email: String?
    @objc public let customer: Customer?
    @objc public let chargeId: String?
    @objc public let subscriptionId: String?

    internal init(email: String?, customer: Customer?, chargeId: String?, subscriptionId: String?) {
        self.email = email
        self.customer = customer
        self.chargeId = chargeId
        self.subscriptionId = subscriptionId
    }

    internal func withEmail(email: String) -> PaymentResult {
        PaymentResult(
            email: email,
            customer: customer,
            chargeId: chargeId,
            subscriptionId: subscriptionId
        )
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
