import Foundation
import Shift43DS
import UIKit

internal final class ThreeDUICustomizationFactory {
    private let style: Shift4Style

    init(style: Shift4Style) {
        self.style = style
    }

    private func customizeButton(uiCustom: UiCustomization, type: UiCustomization.ButtonType, backgroundColor: UIColor, textColor: UIColor) throws {
        let button = uiCustom.getButtonCustomization(buttonType: type)
        button.setBackgroundColor(backgroundColor)
        try button.setCornerRadius(cornerRadius: Int(style.button.cornerRadius))
        button.setTextColor(textColor)
        try button.setTextFontName(fontName: style.button.font.familyName)
    }

    private func customizeButtons(uiCustom: UiCustomization) throws {
        try customizeButton(
            uiCustom: uiCustom,
            type: .SUBMIT,
            backgroundColor: style.primaryColor,
            textColor: .white
        )

        try customizeButton(
            uiCustom: uiCustom,
            type: .RESEND,
            backgroundColor: .white,
            textColor: style.primaryColor
        )

        try customizeButton(
            uiCustom: uiCustom,
            type: .NEXT,
            backgroundColor: style.successColor,
            textColor: .white
        )

        try customizeButton(
            uiCustom: uiCustom,
            type: .CANCEL,
            backgroundColor: .white,
            textColor: .black
        )

        try customizeButton(
            uiCustom: uiCustom,
            type: .CONTINUE,
            backgroundColor: style.successColor,
            textColor: .white
        )
    }

    func uiCustomization() throws -> UiCustomization {
        let uiCustom = UiCustomization()
        try customizeButtons(uiCustom: uiCustom)

        let labelCustomization = uiCustom.getLabelCustomization()
        labelCustomization.setHeadingTextColor(style.primaryTextColor)
        try labelCustomization.setHeadingTextFontName(fontName: style.font.title.fontName)
        try labelCustomization.setHeadingTextFontSize(fontSize: Int(style.font.title.pointSize))

        labelCustomization.setTextColor(style.primaryTextColor)
        try labelCustomization.setTextFontName(fontName: style.font.body.fontName)
        try labelCustomization.setTextFontSize(fontSize: Int(style.font.body.pointSize))

        let toolbarCustomization = uiCustom.getToolbarCustomization()
        toolbarCustomization.setTextColor(style.primaryTextColor)
        try toolbarCustomization.setButtonText(buttonText: .localized("Cancel")) // TODO: localization
        try toolbarCustomization.setTextFontName(fontName: style.font.body.fontName)
        try toolbarCustomization.setTextFontSize(fontSize: Int(style.font.body.pointSize))
        toolbarCustomization.setBackgroundColor(style.backgroundColor)
        try toolbarCustomization.setHeaderText(headerText: "3D Secure")

        uiCustom.getButtonCustomization(buttonType: .CANCEL).setTextColor(style.primaryColor)

        uiCustom.setBackgroundColor(backgroundColor: style.backgroundColor)

        let textboxCustomization = uiCustom.getTextBoxCustomization()
        textboxCustomization.setTextColor(style.primaryTextColor)

        return uiCustom
    }
}
