import Foundation
import UIKit

internal final class CountryPicker: UIPickerView {
    var onChange: (_ code: String, _ name: String) -> Void = { _, _ in }
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CountryPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        Locale.isoRegionCodes.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        EmojiFlagGenerator.shared.flagWithName(from: Locale.isoRegionCodes[row])
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        let code = Locale.isoRegionCodes[row]
        onChange(code, EmojiFlagGenerator.shared.flagWithName(from: code))
    }
}
