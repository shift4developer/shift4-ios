import Foundation

internal struct PaymentRequest: Codable {
    let key: String
    let email: String
    let checkoutRequest: String
    let tokenId: String
    let sessionId: String
    let rememberMe: Bool
    let cvc: String?
    let verificationSmsId: String?
    let customAmount: Int?
    let shipping: Shipping?
    let billing: Billing?

    init(key: String, email: String, checkoutRequest: CheckoutRequest, tokenID: String, sessionID: String, rememberMe: Bool, cvc: String? = nil, sms: SMS?, customAmount: Int?, shipping: Shipping?, billing: Billing?) {
        self.key = key
        self.email = email
        self.checkoutRequest = checkoutRequest.content
        tokenId = tokenID
        sessionId = sessionID
        self.rememberMe = rememberMe
        self.cvc = cvc
        verificationSmsId = sms?.id
        self.customAmount = customAmount
        self.shipping = shipping
        self.billing = billing
    }
}
