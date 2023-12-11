import Foundation
import UIKit

public extension UIView {
    func addSubview(_ subview: UIView, constraints: [NSLayoutConstraint]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        addConstraints(constraints)
    }

    func addSubviewAndPinToEdges(_ subview: UIView, pinToSafeArea: Bool = false) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        if pinToSafeArea {
            addConstraints([
                subview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        } else {
            addConstraints([
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.topAnchor.constraint(equalTo: topAnchor),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
    }
}
