import Foundation

internal struct EmojiFlagGenerator {
    static let shared = EmojiFlagGenerator()

    internal func flag(from countryCode: String) -> String {
        countryCode
            .unicodeScalars
            .map { 127_397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }

    internal func flagWithName(from countryCode: String) -> String {
        flag(from: countryCode) + "  " + (Locale.current.localizedString(forRegionCode: countryCode) ?? .empty)
    }

    internal func currentLocaleIndex() -> Int {
        guard let code = Locale.current.regionCode else { return 0 }
        return Locale.isoRegionCodes.lastIndex(of: code) ?? 0
    }
}
