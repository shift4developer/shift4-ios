import Foundation
import UIKit

class HeaderComponent: UIView {
    private let logo = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let separator = UIView()

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

    func configure(merchantName: String, description: String, merchantLogo: UIImage?) {
        titleLabel.text = merchantName
        descriptionLabel.text = description
        logo.image = merchantLogo ?? UIImage.fromBundle(named: "checkout_logo")
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(logo)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(separator)

        logo.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            logo.heightAnchor.constraint(equalToConstant: 40.0),
            logo.widthAnchor.constraint(equalToConstant: 40.0),
            logo.topAnchor.constraint(equalTo: topAnchor, constant: Style.Layout.Padding.standard),
            logo.leftAnchor.constraint(equalTo: leftAnchor, constant: Style.Layout.Padding.standard),
        ])

        titleLabel.font = style.font.label
        titleLabel.textColor = style.primaryTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            titleLabel.leftAnchor.constraint(equalTo: logo.rightAnchor, constant: Style.Layout.Padding.standard),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Style.Layout.Padding.standard),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Style.Layout.Padding.standard),
        ])
        titleLabel.accessibilityIdentifier = AccessibilityIdentifier.PaymentViewController.titleLabel

        descriptionLabel.font = style.font.title
        descriptionLabel.textColor = style.primaryTextColor
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            descriptionLabel.leftAnchor.constraint(equalTo: logo.rightAnchor, constant: Style.Layout.Padding.standard),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Style.Layout.Padding.standard),
        ])
        descriptionLabel.accessibilityIdentifier = AccessibilityIdentifier.PaymentViewController.titleLabel

        separator.backgroundColor = style.separatorColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            separator.heightAnchor.constraint(equalToConstant: Style.Layout.Separator.height),
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: Style.Layout.Padding.big),
            separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -Style.Layout.Padding.big),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
        addConstraints([heightAnchor.constraint(equalToConstant: 72.0)])
    }
}
