import Foundation
import UIKit

extension Bundle {
    static var shift4: Bundle {
        #if DEBUG
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                return Bundle(for: Shift4SDK.self)
            }
        #endif

        let mainBundle = Bundle(for: Shift4SDK.self)
        if let debugBundle = mainBundle.url(forResource: "SecurionPayDebugBundle", withExtension: "bundle") {
            return Bundle(url: debugBundle) ?? mainBundle
        } else if let releaseBundle = mainBundle.url(forResource: "SecurionPayReleaseBundle", withExtension: "bundle") {
            return Bundle(url: releaseBundle) ?? mainBundle
        } else {
            return mainBundle
        }
    }
}

extension UIImage {
    static func fromBundle(light: String, dark: String, traits: UITraitCollection) -> UIImage? {
        .fromBundle(named: traits.userInterfaceStyle == .dark ? dark : light)
    }

    static func fromBundle(named image: String) -> UIImage? {
        UIImage(named: image, in: Bundle.shift4, compatibleWith: nil)
    }
}
