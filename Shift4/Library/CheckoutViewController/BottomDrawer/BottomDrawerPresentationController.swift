import Foundation
import UIKit

final class BottomDrawerPresentationController: UIPresentationController {
    private let footer = UIView()
    private var presentedViewBottom: NSLayoutConstraint?
    override func presentationTransitionWillBegin() {
        guard let containerView else { return }
        guard let presentedView = presentedViewController.view else { return }

        presentedView.translatesAutoresizingMaskIntoConstraints = false
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.backgroundColor = Style.Color.inspirationBlue
        containerView.addSubview(presentedView)
        containerView.addSubview(footer)
        containerView.backgroundColor = Style.Color.separator
        presentedViewBottom = presentedView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
        containerView.addConstraints([
            presentedView.topAnchor.constraint(greaterThanOrEqualTo: containerView.safeAreaLayoutGuide.topAnchor),
            presentedViewBottom!,
            presentedView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            footer.topAnchor.constraint(equalTo: presentedView.bottomAnchor),
            footer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            footer.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
        ])

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeKeyboardFrame),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeKeyboardFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func didChangeKeyboardFrame(notification: Notification) {
        guard let keyboardScreenEndFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue else { return }
        guard let containerView else { return }
        guard let presentedViewBottom else { return }

        let frame = containerView.convert(keyboardScreenEndFrame, from: containerView.window)
        let height = containerView.bounds.intersection(frame).height - containerView.safeAreaInsets.bottom
        if notification.name == UIResponder.keyboardWillHideNotification {
            presentedViewBottom.constant = 0
        } else {
            presentedViewBottom.constant = -height
        }

        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration ?? 1.0) {
                containerView.layoutIfNeeded()
            }
        }
    }
}
