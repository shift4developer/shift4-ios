import Foundation
import UIKit

public struct Shift4SwitchStyle {
    public init(labelFont: UIFont, labelTextColor: UIColor, infoLabelFont: UIFont, infoLabelTextColor: UIColor, tintColor: UIColor) {
        self.labelFont = labelFont
        self.labelTextColor = labelTextColor
        self.infoLabelFont = infoLabelFont
        self.infoLabelTextColor = infoLabelTextColor
        self.tintColor = tintColor
    }

    let labelFont: UIFont
    let labelTextColor: UIColor
    let infoLabelFont: UIFont
    let infoLabelTextColor: UIColor
    let tintColor: UIColor
}

public final class Shift4Switch: UIView {
    private let stack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Style.Layout.Padding.compact
        return stack
    }()

    private let container = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private lazy var label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = style.labelFont
        label.textColor = style.labelTextColor
        label.numberOfLines = 0
        return label
    }()

    private lazy var info = {
        let info = UILabel()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.font = style.infoLabelFont
        info.textColor = style.infoLabelTextColor
        info.numberOfLines = 0
        info.isHidden = true
        return info
    }()

    private lazy var enabled = {
        let enabled = UISwitch()
        enabled.translatesAutoresizingMaskIntoConstraints = false
        enabled.onTintColor = style.tintColor
        enabled.addTarget(self, action: #selector(onSwitchChange), for: .valueChanged)
        return enabled
    }()

    public var title: String? {
        set { label.text = newValue }
        get { label.text }
    }

    public var subtitle: String? {
        set {
            info.text = newValue
            info.isHidden = newValue == nil
        }
        get { info.text }
    }

    public var isOn: Bool {
        set { enabled.isOn = newValue }
        get { enabled.isOn }
    }

    public var isEnabled: Bool {
        set { enabled.isEnabled = newValue }
        get { enabled.isEnabled }
    }

    public var switchHidden: Bool {
        set { enabled.isHidden = newValue }
        get { enabled.isHidden }
    }

    override public var accessibilityIdentifier: String? {
        set { enabled.accessibilityIdentifier = newValue }
        get { enabled.accessibilityIdentifier }
    }

    public var onChange: (Bool) -> Void = { _ in }

    private let style: Shift4SwitchStyle

    public init(style: Shift4SwitchStyle) {
        self.style = style
        super.init(frame: .zero)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        addSubview(stack)
        addConstraints([
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        container.addSubview(enabled)
        container.addSubview(label)

        container.addConstraints([
            label.leftAnchor.constraint(equalTo: container.leftAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        container.addConstraints([
            enabled.topAnchor.constraint(equalTo: container.topAnchor),
            enabled.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            enabled.rightAnchor.constraint(equalTo: container.rightAnchor),
            enabled.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 16.0),
        ])
        stack.addArrangedSubview(container)
        stack.addArrangedSubview(info)
    }

    @objc private func onSwitchChange() {
        onChange(enabled.isOn)
    }
}
