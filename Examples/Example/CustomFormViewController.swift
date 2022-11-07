import Foundation
import UIKit
import Shift4

final class CustomFormViewController: UIViewController {
    @IBOutlet weak var key: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var month: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var cvc: UITextField!
    
    @IBAction func didTapPaymentButtonDialog(_ sender: Any) {
        Shift4SDK.shared.publicKey = key.text
        Shift4SDK.shared.bundleIdentifier = "com.securionpay.sdk.SecurionPay.Examples"
        
        let tokenRequest = TokenRequest(number: cardNumber.text!, expirationMonth: month.text!, expirationYear: year.text!, cvc: cvc.text!)
        Shift4SDK.shared.createToken(with: tokenRequest) { [weak self] token, error in
            guard let self = self else { return }
            guard let token = token else {
                print(error!.localizedMessage())
                return
            }
            
            Shift4SDK.shared.authenticate(token: token, amount: 10000, currency: "EUR", viewControllerPresenting3DS: self) { [weak self] authenticatedToken, error in
                if let authenticatedToken = authenticatedToken {
                    let alert = UIAlertController(title: "Payment and 3DS finished!", message: "Token id: \(authenticatedToken.id)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                } else if let error = error {
                    print(error.localizedMessage())
                }
            }
        }
    }
    
    @IBAction func didTapPaymentButton(_ sender: Any) {
        Shift4SDK.shared.publicKey = key.text
        Shift4SDK.shared.bundleIdentifier = "com.securionpay.sdk.SecurionPay.Examples"
        
        let tokenRequest = TokenRequest(number: cardNumber.text!, expirationMonth: month.text!, expirationYear: year.text!, cvc: cvc.text!)
        Shift4SDK.shared.createToken(with: tokenRequest) { [weak self] token, error in
            guard let self = self else { return }
            guard let navController = self.navigationController else { return }
            guard let token = token else {
                print(error!.localizedMessage())
                return
            }
            
            Shift4SDK.shared.authenticate(token: token, amount: 10000, currency: "EUR", navigationControllerFor3DS: navController) { [weak self] authenticatedToken, error in
                if let authenticatedToken = authenticatedToken {
                    let alert = UIAlertController(title: "Payment and 3DS finished!", message: "Token id: \(authenticatedToken.id)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                } else if let error = error {
                    let alert = UIAlertController(title: "Error!", message: error.localizedMessage(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "CustomFormViewController"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
