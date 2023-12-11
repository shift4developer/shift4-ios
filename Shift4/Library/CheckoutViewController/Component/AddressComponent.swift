import Foundation
import UIKit

final class AddressComponent: VerticalComponent {
    var billing: Billing? {
        if billingFilled {
            return Billing(
                name: billingNameTextField.text ?? .empty,
                address: Address(
                    line1: billingStreetTextField.text ?? .empty,
                    zip: billingZipTextField.text ?? .empty,
                    city: billingCityTextField.text ?? .empty,
                    country: billingCountryCode ?? .empty
                ),
                vat: billingVatTextField.text ?? .empty
            )
        } else {
            return nil
        }
    }

    var shipping: Shipping? {
        if sameAddressSwitch.isOn {
            return billing?.toShipping()
        } else if shippingFilled {
            return Shipping(
                name: shippingNameTextField.text ?? .empty,
                address: Address(
                    line1: shippingStreetTextField.text ?? .empty,
                    zip: shippingZipTextField.text ?? .empty,
                    city: shippingCityTextField.text ?? .empty,
                    country: shippingCountryCode ?? .empty
                )
            )
        } else {
            return nil
        }
    }

    var onChange: () -> Void = {}

    private let collectShippingAddress = false
    private let collectBillingAddress = false
    private var shippingCountryCode: String? = Locale.current.regionCode
    private var billingCountryCode: String? = Locale.current.regionCode

    private lazy var separator = {
        let separator = UIView()
        separator.addConstraint(separator.heightAnchor.constraint(equalToConstant: Style.Layout.Separator.height))
        separator.backgroundColor = style.separatorColor
        return separator
    }()

    private lazy var sameAddressSwitch = {
        let sameAddress = Shift4Switch(style: Shift4SwitchStyle(labelFont: style.font.body, labelTextColor: style.primaryTextColor, infoLabelFont: style.font.regularlabel, infoLabelTextColor: style.placeholderColor, tintColor: style.primaryColor))
        sameAddress.title = .localized("same_address_switch")
        return sameAddress
    }()

    private lazy var shippingTitle = {
        let shippingTitle = UILabel()
        shippingTitle.text = .localized("shipping")
        shippingTitle.font = style.font.tileLabel
        shippingTitle.textColor = style.primaryTextColor
        return shippingTitle
    }()

