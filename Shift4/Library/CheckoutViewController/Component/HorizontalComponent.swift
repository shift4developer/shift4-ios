import Foundation
import UIKit

class HorizontalComponent: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        axis = .horizontal
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .zero
        spacing = Style.Layout.Padding.medium
        distribution = .fillEqually
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        commonInit()
    }
}
