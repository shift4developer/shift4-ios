import UIKit

public struct Shift4ButtonStyle {
    public init(cornerRadius: CGFloat, height: CGFloat, primaryColor: UIColor, successColor: UIColor, font: UIFont, textColor: UIColor, disabledColor: UIColor) {
        self.cornerRadius = cornerRadius
        self.height = height
        self.primaryColor = primaryColor
        self.successColor = successColor
        self.font = font
        self.textColor = textColor
        self.disabledColor = disabledColor
    }

    let cornerRadius: CGFloat
    let height: CGFloat
    let primaryColor: UIColor
    let successColor: UIColor
    let font: UIFont
    let textColor: UIColor
    let disabledColor: UIColor
}

public final class Shift4Button: UIView {
    public enum State {
        case normal
        case pending
        case finished
    }

    private let button = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let checkmark = UIImageView(image: UIImage.fromBundle(named: "checkmark"))
    private let imageView = UIImageView()
    private let style: Shift4ButtonStyle

    private var buttonLeftAnchor: NSLayoutConstraint?
    private var buttonRightAnchor: NSLayoutConstraint?

    public var title: String? {
        set { button.setTitle(uppercased ? newValue?.uppercased() : newValue, for: .normal) }
        get { button.title(for: .normal) }
    }

    public var image: UIImage? {
        set {
            if !button.isEnabled {
                imageView.alpha = 0.5
            }
        }
        get { imageView.image }
    }

    public var uppercased = true

    public var didTap: (() -> Void)?

    public var enabled: Bool {
        set {
            button.isEnabled = newValue
            updateStyle()
        }
        get { button.isEnabled }
    }

    override public var accessibilityIdentifier: String? {
        set { button.accessibilityIdentifier = newValue }
        get { button.accessibilityIdentifier }
    }

    public init(style: Shift4ButtonStyle) {
        self.style = style
        super.init(frame: .zero)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func changeState(to state: State, animated: Bool = true) {
        switch state {
        case .normal:
            buttonLeftAnchor?.constant = 0
            buttonRightAnchor?.constant = 0
            let transform = {
                self.layoutIfNeeded()
                self.button.layer.cornerRadius = self.style.cornerRadius
                self.button.titleLabel?.alpha = 1
                self.activityIndicator.alpha = 0
                self.button.backgroundColor = self.style.primaryColor
                self.checkmark.alpha = 0
                self.checkmark.transform = CGAffineTransform(scaleX: 0, y: 0)
                self.imageView.alpha = 1
            }
            if animated {
                UIView.animate(withDuration: 0.1) { transform() }
            } else {
                DispatchQueue.main.async { transform() }
            }
            updateStyle()
        case .pending:
            let transform = {
                self.layoutIfNeeded()
                self.button.titleLabel?.alpha = 0
                self.activityIndicator.alpha = 1
                self.activityIndicator.color = .white
                self.button.backgroundColor = self.style.primaryColor
                self.checkmark.alpha = 0
                self.checkmark.transform = CGAffineTransform(scaleX: 0, y: 0)
                self.imageView.alpha = 0
            }
            if animated {
                UIView.animate(withDuration: 0.1) { transform() }
            } else {
                DispatchQueue.main.async { transform() }
            }
        case .finished:
            let transform = {
                self.layoutIfNeeded()
                self.button.titleLabel?.alpha = 0
                self.activityIndicator.alpha = 0
                self.button.backgroundColor = self.style.successColor
                self.checkmark.alpha = 1
                self.checkmark.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.imageView.alpha = 0
            }
            if animated {
                UIView.animate(withDuration: 0.1) { transform() }
            } else {
                DispatchQueue.main.async { transform() }
            }
        }
    }

    private func commonInit() {
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        buttonLeftAnchor = button.leftAnchor.constraint(equalTo: leftAnchor)
        buttonRightAnchor = button.rightAnchor.constraint(equalTo: rightAnchor)

        addConstraints([
            button.topAnchor.constraint(equalTo: topAnchor),
            buttonLeftAnchor!,
            buttonRightAnchor!,
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: style.height),
        ])

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        addConstraints([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        activityIndicator.startAnimating()
        activityIndicator.alpha = 0
        activityIndicator.color = .white

        checkmark.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkmark)
        addConstraints([
            checkmark.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        checkmark.alpha = 0
        checkmark.transform = CGAffineTransform(scaleX: 0, y: 0)

        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.layer.cornerRadius = style.cornerRadius

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addConstraints([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
        ])

        updateStyle()
    }

    private func updateStyle() {
        if button.isEnabled {
            button.backgroundColor = style.primaryColor
            button.titleLabel?.font = style.font
            button.setTitleColor(style.textColor, for: .normal)
            button.setTitleColor(style.textColor.withAlphaComponent(0.5), for: .disabled)
            button.layer.borderWidth = 0
        } else {
            button.backgroundColor = .clear
            button.titleLabel?.font = style.font
            button.setTitleColor(style.disabledColor, for: .normal)
            button.setTitleColor(style.disabledColor, for: .disabled)
            button.layer.borderWidth = 1
            button.layer.borderColor = style.disabledColor.cgColor
        }
    }

    @objc private func didTapButton() {
        didTap?()
    }
}