    private lazy var shippingNameTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Shipping.name,
        style: style,
        placeholder: .localized("name")
    )
    private lazy var shippingStreetTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Shipping.street,
        style: style,
        placeholder: .localized("street")
    )
    private lazy var shippingZipTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Shipping.zip,
        style: style,
        placeholder: .localized("zip")
    )
    private lazy var shippingCityTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Shipping.city,
        style: style,
        placeholder: .localized("city")
    )
    private lazy var shippingCountryTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Shipping.country,
        style: style,
        placeholder: .localized("country")
    )
    private lazy var shipingCountryPicker = CountryPicker()

    private lazy var billingTitle = {
        let billingTitle = UILabel()
        billingTitle.text = .localized("billing")
        billingTitle.font = style.font.tileLabel
        billingTitle.textColor = style.primaryTextColor
        return billingTitle
    }()

    private lazy var billingNameTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Billing.name,
        style: style,
        placeholder: .localized("name")
    )
    private lazy var billingStreetTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Billing.street,
        style: style,
        placeholder: .localized("street")
    )
    private lazy var billingZipTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Billing.zip,
        style: style,
        placeholder: .localized("zip")
    )
    private lazy var billingCityTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Billing.city,
        style: style,
        placeholder: .localized("city")
    )
    private lazy var billingCountryTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Billing.country,
        style: style,
        placeholder: .localized("country")
    )
    private lazy var billingVatTextField = Shift4BorderedTextField(
        accessibilityIdentifier: AccessibilityIdentifier.PaymentViewController.Address.Billing.vat,
        style: style,
        placeholder: .localized("vat")
    )

    private let billingCountryPicker = CountryPicker()
    private let style: Shift4Style

    init(style: Shift4Style) {
        self.style = style
        super.init(frame: .zero)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        style = Shift4Style()
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        style = Shift4Style()
        super.init(frame: frame)
        commonInit()
    }

    func setup(collectShippingAddress: Bool, collectBillingAddress: Bool) {
        [shippingNameTextField, shippingStreetTextField, shippingZipTextField, shippingCityTextField, shippingCountryTextField, billingTitle, shippingTitle].forEach {
            $0.isHidden = true
        }

        sameAddressSwitch.isHidden = !collectShippingAddress && collectBillingAddress
        sameAddressSwitch.isOn = collectShippingAddress
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if sameAddressSwitch.isOn {
            billingNameTextField.becomeFirstResponder()
        } else {
            shippingNameTextField.becomeFirstResponder()
        }
        return true
    }

    private func commonInit() {
        addArrangedSubview(separator)
        setCustomSpacing(Style.Layout.Padding.big, after: separator)

        addArrangedSubview(sameAddressSwitch)
        setCustomSpacing(Style.Layout.Padding.big, after: sameAddressSwitch)

        addArrangedSubview(shippingTitle)
        addArrangedSubview(shippingNameTextField)
        addArrangedSubview(shippingStreetTextField)
        addArrangedSubview(HorizontalComponent(arrangedSubviews: [shippingZipTextField, shippingCityTextField]))
        addArrangedSubview(shippingCountryTextField)
        setCustomSpacing(Style.Layout.Padding.big, after: shippingCountryTextField)

        addArrangedSubview(billingTitle)
        addArrangedSubview(billingNameTextField)
        addArrangedSubview(billingStreetTextField)
        addArrangedSubview(HorizontalComponent(arrangedSubviews: [billingZipTextField, billingCityTextField]))
        addArrangedSubview(billingCountryTextField)
        addArrangedSubview(billingVatTextField)

        sameAddressSwitch.onChange = { [weak self] useSameAddress in
            guard let self else { return }
            [self.shippingTitle, self.shippingNameTextField, self.shippingStreetTextField, self.shippingZipTextField, self.shippingCityTextField, self.shippingCountryTextField, self.billingTitle].forEach {
                $0.isHidden = useSameAddress
            }
            self.onChange()
        }

        [billingNameTextField, billingStreetTextField, billingZipTextField, billingCityTextField, billingCountryTextField, billingVatTextField, shippingNameTextField, shippingStreetTextField, shippingZipTextField, shippingCityTextField, shippingCountryTextField].forEach {
            $0.delegate = self
        }

        billingCountryTextField.inputView = billingCountryPicker
        shippingCountryTextField.inputView = shipingCountryPicker

        billingCountryTextField.text = billingCountryCode.map { EmojiFlagGenerator.shared.flagWithName(from: $0) }
        shippingCountryTextField.text = shippingCountryCode.map { EmojiFlagGenerator.shared.flagWithName(from: $0) }

        billingCountryPicker.selectRow(EmojiFlagGenerator.shared.currentLocaleIndex(), inComponent: 0, animated: false)
        shipingCountryPicker.selectRow(EmojiFlagGenerator.shared.currentLocaleIndex(), inComponent: 0, animated: false)

        billingCountryPicker.onChange = { [weak self] code, name in
            guard let self else { return }
            self.billingCountryCode = code
            self.billingCountryTextField.text = name
            self.onChange()
        }

        shipingCountryPicker.onChange = { [weak self] code, name in
            guard let self else { return }
            self.shippingCountryCode = code
            self.shippingCountryTextField.text = name
            self.onChange()
        }
    }

    private var shippingFilled: Bool {
        [shippingNameTextField, shippingStreetTextField, shippingZipTextField, shippingCityTextField, shippingCountryTextField].reduce(true) { partialResult, textField in
            partialResult && !(textField.text ?? .empty).isEmpty
        }
    }

    private var billingFilled: Bool {
        [billingNameTextField, billingStreetTextField, billingZipTextField, billingCityTextField, billingCountryTextField].reduce(true) { partialResult, textField in
            partialResult && !(textField.text ?? .empty).isEmpty
        }
    }
}

extension AddressComponent: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if shippingNameTextField.contains(textField: textField) {
            shippingStreetTextField.becomeFirstResponder()
        }
        if shippingStreetTextField.contains(textField: textField) {
            shippingZipTextField.becomeFirstResponder()
        }
        if shippingZipTextField.contains(textField: textField) {
            shippingCityTextField.becomeFirstResponder()
        }
        if shippingCityTextField.contains(textField: textField) {
            shippingCountryTextField.becomeFirstResponder()
        }
        if shippingCountryTextField.contains(textField: textField) {
            billingNameTextField.becomeFirstResponder()
        }
        if billingNameTextField.contains(textField: textField) {
            billingStreetTextField.becomeFirstResponder()
        }
        if billingStreetTextField.contains(textField: textField) {
            billingZipTextField.becomeFirstResponder()
        }
        if billingZipTextField.contains(textField: textField) {
            billingCityTextField.becomeFirstResponder()
        }
        if billingCityTextField.contains(textField: textField) {
            billingCountryTextField.becomeFirstResponder()
        }
        if billingCountryTextField.contains(textField: textField) {
            billingVatTextField.becomeFirstResponder()
        }
        if billingVatTextField.contains(textField: textField) {
            textField.resignFirstResponder()
            resignFirstResponder()
        }

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            onChange()
            return true
        }
        guard let textRange = Range(range, in: text) else { return true }
        let updatedText = text.replacingCharacters(in: textRange, with: string)

        let cursorLocation = textField.position(from: textField.beginningOfDocument, offset: range.location + string.count)
        textField.text = updatedText
        if let cursorLocation {
            textField.selectedTextRange = textField.textRange(from: cursorLocation, to: cursorLocation)
        }
        onChange()
        return false
    }
}
