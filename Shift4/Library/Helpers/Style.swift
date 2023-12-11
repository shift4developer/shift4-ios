import Foundation
import UIKit

public enum Style {
    public enum Alpha {
        public static let inactive: CGFloat = 0.7
    }

    public enum Layout {
        public static let cornerRadius: CGFloat = 4.0
        public static let borderWidth: CGFloat = 1.0

        public enum Padding {
            public static let extreme: CGFloat = 48.0
            public static let huge: CGFloat = 32.0
            public static let big: CGFloat = 24.0
            public static let standard: CGFloat = 16.0
            public static let medium: CGFloat = 8.0
            public static let compact: CGFloat = 4.0
        }

        public enum Button {
            public static let height: CGFloat = 40.0
        }

        public enum Separator {
            public static let height: CGFloat = 1.0
        }
    }

    public enum Color {
        public static let background = UIColor(light: .white, dark: .black)

        public static let primary = UIColor(light: 0xFF0E_5BF3, dark: 0xFF38_9CFF)
        public static let error = UIColor(light: 0xFFB0_0020, dark: 0xFFEE_3834)
        public static let success = UIColor(argb: 0xFF46_A82E)

        public static let inspirationBlue = UIColor(light: 0xFFEC_F3FE, dark: 0xFF14_1414)

        public static let disabled = UIColor(light: 0x6100_0000, dark: 0xFFC0_C0C0)
        public static let placeholder = UIColor(light: 0x9900_0000, dark: 0xE5FF_FFFF)
        public static let separator = UIColor(light: 0x2900_0000, dark: 0xFF66_6666)

        public static let textPrimary = UIColor(light: .black, dark: .white)
    }

    public enum Font {
        public static var regularlabel: UIFont { UIFont(name: "NunitoSans-Regular", size: 12.0)! }
        public static var label: UIFont { UIFont(name: "NunitoSans-SemiBold", size: 10.0)! }
        public static var error: UIFont { UIFont(name: "NunitoSans-SemiBold", size: 12.0)! }
        public static var body: UIFont { UIFont(name: "NunitoSans-Regular", size: 16.0)! }
        public static var tileLabel: UIFont { UIFont(name: "NunitoSans-SemiBold", size: 14.0)! }
        public static var section: UIFont { UIFont(name: "NunitoSans-Regular", size: 16.0)! }
        public static var button: UIFont { UIFont(name: "NunitoSans-SemiBold", size: 14.0)! }
        public static var title: UIFont { UIFont(name: "NunitoSans-SemiBold", size: 20.0)! }
    }
}
