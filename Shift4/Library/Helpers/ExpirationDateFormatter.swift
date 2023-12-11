import Foundation

final class ExpirationDateFormatter {
    struct Result {
        let text: String?
        let placeholder: String?
        let resignFocus: Bool

        static var empty: Result { Result(text: "", placeholder: "MM/YY", resignFocus: false) }
    }

    private static let defaultPlaceholder = "MM/YY"
    private static let extendedPlaceholder = "MM/YYYY"

    static func format(inputText: String, backspace: Bool) -> Result {
        guard !inputText.isEmpty else { return .empty }

        let components = inputText.components(separatedBy: "/").filter { !$0.isEmpty }

        if let oneElementResult = ExpirationDateFormatter.handleSingleComponentIfPossible(components: components, backspace: backspace) {
            return oneElementResult
        }

        if let twoElementsResult = ExpirationDateFormatter.handleTwoComponentsIfPossible(components: components) {
            return twoElementsResult
        }

        return ExpirationDateFormatter.reformattedExpirationDate(inputText: inputText, backspace: backspace)
    }

    private static func handleSingleComponentIfPossible(components: [String], backspace: Bool) -> Result? {
        guard components.count == 1 else { return nil }
        let month = components[0]

        if backspace {
            return Result(text: String(month.prefix(2)), placeholder: ExpirationDateFormatter.defaultPlaceholder, resignFocus: false)
        }

        guard month.count < 3 else { return nil }

        let monthInt = Int(month) ?? 0

        if monthInt == 0 {
            return Result(text: "0", placeholder: defaultPlaceholder, resignFocus: false)
        }

        if monthInt == 1 {
            if month.count == 2 {
                return Result(text: "01/", placeholder: defaultPlaceholder, resignFocus: false)
            } else {
                return Result(text: "1", placeholder: defaultPlaceholder, resignFocus: false)
            }
        }

        if monthInt > 1, monthInt < 10 {
            return Result(text: "0\(monthInt)/", placeholder: defaultPlaceholder, resignFocus: false)
        }

        if monthInt > 12 {
            return Result(text: "1", placeholder: defaultPlaceholder, resignFocus: false)
        }

        return nil
    }

    private static func handleTwoComponentsIfPossible(components: [String]) -> Result? {
        guard components.count == 2 else { return nil }

        let rawMonth = components[0]
        let year = components[1]

        guard rawMonth.count <= 2 else {
            let firstDigitValue = Int(components[0].prefix(1)) ?? 0
            let canMonthBeDoubleDigit = firstDigitValue <= 1
            let firstDigitFormatted = (canMonthBeDoubleDigit ? "" : "0") + String(firstDigitValue) + (canMonthBeDoubleDigit ? "" : "/")

            return Result(text: firstDigitFormatted, placeholder: defaultPlaceholder, resignFocus: false)
        }

        let month = components[0].prefix(2)
        let monthInt = Int(month) ?? 0

        let incompleteMonthValue = month.count == 1
        if incompleteMonthValue {
            if monthInt == 0 {
                return Result(text: "0", placeholder: defaultPlaceholder, resignFocus: false)
            } else {
                return Result(text: "0\(monthInt)/\(year)", placeholder: defaultPlaceholder, resignFocus: false)
            }
        }

        if year == "0" {
            return Result(text: String(month), placeholder: defaultPlaceholder, resignFocus: false)
        }

        if year.first ?? "0" == "0" {
            if monthInt <= 1 {
                return Result(text: String(monthInt), placeholder: defaultPlaceholder, resignFocus: false)
            } else if monthInt < 10 || monthInt >= 20 {
                return Result(text: "0" + String(monthInt).prefix(1) + "/", placeholder: defaultPlaceholder, resignFocus: false)
            } else if monthInt <= 12 {
                return Result(text: String(monthInt).prefix(2) + "/", placeholder: defaultPlaceholder, resignFocus: false)
            } else if monthInt < 20 {
                return Result(text: "1", placeholder: defaultPlaceholder, resignFocus: false)
            }
        }

        return nil
    }

    private static func reformattedExpirationDate(inputText: String, backspace _: Bool) -> Result {
        var updatedExpiration = inputText.replacingOccurrences(of: "/", with: "")
        var placeholder: String? = defaultPlaceholder
        var resignFocus = false

        updatedExpiration.insert("/", at: updatedExpiration.index(updatedExpiration.startIndex, offsetBy: 2))
        let components = updatedExpiration.components(separatedBy: "/")
        if let lastString = components.last, let year = Int(lastString), components.count == 2 {
            if year <= 1 {
                updatedExpiration.removeLast()
            } else if year == 20 {
                placeholder = extendedPlaceholder
            } else if year > 100 && year < 1000 && (year < 202 || year > 210) {
                updatedExpiration.removeLast()
                placeholder = defaultPlaceholder
            } else if year > 1000 && year < 2021 {
                updatedExpiration.removeLast()
                placeholder = extendedPlaceholder
            }
            if year > 20 && year < 100 && updatedExpiration.count >= 5 {
                resignFocus = true
            }
            if year == 20 || (year >= 202 && year <= 209) {
                placeholder = extendedPlaceholder
            }
        }

        if updatedExpiration.count >= 7 {
            resignFocus = true
            placeholder = extendedPlaceholder
            updatedExpiration = String(updatedExpiration.prefix(7))
        }

        return Result(text: updatedExpiration, placeholder: placeholder, resignFocus: resignFocus)
    }
}
