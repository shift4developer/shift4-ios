import Foundation
import UIKit

final class DonationCell: UICollectionViewCell {
    private let card = UIView()
    private let amount = UILabel()
    private let shadowLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func configure(with amount: String, current: Bool) {
        accessibilityIdentifier = AccessibilityIdentifier.PaymentViewController.donationCell(with: amount)
        self.amount.text = amount
        if current {
            card.layer.borderWidth = 1
            card.layer.borderColor = Style.Color.primary.cgColor
            shadowLayer.shadowColor = Style.Color.primary.cgColor
            shadowLayer.shadowOpacity = 0.3
        } else {
            card.layer.borderWidth = 0
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowOpacity = 0.1
        }
    }

    private func commonInit() {
        backgroundColor = .white
        card.layer.cornerRadius = 5.0

        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor

        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 5

        card.layer.insertSublayer(shadowLayer, at: 0)

        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        addSubview(card)
        addConstraints([
            card.topAnchor.constraint(equalTo: topAnchor),
            card.leftAnchor.constraint(equalTo: leftAnchor),
            card.rightAnchor.constraint(equalTo: rightAnchor),
            card.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        amount.text = "$0"
        amount.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(amount)
        addConstraints([
            amount.leftAnchor.constraint(equalTo: card.leftAnchor, constant: Style.Layout.Padding.medium),
            amount.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -Style.Layout.Padding.medium),
            amount.centerYAnchor.constraint(equalTo: card.centerYAnchor),
        ])
        amount.font = Style.Font.title
        amount.textAlignment = .center
        amount.textColor = Style.Color.primary
    }
}
