import Foundation

internal struct DirectoryServerCertificate: Codable {
    let certificate: String
    let caCertificates: [String]
}
