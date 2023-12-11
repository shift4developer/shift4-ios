import Foundation
import UIKit

internal extension UIColor {
    convenience init(argb: UInt) {
        self.init(
            red: CGFloat((argb & 0x00FF_0000) >> 16) / 255.0,
            green: CGFloat((argb & 0x0000_FF00) >> 8) / 255.0,
            blue: CGFloat(argb & 0x0000_00FF) / 255.0,
            alpha: CGFloat((argb & 0xFF00_0000) >> 24) / 255.0
        )
    }

    func colorWithBrightness(brightness: CGFloat) -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            brightness += (brightness - 1.0)
            brightness = max(min(brightness, 1.0), 0.0)

            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        return self
    }

    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, *) {
            self.init {
                $0.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            self.init(cgColor: light.cgColor)
        }
    }

    convenience init(light: UInt, dark: UInt) {
        if #available(iOS 13.0, *) {
            self.init {
                $0.userInterfaceStyle == .dark ? UIColor(argb: dark) : UIColor(argb: light)
            }
        } else {
            self.init(cgColor: UIColor(argb: light).cgColor)
        }
    }
}
