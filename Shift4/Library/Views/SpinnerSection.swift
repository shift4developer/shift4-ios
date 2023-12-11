import Foundation
import UIKit

final class SpinnerSection: UIView {
    private let spinner = UIActivityIndicatorView()
    private let info = UILabel()

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
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        addConstraints([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.topAnchor.constraint(equalTo: topAnchor, constant: 50),
        ])
        spinner.startAnimating()
        spinner.color = style.placeholderColor
        info.translatesAutoresizingMaskIntoConstraints = false
        addSubview(info)
        info.text = .localized("loading_payment_info")
        info.textAlignment = .center
        info.font = style.font.body
        info.numberOfLines = 0
        info.textColor = style.disabledColor
        addConstraints([
            spinner.bottomAnchor.constraint(equalTo: info.topAnchor, constant: -16),
            info.leftAnchor.constraint(equalTo: leftAnchor),
            info.rightAnchor.constraint(equalTo: rightAnchor),
            info.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }
}
