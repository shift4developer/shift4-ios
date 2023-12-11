import Foundation
import UIKit

@objc(S4Style)
public final class Shift4Style: NSObject {
    override internal init() {
        super.init()
    }

    @objc(S4StyleButton)
    public final class Button: NSObject {
        public var cornerRadius: CGFloat = Style.Layout.cornerRadius
        public var height: CGFloat = Style.Layout.Button.height
        public var font: UIFont = Style.Font.button

        public var textColor: UIColor = .white
    }

    @objc(S4StyleFont)
    public final class Font: NSObject {
        public var regularlabel: UIFont = Style.Font.regularlabel
        public var label: UIFont = Style.Font.label
        public var error: UIFont = Style.Font.error
        public var body: UIFont = Style.Font.body
        public var tileLabel: UIFont = Style.Font.tileLabel
        public var section: UIFont = Style.Font.section
        public var title: UIFont = Style.Font.title
    }

    public var backgroundColor: UIColor = Style.Color.background
    public var primaryColor: UIColor = Style.Color.primary
    public var successColor: UIColor = Style.Color.success
    public var errorColor: UIColor = Style.Color.error

    public var primaryTextColor: UIColor = Style.Color.textPrimary
    public var placeholderColor: UIColor = Style.Color.placeholder
    public var disabledColor: UIColor = Style.Color.disabled
    public var separatorColor: UIColor = Style.Color.separator

    public var button = Button()
    public var font = Font()

    static func buttonStyle(from style: Shift4Style = Shift4Style()) -> Shift4ButtonStyle {
        Shift4ButtonStyle(cornerRadius: style.button.cornerRadius, height: style.button.height, primaryColor: style.primaryColor, successColor: style.successColor, font: style.button.font, textColor: style.button.textColor, disabledColor: style.disabledColor)
    }

    static func switchStyle(from style: Shift4Style = Shift4Style()) -> Shift4SwitchStyle {
        Shift4SwitchStyle(labelFont: style.font.body, labelTextColor: style.primaryTextColor, infoLabelFont: style.font.regularlabel, infoLabelTextColor: style.placeholderColor, tintColor: style.primaryColor)
    }
}
