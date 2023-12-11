import Foundation
import UIKit

public final class FontsLoader {
    public static func loadFontsIfNeeded() {
        let fonts = ["shift4_nunitosans_black", "shift4_nunitosans_regular", "shift4_nunitosans_semibold"]

        let mainBundle = Bundle(for: FontsLoader.self)
        let fontFamilyNames = UIFont.familyNames
        if !fontFamilyNames.contains("NunitoSans") {
            fonts.forEach {
                UIFont.registerFont(bundle: mainBundle, fontName: $0, fontExtension: "ttf")
            }
        }
    }
}
