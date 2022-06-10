import Cocoa

/// Certificate settings for Jamf Connect.
struct CertificateSettings: Codable {

    /// When using a Windows CA, this is the name of the certificate template to use.
    var certificateTemplate: String?

    /// Should Jamf Connect attempt to retrieve certificates from the Windows CA automatically?
    var getCertificateAutomatically: Bool?

    /// A list of 802.1X networks that should be used with any retrieved certificate.
    var secureNetworks: [String]?

    /// The URL of the WIndows CA to be used.
    var windowsCA: String?

    /// Is private key from windows CA certificate exportable?
    var exportableCertificateKey: Bool?

    private enum CodingKeys: String, CodingKey {
        case certificateTemplate = "CertificateTemplate"
        case getCertificateAutomatically = "GetCertificateAutomatically"
        case secureNetworks = "SecureNetworks"
        case windowsCA = "WindowsCA"
        case exportableCertificateKey = "ExportableCertificateKey"
    }
}

let swift = CertificateSettings(certificateTemplate: "",
                                getCertificateAutomatically: false,
                                secureNetworks: [String](),
                                windowsCA: "",
                                exportableCertificateKey: false)

let encoder = JSONEncoder()
let json = try encoder.encode(swift)
let jsonString = String(data: json, encoding: .utf8)
dump(jsonString)

