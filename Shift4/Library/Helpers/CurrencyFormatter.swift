import Foundation

final class CurrencyFormatter {
    static func format(amount: NSDecimalNumber, code: String, withGroupingSeparator: Bool = true, withCurrencySymbol: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.usesGroupingSeparator = withGroupingSeparator
        var amountToFormat = amount

        if let currency = Currency(rawValue: code) {
            formatter.minimumFractionDigits = currency.minorUnits
            formatter.maximumFractionDigits = currency.minorUnits
            formatter.currencySymbol = withCurrencySymbol ? currency.symbol : ""
            amountToFormat = amountToFormat.dividing(by: NSDecimalNumber(value: currency.minorUnitsFactor))
        }
        let formatted = "\(formatter.string(from: amountToFormat) ?? "")"
        return formatted
    }
}
