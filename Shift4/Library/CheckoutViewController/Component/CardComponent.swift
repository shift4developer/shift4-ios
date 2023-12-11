import Foundation
import UIKit

final class CardComponent: VerticalComponent {
    private lazy var cardNumberTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.cardNumber,
        style: style,
        placeholder: .localized("card_number"),
        keyboardType: .numberPad,
        rightImage: .fromBundle(named: "Card_Default")
    )
    private lazy var expirationTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.expiration,
        style: style,
        placeholder: .localized("expiration"),
        keyboardType: .numberPad
    )
    private lazy var cvcTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.cvc,
        style: style,
        placeholder: .localized("cvc"),
        keyboardType: .numberPad,
        rightImage: .fromBundle(named: "Card_CVV")
    )
    private lazy var error = ErrorLabel(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.cardErrorLabel,
        style: style
    )
    var currentCard = CreditCard.empty {
        didSet {
            cardNumberTextField.text = currentCard.readable
            cardNumberTextField.rightImage = currentCard.image
        }
    }

    var didReturn: () -> Void = {}
    var didChangeNumber: () -> Void = {}
    var didChangeExpiration: () -> Void = {}
    var didChangeCVC: () -> Void = {}

    var expiration: String? {
        get { expirationTextField.text }
        set { expirationTextField.text = newValue }
    }

    var cvc: String? {
        get { cvcTextField.text }
        set { cvcTextField.text = newValue }
    }

    var isEnabled: Bool {
        get { cardNumberTextField.isEnabled && expirationTextField.isEnabled && cvcTextField.isEnabled }
        set {
            cardNumberTextField.isEnabled = newValue
            expirationTextField.isEnabled = newValue
            cvcTextField.isEnabled = newValue
        }
    }

    private let style: Shift4Style

    init(style: Shift4Style) {
        self.style = style
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        style = Shift4Style()
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        style = Shift4Style()
        super.init(coder: coder)
        commonInit()
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        cardNumberTextField.becomeFirstResponder()
    }

    func clean() {
        cardNumberTextField.text = nil
        expirationTextField.text = nil
        cvcTextField.text = nil
        currentCard = CreditCard()
        cardNumberTextField.rightImage = currentCard.image
    }

    private func commonInit() {
        cardNumberTextField.delegate = self
        expirationTextField.delegate = self
        cvcTextField.delegate = self

        addArrangedSubview(cardNumberTextField)
        addArrangedSubview(HorizontalComponent(arrangedSubviews: [expirationTextField, cvcTextField]))
        addArrangedSubview(error)
    }

    func setError(error: String?) {
        guard let error else {
            self.error.text = nil
            self.error.isHidden = true
            cardNumberTextField.error = false
            expirationTextField.error = false
            cvcTextField.error = false
            return
        }
        cardNumberTextField.error = true
        expirationTextField.error = true
        cvcTextField.error = true
        self.error.isHidden = false
        self.error.text = error
    }

    func becomeFirstResponderWithoutAnimation() {
        cardNumberTextField.becomeFirstResponderWithoutAnimation()
    }

    func cvcBecomeFirstResponderWithoutAnimation() {
        cvcTextField.becomeFirstResponderWithoutAnimation()
    }
}

extension CardComponent: UITextFieldDelegate {
    func textFieldShouldReturn(_: UITextField) -> Bool {
        false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            didChangeNumber()
            return true
        }
        guard var textRange = Range(range, in: text) else { return true }

        if text[textRange] == " ", textField === cardNumberTextField, let newTextRange = Range(NSRange(location: range.location - 1, length: range.length + 1), in: text) {
            textRange = newTextRange
        }

        let updatedText = text.replacingCharacters(in: textRange, with: string)
        let backspace = updatedText.count < text.count

        if cardNumberTextField.contains(textField: textField) {
            let cursorLocation = textField.position(from: textField.beginningOfDocument, offset: range.location + string.count)
            currentCard = CreditCard(number: updatedText)
            cvcTextField.permanentPlaceholder = currentCard.cvcPlaceholder
            cardNumberTextField.rightImage = currentCard.image
            if updatedText.sanitized().count >= currentCard.numberLength {
                cardNumberTextField.text = currentCard.readable
                let formatted = ExpirationDateFormatter.format(inputText: expirationTextField.text ?? .empty, backspace: backspace)
                expirationTextField.permanentPlaceholder = formatted.placeholder
                expirationTextField.becomeFirstResponder()
            } else {
                cardNumberTextField.text = currentCard.readable
            }
            if let cursorLocation {
                textField.selectedTextRange = textField.textRange(from: cursorLocation, to: cursorLocation)
            }
            didChangeNumber()
            return false
        }

        if expirationTextField.contains(textField: textField) {
            let formatted = ExpirationDateFormatter.format(inputText: updatedText, backspace: backspace)
            expirationTextField.permanentPlaceholder = formatted.placeholder
            expirationTextField.text = formatted.text
            if formatted.resignFocus {
                cvcTextField.becomeFirstResponder()
            }
            didChangeExpiration()
            return false
        }

        if cvcTextField.contains(textField: textField) {
            let cursorLocation = textField.position(from: textField.beginningOfDocument, offset: range.location + string.count)
            if updatedText.count >= currentCard.cvcLength {
                textField.resignFirstResponder()
                didReturn()
            }
            cvcTextField.text = String(updatedText.prefix(currentCard.cvcLength))
            if let cursorLocation {
                textField.selectedTextRange = textField.textRange(from: cursorLocation, to: cursorLocation)
            }
            didChangeCVC()
            return false
        }

        return true
    }
}
