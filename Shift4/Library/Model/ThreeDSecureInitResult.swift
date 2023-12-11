import Foundation

struct ThreeDSecureInitResult: Codable {
    let version: String
    let token: Token
    let directoryServerCertificate: DirectoryServerCertificate?
    let sdkLicense: String?
}
