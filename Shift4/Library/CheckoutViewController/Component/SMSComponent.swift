import Foundation
import UIKit

class SMSComponent: VerticalComponent {
    private let smsInfo = UILabel()
    private let smsInfoTitle = UILabel()
    private let smsInfoImage = UIImageView(image: .fromBundle(named: "locker_dark"))
    private let smsCode = SMSCodeTextField()

    var code: String { smsCode.code }

    weak var delegate: SMSCodeTextFieldDelegate? {
        get { smsCode.delegate }
        set { smsCode.delegate = newValue }
    }

    private let style: Shift4Style

    init(style: Shift4Style) {
        self.style = style
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        style = Shift4Style()
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        style = Shift4Style()
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        smsInfoImage.contentMode = .center
        smsInfoTitle.font = style.font.section
        smsInfoTitle.text = .localized("unlock_card_details")
        smsInfoTitle.textAlignment = .center
        smsInfoTitle.textColor = style.primaryTextColor
        smsInfo.textColor = style.disabledColor
        smsInfo.font = style.font.body
        smsInfo.textAlignment = .center
        smsInfo.numberOfLines = 0
        smsInfo.text = .localized("sms_code_info")

        addArrangedSubview(smsInfoImage)
        addArrangedSubview(smsInfoTitle)
        addArrangedSubview(smsInfo)
        addArrangedSubview(smsCode)

        setCustomSpacing(8, after: smsInfoImage)
        setCustomSpacing(8, after: smsInfoTitle)
        setCustomSpacing(44, after: smsInfo)
    }

    func clear() {
        smsCode.clear()
    }

    func error() {
        smsCode.error()
    }

    override func becomeFirstResponder() -> Bool {
        smsCode.becomeFirstResponder()
    }
}
