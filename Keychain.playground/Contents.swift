import Cocoa
import Security
import OSLog
//
//var secapp: SecTrustedApplication?
//var data: CFData?
//SecTrustedApplicationCreateFromPath("/usr/bin/security", &secapp)
//SecTrustedApplicationCopyData(secapp!, &data)
//let str = (data! as Data).base64EncodedString()
//
//SecTrustedApplicationGetTypeID()
//CFGetTypeID(secapp)
//
//var newApp: SecTrustedApplication?
//let newData: CFData = Data(base64Encoded: str)! as CFData
//SecTrustedApplicationCreateFromPath("/usr/bin/pico", &newApp)
//SecTrustedApplicationSetData(newApp!, newData)
//
//CFGetTypeID(secapp)
//print(secapp)
//newApp.debugDescription

let logger = Logger()

func getKeychainStatus(keychain: SecKeychain) -> String {
    var keychainStatus: SecKeychainStatus = 0
    let err = SecKeychainGetStatus(keychain, &keychainStatus)
    if err != errSecSuccess {
        return "error"
    } else {
        switch keychainStatus {
        case 1:
            return "Unlocked"
        case 2:
            return "Readable"
        case 4:
            return "Writeable"
        case 7:
            return "R/W and Unlocked"
        default:
            return String(describing: keychainStatus)
        }
    }
}

func getDefaultKeychain() throws -> SecKeychain {
    var defaultKeychain: SecKeychain?
    let result = SecKeychainCopyDefault(&defaultKeychain)
    if result == errSecNoDefaultKeychain || defaultKeychain == nil {
        print("Default keychain is missing.")
    }
    if result != errSecSuccess {
        print("Cannot create default keychain. OSStatus error code: %d", result)
    }

    return defaultKeychain!
}

func getKeychainPath(keychain: SecKeychain) -> String {
    var pathLength: UInt32 = 18
    var pathName = Array(repeating: 0 as Int8, count: 128)

    let result = SecKeychainGetPath(keychain, &pathLength, &pathName)
    if result != errSecSuccess {
        let error = SecCopyErrorMessageString(result, nil) as String!
        logger.error("\(error)")
        return "No default path found."
    }
    return FileManager.default.string(withFileSystemRepresentation: pathName, length: Int(pathLength))
}

let keychain = try! getDefaultKeychain()
getKeychainStatus(keychain: keychain)
getKeychainPath(keychain: keychain)
