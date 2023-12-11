import UIKit

final class Shift4TextField: UITextField {
    private let placeholderLabel = UILabel()
    private let permanentPlaceholderLabel = UILabel()

    private var showAnimating = false
    private var hideAnimating = false
    private var headerVisible = false

    override var text: String? {
        get {
            super.text
        }
        set {
            super.text = newValue
            if let permanentPlaceholder {
                var suffixLength = permanentPlaceholder.count - (text ?? .empty).count
                if suffixLength < 0 { suffixLength = 0 }

                permanentPlaceholderLabel.text = (text ?? .empty) + String(permanentPlaceholder.suffix(suffixLength))
            }
            DispatchQueue.main.async {
                if (newValue ?? .empty).isEmpty, !self.isFirstResponder {
                    self.hideHeader()
                } else {
                    self.showHeader(animated: false)
                }
            }
        }
    }

    override var placeholder: String? {
        set {
            placeholderLabel.text = newValue
        }
        get {
            placeholderLabel.text
        }
    }

    var permanentPlaceholder: String? {
        didSet {
            var suffixLength = (permanentPlaceholder ?? .empty).count - (text ?? .empty).count
            if suffixLength < 0 { suffixLength = 0 }

            permanentPlaceholderLabel.text = (text ?? .empty) + String((permanentPlaceholder ?? .empty).suffix(suffixLength))
            permanentPlaceholderLabel.isHidden = !isFirstResponder || permanentPlaceholder == nil
        }
    }

    var rightImage: UIImage? {
        didSet {
            guard let rightImage = rightImage?.resized(to: CGSize(width: 32, height: 24)) else {
                rightView = nil
                rightViewMode = .never
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.performWithoutAnimation {
                    let imgView = UIImageView(image: rightImage)
                    imgView.bounds = CGRect(x: 0, y: 0, width: 32, height: 24)
                    self.rightView = imgView
                    self.rightViewMode = .always
                }
            }
        }
    }

    var error: Bool = false {
        didSet {
            if error {
                placeholderLabel.textColor = style.errorColor
                return
            }
            placeholderLabel.textColor = style.placeholderColor
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

    required init?(coder: NSCoder) {
        style = Shift4Style()
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(permanentPlaceholderLabel)
        permanentPlaceholderLabel.font = style.font.body
        permanentPlaceholderLabel.textColor = style.separatorColor
        permanentPlaceholderLabel.isHidden = true
        addSubview(placeholderLabel)
        placeholderLabel.font = style.font.body
        placeholderLabel.textColor = style.placeholderColor
        font = style.font.body
        textColor = style.primaryTextColor
    }

    override func layoutSubviews() {
        if !showAnimating, !hideAnimating {
            if !(text ?? .empty).isEmpty || isFirstResponder {
                var new = textRect(forBounds: bounds)
                new.origin.y = -10
                placeholderLabel.frame = new
            } else {
                placeholderLabel.frame = super.textRect(forBounds: bounds)
            }
        }
        permanentPlaceholderLabel.frame = textRect(forBounds: bounds)
        permanentPlaceholderLabel.isHidden = !isFirstResponder
        super.layoutSubviews()
    }

    @discardableResult
    func becomeFirstResponderWithoutAnimation() -> Bool {
        showHeader(animated: false)
        return super.becomeFirstResponder()
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        showHeader(animated: true)
        return super.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        if (text ?? .empty).isEmpty {
            hideHeader()
        }
        placeholderLabel.textColor = style.placeholderColor
        return super.resignFirstResponder()
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: super.intrinsicContentSize.height + 18)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 0, y: 10, width: bounds.width, height: bounds.height)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 0, y: 10, width: bounds.width, height: bounds.height)
    }

    private func showHeader(animated: Bool) {
        let animation = {
            var new = self.textRect(forBounds: self.bounds)
            new.origin.y = -10
            self.placeholderLabel.frame = new
            self.placeholderLabel.textColor = self.style.placeholderColor
            self.placeholderLabel.font = self.style.font.label
            self.permanentPlaceholderLabel.isHidden = false
        }

        if animated {
            if showAnimating { return }
            if headerVisible { return }
            headerVisible = true
            showAnimating = true
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    animation()
                } completion: { _ in
                    self.showAnimating = false
                }
            }
        } else {
            animation()
            headerVisible = true
        }
    }

    private func hideHeader() {
        if hideAnimating { return }
        if !headerVisible { return }
        hideAnimating = true
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.placeholderLabel.frame = super.textRect(forBounds: self.bounds)
                self.placeholderLabel.textColor = self.style.placeholderColor
                self.placeholderLabel.font = self.style.font.body
                self.permanentPlaceholderLabel.isHidden = true
            } completion: { _ in
                self.hideAnimating = false
                self.headerVisible = false
            }
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
