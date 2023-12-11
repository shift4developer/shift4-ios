import Foundation
import UIKit

final class Shift4BorderedTextField: UIStackView {
    private lazy var textField = Shift4TextField(style: style)

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var isEnabled: Bool {
        get { textField.isEnabled }
        set { textField.isEnabled = newValue }
    }

    var error: Bool {
        get { textField.error }
        set {
            textField.error = newValue
            layer.borderColor = (newValue ? style.errorColor : style.separatorColor).cgColor
        }
    }

    var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }

    weak var delegate: UITextFieldDelegate? {
        get { textField.delegate }
        set { textField.delegate = newValue }
    }

    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    var autocapitalizationType: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }

    var rightImage: UIImage? {
        get { textField.rightImage }
        set { textField.rightImage = newValue }
    }

    var permanentPlaceholder: String? {
        get { textField.permanentPlaceholder }
        set { textField.permanentPlaceholder = newValue }
    }

    override var accessibilityIdentifier: String? {
        get { textField.accessibilityIdentifier }
        set { textField.accessibilityIdentifier = newValue }
    }

    override var inputView: UIView? {
        get { textField.inputView }
        set { textField.inputView = newValue }
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    func becomeFirstResponderWithoutAnimation() {
        textField.becomeFirstResponderWithoutAnimation()
    }

    func contains(textField: UITextField) -> Bool {
        textField === self.textField
    }

    private let style: Shift4Style

    init(accessibilityIdentifier: String,
         style: Shift4Style,
         placeholder: String? = nil,
         keyboardType: UIKeyboardType? = nil,
         autocapitalizationType: UITextAutocapitalizationType = .none,
         rightImage: UIImage? = nil)
    {
        self.style = style
        super.init(frame: .zero)
        textField.placeholder = placeholder
        if let keyboardType {
            textField.keyboardType = keyboardType
        }
        textField.autocapitalizationType = autocapitalizationType
        textField.accessibilityIdentifier = accessibilityIdentifier
        textField.rightImage = rightImage
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
        axis = .horizontal
        addArrangedSubview(textField)
        layer.borderWidth = Style.Layout.borderWidth
        layer.borderColor = style.separatorColor.cgColor
        layer.cornerRadius = Style.Layout.cornerRadius
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
    }
}
