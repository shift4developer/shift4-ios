import Foundation
import UIKit

final class CheckoutViewController: UIViewController {
    private enum Constants {
        static let errorAnimationDuration = 0.3
        static let switchModeAnimationDuration = 0.3
        static let preAnimationAlpha: CGFloat = 0.4
        static let postAnimationAlpha: CGFloat = 1.0
    }

    private enum Mode {
        case donation
        case newCard
        case sms
        case getCheckoutDetails
    }

    private let externalStack = {
        let externalStack = UIStackView()
        externalStack.axis = .vertical
        externalStack.spacing = 0
        externalStack.isLayoutMarginsRelativeArrangement = true
        externalStack.layoutMargins = .zero
        externalStack.axis = .vertical
        return externalStack
    }()

    private let stack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        return stack
    }()

    private let style: Shift4Style
    private lazy var header = HeaderComponent(style: style)
    private let close = UIButton(type: .custom)
    private lazy var emailComponent = EmailComponent(style: style)
    private lazy var cardComponent = CardComponent(style: style)

    private lazy var error = {
        let error = UILabel()
        error.numberOfLines = 0
        error.textColor = style.errorColor
        error.font = style.font.error
        error.isHidden = true
        error.numberOfLines = 0
        error.accessibilityIdentifier = AccessibilityIdentifier.PaymentViewController.errorLabel
        return error
    }()

    private lazy var additionalInfo = {
        let additionalInfo = UILabel()
        additionalInfo.numberOfLines = 0
        additionalInfo.textColor = style.primaryTextColor
        additionalInfo.font = style.font.body
        additionalInfo.isHidden = true
        additionalInfo.numberOfLines = 0
        additionalInfo.textAlignment = .center
        return additionalInfo
    }()

    private lazy var rememberSwitch = Shift4Switch(style: Shift4Style.switchStyle(from: style))
    private lazy var buttonSeparator = UIView()
    private lazy var button = Shift4Button(style: Shift4Style.buttonStyle(from: style))
    private lazy var donationCarousel = DonationCarousel()
    private lazy var spinnerSection = SpinnerSection(style: style)
    private lazy var smsComponent = SMSComponent(style: style)
    private lazy var addressComponent = AddressComponent(style: style)
    private var processing = false
    private var currentCard = CreditCard.empty
    private var mode: Mode
    private var stackTapGestureRecognizer = UITapGestureRecognizer(target: CheckoutViewController.self, action: #selector(didTapGesture))

    private let checkoutRequest: CheckoutRequest
    private let completion: (PaymentResult?, Shift4Error?) -> Void

    private var savedEmail: String?
    private var lastSMS: SMS?
    private var phoneVerified = false
    private var donation: Donation?
    private var subscription: CompleteSubscription?
    private let haptic = UINotificationFeedbackGenerator()
    private let checkoutManager: CheckoutManager
    private let collectShippingAddress: Bool
    private let collectBillingAddress: Bool
    private let initialEmail: String?
    private var lookupDelayTimer: Timer?

    init(checkoutRequest: CheckoutRequest,
         merchantName: String,
         description: String,
         merchantLogo: UIImage?,
         collectShippingAddress: Bool,
         collectBillingAddress: Bool,
         email: String?,
         style: Shift4Style,
         checkoutManager: CheckoutManager,
         completion: @escaping (PaymentResult?, Shift4Error?) -> Void)
    {
        self.checkoutRequest = checkoutRequest
        self.completion = completion
        if checkoutRequest.customDonation != nil || checkoutRequest.donations != nil {
            mode = .donation
        } else if checkoutRequest.subscription != nil {
            mode = .getCheckoutDetails
        } else {
            mode = .newCard
        }
        self.collectBillingAddress = collectBillingAddress
        self.collectShippingAddress = collectShippingAddress
        self.checkoutManager = checkoutManager
        if let email, !email.isEmpty {
            initialEmail = email
        } else {
            initialEmail = nil
        }
        self.style = style
        super.init(nibName: nil, bundle: nil)

        header.configure(merchantName: merchantName, description: description, merchantLogo: merchantLogo)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mode == .newCard {
            if initialEmail != nil {
                cardComponent.cvcBecomeFirstResponderWithoutAnimation()
            } else if Keychain.lastEmail == nil {
                emailComponent.becomeFirstResponderWithoutAnimation()
            }
            lookupIfNeeded()
        }
        if mode == .getCheckoutDetails {
            getCheckoutData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        setupLayout()
        setupAccessibilityIdentifiers()
        setNewCardSectionVisible(mode == .newCard)
        setSMSSectionVisible(mode == .sms)
        setDonationSectionVisible(mode == .donation)
        setAddressSectionVisible(collectBillingAddress || collectShippingAddress)

        emailComponent.value = initialEmail
        switch mode {
        case .getCheckoutDetails:
            showSpinner(hideButton: false)
        case .donation:
            button.title = String.localized("confirm")
            donationCarousel.donations = checkoutRequest.donations ?? []
        case .newCard:
            stackTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapGesture))
            stack.addGestureRecognizer(stackTapGestureRecognizer)
            button.enabled = false
            cardComponent.setError(error: nil)
            updateButtonStatus()
            if Keychain.lastEmail != nil || initialEmail != nil {
                showSpinner(hideButton: false)
            }

        case .sms:
            break
        }
    }

    private func getCheckoutData() {
        showSpinner(hideButton: true)
        checkoutManager.checkoutRequestDetails(checkoutRequest: checkoutRequest) { details, _ in
            if let details {
                self.subscription = details.subscription
                self.hideSpinner()
                self.switchMode(to: .newCard)
                self.lookupIfNeeded()
            } else {
                DispatchQueue.main.async {
                    self.completion(nil, .unknown)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func showSpinner(hideButton: Bool) {
        setRememberSwitchActiveMode(mode: false)
        setTextFieldsEnabled(false, withEmail: false)
        hideErrors()

        emailComponent.isHidden = true
        cardComponent.isHidden = true
        rememberSwitch.isHidden = true
        spinnerSection.isHidden = false
        addressComponent.isHidden = true

        if hideButton {
            button.isHidden = true
        }
    }

    private func hideSpinner() {
        setRememberSwitchActiveMode(mode: true)
        setTextFieldsEnabled(true, withEmail: true)
        hideErrors()

        emailComponent.isHidden = false
        cardComponent.isHidden = false
        rememberSwitch.isHidden = false
        spinnerSection.isHidden = true
        addressComponent.isHidden = !collectBillingAddress && !collectShippingAddress
        button.isHidden = false
    }

    private func lookupIfNeeded() {
        if let lastEmail = Keychain.lastEmail {
            emailComponent.value = lastEmail
            lookup()
        } else if initialEmail != nil {
            lookup()
        }
    }

    private func lookup(silent: Bool = false) {
        guard let email = emailComponent.value else { return }

        if !silent {
            showSpinner(hideButton: false)
        }

        checkoutManager.lookup(email: email) { [weak self] lookupResult, error in
            guard let self else { return }
            if !silent {
                self.button.changeState(to: .normal)
                self.emailComponent.value = email
            }
            if let lookupResult {
                if let phone = lookupResult.phone {
                    self.checkoutManager.sendSMS(email: email) { [weak self] sms, error in
                        guard let self else { return }
                        self.setTextFieldsEnabled(true)
                        if let sms {
                            self.switchMode(to: .sms, animated: false)
                            self.lastSMS = sms
                            self.savedEmail = email
                            self.phoneVerified = phone.verified
                        } else if let error {
                            self.showError(error: error)
                        } else {
                            self.showError(error: .unknown)
                        }
                    }
                } else {
                    self.emailComponent.isHidden = false
                    self.cardComponent.isHidden = false
                    self.rememberSwitch.isHidden = false
                    self.spinnerSection.isHidden = true
                    self.addressComponent.isHidden = !self.collectBillingAddress && !self.collectShippingAddress
                    self.currentCard = CreditCard(card: lookupResult.card)
                    self.cardComponent.currentCard = self.currentCard
                    self.cardComponent.expiration = "••/••"
                    self.savedEmail = email
                    self.emailComponent.value = email
                    self.setTextFieldsEnabled(true)
                    self.setRememberSwitchActiveMode(mode: true)
                    self.rememberSwitch.isOn = true
                    self.cardComponent.cvcBecomeFirstResponderWithoutAnimation()
                    self.updateButtonStatus()
                }
            } else {
                if !silent {
                    self.emailComponent.isHidden = false
                    self.cardComponent.isHidden = false
                    self.rememberSwitch.isHidden = false
                    self.spinnerSection.isHidden = true
                    self.addressComponent.isHidden = !self.collectBillingAddress && !self.collectShippingAddress
                    self.currentCard = .empty
                    self.cardComponent.currentCard = self.currentCard
                    self.cardComponent.expiration = nil
                    self.savedEmail = email
                    self.emailComponent.value = email
                    self.setTextFieldsEnabled(true)
                    self.setRememberSwitchActiveMode(mode: true)
                    self.emailComponent.becomeFirstResponderWithoutAnimation()
                    self.updateButtonStatus()
                }
            }
        }
    }

    @objc private func didTapGesture() {
        view.endEditing(true)
    }

    @objc private func didTapCloseButton() {
        DispatchQueue.main.async {
            self.completion(nil, nil)
        }
        dismiss(animated: true, completion: nil)
    }

    private func processPaymentResult(result: PaymentResult?, error: Shift4Error?) {
        if let error {
            if error.code ?? .unknown == .verificationCodeRequired {
                lookup()
                return
            }
            button.changeState(to: .normal)
            processing = false
            setTextFieldsEnabled(true)
            if mode == .newCard {
                if error.type == .cardError, let code = error.code {
                    switch code {
                    case .invalidNumber, .invalidExpiryMonth, .invalidExpiryYear, .invalidCVC, .incorrectCVC, .expiredCard, .cardDeclined, .lostOrStolen:
                        haptic.notificationOccurred(.warning)
                        updateButtonStatus()
                        UIView.animate(withDuration: Constants.errorAnimationDuration) {
                            self.cardComponent.setError(error: error.localizedMessage())
                        }
                    default:
                        showError(error: error)
                    }
                } else if error.code == .invalidEmail {
                    haptic.notificationOccurred(.warning)
                    updateButtonStatus()
                    UIView.animate(withDuration: Constants.errorAnimationDuration) {
                        self.emailComponent.setError(error: error.localizedMessage().replacingOccurrences(of: "email: ", with: ""))
                    }
                } else {
                    showError(error: error)
                }
            } else {
                showError(error: error)
            }
        } else if let result {
            button.changeState(to: .finished)
            haptic.notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                DispatchQueue.main.async {
                    self.completion(result, nil)
                }
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            processing = false
            setTextFieldsEnabled(true)
            button.changeState(to: .normal)
        }
    }

    private func showError(error: Shift4Error) {
        haptic.notificationOccurred(.error)
        UIView.animate(withDuration: Constants.errorAnimationDuration) {
            self.stack.setCustomSpacing(48, after: self.buttonSeparator)
            self.error.isHidden = false
            self.error.text = error.localizedMessage()
        }
        updateButtonStatus()
    }

    private func didTapButton() {
        if mode == .donation {
            donation = donationCarousel.current
            switchMode(to: .newCard)
            return
        }

        if mode == .sms {
            switchMode(to: .newCard)
            setRememberSwitchActiveMode(mode: true)
            rememberSwitch.isOn = checkoutRequest.rememberMe
            return
        }

        guard !processing else { return }
        processing = true

        hideErrors()
        setTextFieldsEnabled(false)

        let components = cardComponent.expiration?.components(separatedBy: "/")
        let tokenRequest = TokenRequest(
            number: cardComponent.currentCard.readable,
            expirationMonth: components?.first ?? "",
            expirationYear: components?.last ?? "",
            cvc: cardComponent.cvc ?? ""
        )
        button.changeState(to: .pending)

        if let savedEmail {
            checkoutManager.savedToken(email: savedEmail) { [weak self] token, error in
                guard let self else { return }

                if let token {
                    self.checkoutManager.pay(
                        token: token,
                        checkoutRequest: self.checkoutRequest,
                        email: savedEmail,
                        remember: true,
                        cvc: self.cardComponent.cvc ?? "",
                        sms: self.lastSMS,
                        amount: self.donation?.amount ?? self.subscription?.plan.amount,
                        currency: self.donation?.currency ?? self.subscription?.plan.currency,
                        shipping: self.addressComponent.shipping,
                        billing: self.addressComponent.billing,
                        navigationControllerFor3DS: self
                    ) { [weak self] result, error in
                        Keychain.lastEmail = result != nil ? savedEmail : nil
                        if error != nil {
                            self?.savedEmail = nil
                            self?.cardComponent.clean()
                            self?.currentCard = .empty
                            self?.setRememberSwitchActiveMode(mode: true)
                        }
                        self?.processPaymentResult(result: result, error: error)
                    }
                } else if let error {
                    self.showError(error: error)
                    self.setTextFieldsEnabled(true)
                    self.button.changeState(to: .normal)
                    self.processing = false
                } else {
                    self.setTextFieldsEnabled(true)
                    self.button.changeState(to: .normal)
                    self.processing = false
                }
            }
            return
        }
        checkoutManager.pay(
            tokenRequest: tokenRequest,
            checkoutRequest: checkoutRequest,
            email: emailComponent.value ?? "",
            remember: rememberSwitch.isOn,
            amount: donation?.amount ?? subscription?.plan.amount,
            currency: donation?.currency ?? subscription?.plan.currency,
            shipping: addressComponent.shipping,
            billing: addressComponent.billing,
            navigationControllerFor3DS: self
        ) { [weak self] result, error in
            guard let self else { return }
            if let _ = result, self.rememberSwitch.isOn {
                Keychain.lastEmail = self.emailComponent.value
            }
            self.processPaymentResult(result: result, error: error)
        }
    }

    private func verifySMS() {
        let code = smsComponent.code
        guard code.count == 6 else { return }
        guard let lastSMS else { return }

        checkoutManager.verifySMS(code: code, sms: lastSMS) { [weak self] response, error in
            guard let self else { return }
            if let card = response?.card {
                self.currentCard = CreditCard(card: card)
                self.cardComponent.currentCard = self.currentCard
                self.setRememberSwitchActiveMode(mode: false)
                self.processing = false
                if self.phoneVerified {
                    self.cardComponent.expiration = "••/••"
                    self.cardComponent.cvc = "•••"
                } else {
                    self.cardComponent.expiration = "••/••"
                    self.cardComponent.cvc = nil
                }
                self.switchMode(to: .newCard)
                self.updateButtonStatus()
            } else if let error {
                if error.code != .invalidVerificationCode {
                    self.showError(error: error)
                }
                self.smsComponent.error()
            } else {
                self.showError(error: .unknown)
                self.smsComponent.error()
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    private func switchMode(to mode: Mode, animated: Bool = true) {
        self.mode = mode
        switch mode {
        case .donation, .getCheckoutDetails:
            break
        case .newCard:
            setNewCardSectionAlpha(Constants.preAnimationAlpha)
            if let donation {
                button.title = "\(String.localized("pay")) \(donation.readable)"
            } else if let subscription {
                button.title = "\(String.localized("pay")) \(subscription.readable)"
            } else {
                button.title = "\(String.localized("pay")) \(checkoutRequest.readable)"
            }
            hideSpinner()
        case .sms:
            spinnerSection.isHidden = true
            setSMSSectionAlpha(Constants.preAnimationAlpha)
            button.title = String.localized("enter_card_details")
            additionalInfo.text = String.localized("no_code_info")
        }
        updateButtonStatus()
        view.layoutIfNeeded()

        UIView.animate(withDuration: animated ? Constants.switchModeAnimationDuration : 0) {
            self.hideErrors()
            self.updateStack()
        } completion: { _ in
            if self.mode == .sms {
                _ = self.smsComponent.becomeFirstResponder()
            }
        }
    }

    private func updateStack() {
        setNewCardSectionVisible(mode == .newCard)
        setSMSSectionVisible(mode == .sms)
        setDonationSectionVisible(mode == .donation)
        setNewCardSectionAlpha(mode == .newCard ? Constants.postAnimationAlpha : 0.0)
        setSMSSectionAlpha(mode == .sms ? Constants.postAnimationAlpha : 0.0)

        switch mode {
        case .getCheckoutDetails:
            break
        case .donation: break
        case .newCard:
            stackTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapGesture))
            stack.addGestureRecognizer(stackTapGestureRecognizer)
            stack.setCustomSpacing(24, after: emailComponent)
            if (emailComponent.value ?? .empty).isEmpty {
                emailComponent.becomeFirstResponderWithoutAnimation()
            } else if (cardComponent.currentCard.readable).isEmpty {
                cardComponent.becomeFirstResponderWithoutAnimation()
            } else if (cardComponent.cvc ?? .empty).isEmpty {
                cardComponent.cvcBecomeFirstResponderWithoutAnimation()
            } else {
                view.endEditing(true)
            }
            updateButtonStatus()
            setRememberSwitchActiveMode(mode: savedEmail == nil)
        case .sms:
            view.endEditing(true)
            smsComponent.clear()
            stack.removeGestureRecognizer(stackTapGestureRecognizer)
            updateButtonStatus()
        }
    }

    private func setTextFieldsEnabled(_ enabled: Bool, withEmail: Bool = true) {
        if withEmail {
            emailComponent.isEnabled = enabled
        }
        cardComponent.isEnabled = enabled
        rememberSwitch.isEnabled = enabled
        close.isEnabled = enabled
    }

    private func setNewCardSectionAlpha(_ alpha: CGFloat) {
        emailComponent.alpha = alpha
        cardComponent.alpha = alpha
        rememberSwitch.alpha = alpha
        buttonSeparator.alpha = alpha
    }

    private func setSMSSectionAlpha(_ alpha: CGFloat) {
        smsComponent.alpha = alpha
        additionalInfo.alpha = alpha
    }

    private func setNewCardSectionVisible(_ visible: Bool) {
        emailComponent.isHidden = !visible
        cardComponent.isHidden = !visible
        rememberSwitch.isHidden = !visible
        buttonSeparator.isHidden = !visible
    }

    private func setSMSSectionVisible(_ visible: Bool) {
        smsComponent.isHidden = !visible
        additionalInfo.isHidden = !visible
    }

    private func setDonationSectionVisible(_ visible: Bool) {
        donationCarousel.isHidden = !visible
    }

    private func setAddressSectionVisible(_ visible: Bool) {
        addressComponent.isHidden = !visible
    }

    private func setRememberSwitchActiveMode(mode _: Bool) {
        rememberSwitch.title = String.localized("save_for_future_payments")
        rememberSwitch.isHidden = false
        additionalInfo.text = nil
        additionalInfo.isHidden = true
    }
}

extension CheckoutViewController {
    private func setupLayout() {
        view.backgroundColor = style.backgroundColor

        setupScroll()
        setupCloseButton()
        setupCardSection()
        spinnerSection.isHidden = true
        setupSMSSection()
        setupButton()
        setupStack()
        setupAddress()
    }

    private func setupScroll() {
        externalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(externalStack)
        view.addConstraints([
            externalStack.leftAnchor.constraint(equalTo: view.leftAnchor),
            externalStack.topAnchor.constraint(equalTo: view.topAnchor),
            externalStack.rightAnchor.constraint(equalTo: view.rightAnchor),
            externalStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupCloseButton() {
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(UIImage.fromBundle(named: "close"), for: .normal)
        close.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        header.addSubview(close)
        header.addConstraints([
            close.heightAnchor.constraint(equalToConstant: 88),
            close.widthAnchor.constraint(equalToConstant: 70),
            close.topAnchor.constraint(equalTo: header.topAnchor, constant: -10),
            close.rightAnchor.constraint(equalTo: header.rightAnchor, constant: 0),
        ])
    }

    private func setupCardSection() {
        setupEmailComponent()
        setupCardComponent()
        setupRememberSwitch()
    }

    private func setupEmailComponent() {
        emailComponent.didReturn = { [weak self] in
            self?.cardComponent.becomeFirstResponder()
        }

        emailComponent.didChange = { [weak self] _ in
            guard let self else { return }
            if let email = self.emailComponent.value, EmailValidator.isValid(email: email) {
                self.lookupDelayTimer?.invalidate()
                self.lookupDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
                    self?.lookup(silent: true)
                }
            }
            if self.savedEmail != nil {
                self.currentCard = CreditCard()
                self.savedEmail = nil
                self.cardComponent.clean()
                self.setRememberSwitchActiveMode(mode: true)
                self.phoneVerified = false
                self.rememberSwitch.isOn = false
            }
            self.updateButtonStatus()
        }
    }

    private func setupCardComponent() {
        cardComponent.didChangeNumber = { [weak self] in
            guard let self else { return }
            if self.savedEmail != nil {
                self.currentCard = CreditCard()
                self.savedEmail = nil
                self.cardComponent.clean()
                self.setRememberSwitchActiveMode(mode: true)
                self.phoneVerified = false
                self.rememberSwitch.isOn = false
            }
            self.updateButtonStatus()
        }
        cardComponent.didChangeExpiration = { [weak self] in
            guard let self else { return }
            if self.savedEmail != nil {
                self.currentCard = CreditCard()
                self.savedEmail = nil
                self.cardComponent.clean()
                self.setRememberSwitchActiveMode(mode: true)
                self.phoneVerified = false
                self.rememberSwitch.isOn = false
            }
            self.updateButtonStatus()
        }
        cardComponent.didChangeCVC = { [weak self] in
            guard let self else { return }
            if self.savedEmail != nil, self.phoneVerified {
                self.currentCard = CreditCard()
                self.savedEmail = nil
                self.cardComponent.clean()
                self.setRememberSwitchActiveMode(mode: true)
                self.phoneVerified = false
                self.rememberSwitch.isOn = false
            }
            self.updateButtonStatus()
        }
        cardComponent.didReturn = { [weak self] in
            guard let self else { return }
            if self.collectBillingAddress || self.collectShippingAddress {
                self.addressComponent.becomeFirstResponder()
            }
        }
    }

    private func setupSMSSection() {
        smsComponent.delegate = self
        smsComponent.isHidden = true
    }

    private func setupRememberSwitch() {
        rememberSwitch.title = String.localized("save_for_future_payments")
        rememberSwitch.isOn = checkoutRequest.rememberMe
        rememberSwitch.subtitle = String.localized("shift4_safely_stores")
    }

    private func setupButton() {
        buttonSeparator.addConstraint(buttonSeparator.heightAnchor.constraint(equalToConstant: Style.Layout.Separator.height))
        buttonSeparator.backgroundColor = style.separatorColor

        button.title = "\(String.localized("pay")) \(checkoutRequest.readable)"
        button.didTap = { [weak self] in self?.didTapButton() }
    }

    private func setupAddress() {
        guard collectBillingAddress || collectShippingAddress else { return }

        addressComponent.setup(collectShippingAddress: collectShippingAddress, collectBillingAddress: collectBillingAddress)
        addressComponent.onChange = { [weak self] in
            self?.updateButtonStatus()
        }
    }

    private func setupStack() {
        externalStack.addArrangedSubview(header)
        externalStack.addArrangedSubview(stack)
        externalStack.addArrangedSubview(BottomBarComponent())

        stack.addArrangedSubview(donationCarousel)
        stack.addArrangedSubview(emailComponent)
        stack.addArrangedSubview(cardComponent)
        stack.addArrangedSubview(addressComponent)
        stack.addArrangedSubview(spinnerSection)
        stack.addArrangedSubview(smsComponent)
        stack.addArrangedSubview(buttonSeparator)
        stack.addArrangedSubview(rememberSwitch)
        stack.addArrangedSubview(error)
        stack.addArrangedSubview(additionalInfo)
        stack.addArrangedSubview(button)

        stack.setCustomSpacing(Style.Layout.Padding.standard, after: header)
        stack.setCustomSpacing(Style.Layout.Padding.big, after: cardComponent)
        stack.setCustomSpacing(Style.Layout.Padding.big, after: emailComponent)
        stack.setCustomSpacing(Style.Layout.Padding.medium, after: error)
        stack.setCustomSpacing(Style.Layout.Padding.extreme, after: buttonSeparator)
        stack.setCustomSpacing(Style.Layout.Padding.medium, after: additionalInfo)
        stack.setCustomSpacing(Style.Layout.Padding.standard, after: rememberSwitch)
        stack.setCustomSpacing(44, after: smsComponent)
        stack.setCustomSpacing(Style.Layout.Padding.standard, after: addressComponent)
        externalStack.setCustomSpacing(Style.Layout.Padding.standard, after: stack)
    }
}

extension CheckoutViewController {
    private func updateButtonStatus() {
        if mode == .sms {
            button.enabled = true
            return
        }
        button.enabled = false
        if mode == .newCard {
            button.enabled =
                !(cardComponent.currentCard.readable).isEmpty &&
                !(cardComponent.expiration ?? .empty).isEmpty &&
                !(cardComponent.cvc ?? .empty).isEmpty &&
                !(emailComponent.value ?? .empty).isEmpty &&
                (!collectBillingAddress || addressComponent.billing != nil) &&
                (!collectShippingAddress || addressComponent.shipping != nil)
        }
    }

    private func hideErrors() {
        error.text = nil
        error.isHidden = true

        emailComponent.setError(error: nil)
        cardComponent.setError(error: nil)

        stack.setCustomSpacing(Style.Layout.Padding.big, after: emailComponent)
    }

    private func setupAccessibilityIdentifiers() {
        view.accessibilityIdentifier = AccessibilityIdentifier.PaymentViewController.identifier

        button.accessibilityIdentifier = AccessibilityIdentifier.PaymentViewController.button
        close.accessibilityIdentifier = AccessibilityIdentifier.PaymentViewController.closeButton
        rememberSwitch.accessibilityIdentifier = AccessibilityIdentifier.PaymentViewController.rememberSwitch
    }
}

extension CheckoutViewController: SMSCodeTextFieldDelegate {
    func didEnterCode(code _: String) {
        verifySMS()
    }
}
