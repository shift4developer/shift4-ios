import UIKit
import Shift4

final class CheckoutViewController: UIViewController {
    @IBOutlet weak var publicKey: UITextField!
    @IBOutlet weak var checkoutRequest: UITextField!
    
    @IBAction func didTapPaymentButton(_ sender: Any) {
        Shift4SDK.shared.publicKey = publicKey.text
        Shift4SDK.shared.bundleIdentifier = "com.securionpay.sdk.SecurionPay.Examples"
        Shift4SDK.shared.showCheckoutViewController(
            in: self,
            checkoutRequest: CheckoutRequest(content: checkoutRequest.text!), merchantName: "Merchant", description: "Example payment") { [weak self] result, error in
                if let result = result {
                    let alert = UIAlertController(title: "Payment succeeded!", message: "Charge id: \(result.chargeId ?? "-")\nSubscription id: \(result.subscriptionId ?? "-")", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                } else if let error = error {
                    let alert = UIAlertController(title: "Error!", message: error.localizedMessage(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Payment cancelled!", message: "Try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
    }
    
    @IBAction func didTapClearCardsButton(_ sender: Any) {
        Shift4SDK.shared.publicKey = publicKey.text
        Shift4SDK.shared.cleanSavedCards()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "CheckoutViewController"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
