import Cocoa
import PlaygroundSupport

struct Payload: Codable {
    var PayloadEnabled: Bool
    var PayloadIdentifier: String
    var PayloadDescription: String
    var PayloadVersion: Int
    var PayloadType: String
    var PayloadUUID: String
    var PayloadDisplayName: String
    var PayloadOrganization: String
    var OIDCProvider: String
    var OIDCClientID: String
    var OIDCROPGID: String?
    var OIDCRedirectURI: String?
    var OIDCDiscoveryURL: String?
    var OIDCClientSecret: String?
    var OIDCTenant: String?
    var Scopes: String?
    var CreateVerifyPasswords: Bool?
    var DenyLocal: Bool?
    var DenyLocalExcluded: [String]?
    var OIDCNewPassword: Bool?
    var OIDCLocalAuthButton: String?
    var OIDCAdmin: String?
    var OIDCAdminAttribute: String?
    var OIDCHideShutdown: Bool?
    var OIDCHideRestart: Bool?
    var OIDCIgnoreCheckURL: Bool?
    var OIDCDefaultLocal: Bool?
    var OIDCIgnoreCookies: Bool?
    var ScriptPath: String?
    var LicenseFile: Data?

    // LOGIN

    var CreateAdminUser: Bool?
    var DemobilizeUsers: Bool?

    var Migrate: Bool?
    var MigratedUsers: String?

    var EnableFDE: Bool?
    var EnableFDERecoveryKey: Bool?
    var EnableFDERecoveryKeyPath: String?

    var BackgroundImage: String?
    var LoginLogo: String?
    var HelpURL: String?
    var HelpURLLogo: String?
    var LocalHelpFile: String?
    var EULATitle: String?
    var EULASubTitle: String?
    var EULAText: String?
    var EULAPath: String?
}


struct MobileConfig: Codable {
    var PayloadEnabled: Bool
    var PayloadIdentifier: String
    var PayloadScope: String
    var PayloadDescription: String
    var PayloadVersion: Int
    var PayloadType: String
    var PayloadUUID: String
    var PayloadDisplayName: String
    var PayloadOrganization: String
    var PayloadRemovalDisallowed: Bool
    var PayloadContent: [Payload]
}

let configURL = URL(fileReferenceLiteralResourceName: "unsigned-modern.mobileconfig")
let configData = try Data(contentsOf: configURL)
let configPlist = try PropertyListDecoder().decode(MobileConfig.self, from: configData)

let configDict = NSDictionary(contentsOf: configURL)
print(configDict)
print(configPlist)
