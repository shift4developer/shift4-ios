import Foundation
import UIKit

class VerticalComponent: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        axis = .vertical
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .zero
        spacing = Style.Layout.Padding.medium
    }
}
