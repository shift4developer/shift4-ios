import Foundation
import UIKit

struct DividerViewStyle {
    let color: UIColor
    let margin: CGFloat
}

final class DividerView: UIView {
    init(style: DividerViewStyle) {
        super.init(frame: .zero)
        backgroundColor = .clear

        let divider = UIView()
        addSubview(divider, constraints: [
            divider.heightAnchor.constraint(equalToConstant: 1),
            leadingAnchor.constraint(equalTo: divider.leadingAnchor, constant: -style.margin),
            trailingAnchor.constraint(equalTo: divider.trailingAnchor, constant: style.margin),
            topAnchor.constraint(equalTo: divider.topAnchor),
            bottomAnchor.constraint(equalTo: divider.bottomAnchor),
        ])
        divider.backgroundColor = style.color
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
