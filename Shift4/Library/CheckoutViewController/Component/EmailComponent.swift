import Foundation
import UIKit

final class EmailComponent: VerticalComponent {
    private lazy var email = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.email,
        style: style,
        placeholder: .localized("email"),
        keyboardType: .emailAddress
    )
    private lazy var error = ErrorLabel(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.emailErrorLabel,
        style: style
    )

    var didReturn: () -> Void = {}
    var didChange: (String?) -> Void = { _ in }

    var value: String? {
        get { email.text }
        set { email.text = newValue }
    }

    var isEnabled:
        Bool
    {
        get { email.isEnabled }
        set { email.isEnabled = newValue }
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

    private func commonInit() {
        email.delegate = self
        addArrangedSubview(email)
        addArrangedSubview(error)
    }

    func becomeFirstResponderWithoutAnimation() {
        email.becomeFirstResponderWithoutAnimation()
    }

    func setError(error: String?) {
        guard let error else {
            self.error.text = nil
            email.error = false
            return
        }
        email.error = true
        self.error.text = error
    }
}

extension EmailComponent: UITextFieldDelegate {
    func textFieldShouldReturn(_: UITextField) -> Bool {
        didReturn()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            didChange(nil)
            return true
        }
        guard let textRange = Range(range, in: text) else { return true }
        let updatedText = text.replacingCharacters(in: textRange, with: string)

        let cursorLocation = textField.position(from: textField.beginningOfDocument, offset: range.location + string.count)
        email.text = updatedText
        if let cursorLocation {
            textField.selectedTextRange = textField.textRange(from: cursorLocation, to: cursorLocation)
        }
        didChange(nil)

        return false
    }
}
