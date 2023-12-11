import Foundation
import UIKit

final class ErrorLabel: UILabel {
    init(accessibilityIdentifier: String, style: Shift4Style) {
        self.style = style
        super.init(frame: .zero)
        self.accessibilityIdentifier = accessibilityIdentifier
        commonInit()
    }

    var onChange: (Bool) -> Void = { _ in }

    private let style: Shift4Style

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
        font = style.font.error
        textColor = style.errorColor
        numberOfLines = 0
    }
}
