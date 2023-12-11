import Foundation
import UIKit

final class BottomDrawerViewController: UIViewController {
    private var scrollHeight: NSLayoutConstraint!
    private let scroll = UIScrollView()
    private let container = UIStackView()
    private let contentViewController: UIViewController

    required init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)

        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
        container.addArrangedSubview(contentViewController.view)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        scroll.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(container)
        scrollHeight = scroll.heightAnchor.constraint(equalTo: scroll.contentLayoutGuide.heightAnchor)
        scrollHeight.priority = .fittingSizeLevel

        view.addConstraints([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollHeight,
            container.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            container.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor),
        ])
    }
}
