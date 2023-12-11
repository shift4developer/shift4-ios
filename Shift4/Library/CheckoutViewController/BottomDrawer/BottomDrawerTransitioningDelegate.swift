import Foundation
import UIKit

final class BottomDrawerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    static let shared = BottomDrawerTransitioningDelegate()

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source _: UIViewController) -> UIPresentationController? {
        BottomDrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        BottomDrawerPresentTransition()
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        BottomDrawerDismissTransition()
    }

    private final class BottomDrawerPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
        func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval { 1 }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let from = transitionContext.viewController(forKey: .from) else { return }
            guard let to = transitionContext.viewController(forKey: .to) else { return }

            from.beginAppearanceTransition(false, animated: true)
            transitionContext.containerView.layoutIfNeeded()
            to.view.frame = transitionContext.finalFrame(for: to)
            to.view.frame.origin.y = transitionContext.containerView.frame.height

            let propertyAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: UICubicTimingParameters())
            propertyAnimator.addAnimations {
                transitionContext.containerView.layoutIfNeeded()
                transitionContext.containerView.setNeedsLayout()
            }
            propertyAnimator.addCompletion { _ in
                from.endAppearanceTransition()
                transitionContext.completeTransition(true)
            }
            propertyAnimator.startAnimation()
        }
    }

    private final class BottomDrawerDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
        func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval { 1 }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let from = transitionContext.viewController(forKey: .from) else { return }
            guard let to = transitionContext.viewController(forKey: .to) else { return }

            to.beginAppearanceTransition(true, animated: true)
            let propertyAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: UICubicTimingParameters())
            propertyAnimator.addAnimations {
                from.view.frame.origin.y = transitionContext.containerView.frame.height
            }
            propertyAnimator.addCompletion { _ in
                from.view.removeFromSuperview()
                to.endAppearanceTransition()
                transitionContext.completeTransition(true)
            }
            propertyAnimator.startAnimation()
        }
    }
}
