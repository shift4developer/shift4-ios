import Foundation
import UIKit

enum DeviceType {
    case phonePortrait
    case phoneLandscape
    case ipadPortrait
    case ipadLandscape

    static var current: DeviceType {
        if UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height {
            return UIDevice.current.userInterfaceIdiom == .phone ? phonePortrait : ipadPortrait
        } else {
            return UIDevice.current.userInterfaceIdiom == .phone ? phoneLandscape : ipadLandscape
        }
    }
}
