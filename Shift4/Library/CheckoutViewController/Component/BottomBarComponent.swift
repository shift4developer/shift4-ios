import Foundation
import UIKit

class BottomBarComponent: UIView {
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
        backgroundColor = Style.Color.inspirationBlue
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            heightAnchor.constraint(equalToConstant: 48.0),
        ])

        let bottomSeparatorLabel = UILabel()
        bottomSeparatorLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorLabel.font = Style.Font.regularlabel
        bottomSeparatorLabel.textColor = style.primaryTextColor
        bottomSeparatorLabel.text = "Powered by"
        addSubview(bottomSeparatorLabel)
        addConstraints([
            bottomSeparatorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            bottomSeparatorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
        ])
        let bottomLogo = UIImageView(image: .fromBundle(named: "shift4logo"))
        bottomLogo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLogo)
        addConstraints([
            bottomLogo.leftAnchor.constraint(equalTo: bottomSeparatorLabel.rightAnchor, constant: 8),
            bottomLogo.centerYAnchor.constraint(equalTo: bottomSeparatorLabel.centerYAnchor, constant: -1),
        ])
    }
}
