import Foundation
import UIKit

final class UserAgentProvider {
    static var userAgent: String {
        short + " " +
            UIDevice.current.model + " " +
            UIDevice.current.systemName + " " +
            ProcessInfo.processInfo.operatingSystemVersionString + " " +
            "CFNetwork " + (cfNetworkVersion ?? .empty)
    }

    static var short: String {
        "com.securionpay.sdk.SecurionPay" + "/" +
            (Bundle.shift4.infoDictionary?["CFBundleShortVersionString"] as? String ?? .empty) +
            "(\(Bundle.shift4.infoDictionary?["CFBundleVersion"] as? String ?? .empty))"
    }

    private static var cfNetworkVersion: String? {
        guard
            let bundle = Bundle(identifier: "com.apple.CFNetwork"),
            let versionAny = bundle.infoDictionary?[kCFBundleVersionKey as String],
            let version = versionAny as? String
        else { return nil }
        return version
    }
}
