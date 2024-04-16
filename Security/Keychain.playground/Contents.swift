import Foundation
import Security

// This playground is for exploring the file-based SecKeychain API on macOS.
// This API has been deprecated, but there is no direct replacement for
// it other than moving to the iCloud keychain.
//
// The Security framework is C-based and pretty strange for someone
// that has only used Swift. It is though a pretty decent introduction
// to C-Swift Interop and a good way to learn about using things like
// pointers and CoreFoundation types from Swift.
//
// For more tips on using the API from Swift, take a look at
// Quinn's "Calling Security Framework from Swift"
// <https://developer.apple.com/forums/thread/710961>
//
// For a good overview of the different keychain APIs read TN3137
// <https://developer.apple.com/documentation/technotes/tn3137-on-mac-keychains>
//
// When using this playground you can click on the line number you want to run
// after each section of code. For example, you can run the code that creates
// a keychain item and then look it Keychain Access to see that it exists.
// All functions have headerdocs and you can read them by selecting the name with
// the option key or in the Quick Help pane of Xcode. You can quickly find topic
// sections by using the jump bar.


//MARK: Extensions
// A simple extension to get the string description of an OSStatus.
// In production code you would probably just want to throw on errors
// but here we want to print them out.
extension OSStatus {
    var string: String {
        SecCopyErrorMessageString(self, nil)! as String
    }
}

//MARK: - Keychain File Access
/// Retrive a pointer to the default Keychain for the current user.
/// - Returns: The `SecKeychain` that references the default keychain.
///
/// On macOS, the user and system can have multiple Keychains. One of these should
/// be set as the "default" to be used when performing operations if a different Keychain
/// isn't specified. The default on macOS is the user's Login Keychain, although the
/// user can change this to any Keychain they want to use.
func getDefaultKeychain() -> SecKeychain? {
    var defaultKeychain: SecKeychain?
    let status = SecKeychainCopyDefault(&defaultKeychain)
    if status != errSecSuccess {
        print("Cannot find default keychain. OSStatus: \(status.string)")
        return nil
    }
    return defaultKeychain
}


// Grab the default Keychain to use for the rest of the Playground
let keychain = getDefaultKeychain()!

// CFTypes are generally opaque. You can identify them by checking the
// CFTypeID against what you are expecting, in this case it's type 86.
print("SecKeychain type should be: \(SecKeychainGetTypeID())")
print("We found this CFTypeID on our SecKeychain object: \(CFGetTypeID(keychain))")

// In production code you should NOT rely on the numerical TypeID as they can change.
// Instead you should just check against the type to find if it is the one you want.
print("Is our object a SecKeychain? " + (CFGetTypeID(keychain) == SecKeychainGetTypeID() ? "True" : "False"))
print("Is our object a Certificate? " + (CFGetTypeID(keychain) == SecCertificateGetTypeID() ? "True" : "False"))


/// Finds the filesystem path to a Keychain.
/// - Parameter keychain: The `SecKeychain` object that you want to find the path of.
/// - Returns: The path to the Keychain as a `String`. If the Keychain isn't found, returns `"Not found"`
///
/// File-based Keychains can be anywhere that the user wants them to be, even on external media.
/// As there is no set path to find them at, the Security framework provides a method to
/// retrieve the path of any given `SecKeychain` object.
///
/// In production you would probably want to return a filesystem URL, but in this playground we just want
/// to print the values.
func getKeychainPath(keychain: SecKeychain) -> String {
    var pathLength: UInt32 = 128
    var pathName = Array(repeating: 0 as Int8, count: Int(pathLength))

    let status = SecKeychainGetPath(keychain, &pathLength, &pathName)
    if status != errSecSuccess {
        print("No default path found. OSStatus: \(status.string)")
        return "Not found"
    }

    return String(cString: pathName)
}

// Checkout the filesystem path of the default keychain.
print("\nDefault Keychain Location: \(getKeychainPath(keychain: keychain))")


/// Returns the access status of a Keychain.
/// - Parameter keychain: The `SecKeychain` object that you want to inspect.
/// - Returns: The status of the Keychain access.
///
/// The file-based keychain has several states it can be in. Simply unlocking
/// it is sometimes not enough. In order to make any changes to the items in a Keychain
/// the file must be Unlocked, Readable, and Writeable. Since it can exist in any combination
/// of these states this function is a convient way to see the status.
func getKeychainStatus(keychain: SecKeychain) -> String {
    var keychainStatus: SecKeychainStatus = 0
    let status = SecKeychainGetStatus(keychain, &keychainStatus)
    if status != errSecSuccess {
        return status.string
    } else {
        switch keychainStatus {
        case kSecUnlockStateStatus:
            return "Unlocked"
        case kSecReadPermStatus:
            return "Readable"
        case kSecWritePermStatus:
            return "Writeable"
        case kSecUnlockStateStatus + kSecReadPermStatus + kSecWritePermStatus:
            return "R/W and Unlocked"
        default:
            return String(describing: keychainStatus)
        }
    }
}

// Find the status of the default keychain
print("Default Keychain Status: \(getKeychainStatus(keychain: keychain))")

//MARK: - Keychain Items
// Everything in the SecKeychain API about items is done with queries.
// Not only do you use queries to find items, but you use them to add items
// as well. There are a LOT of possible attributes for each SecItem so it's
// advisable to create structs to deal with accounts. Then you can simply
// convert them back and forth between your own format and that of a SecItem.

// Here is an example of a simple struct to hold credentials.
struct Credentials {
    var username: String
    var password: String
    var server: String
}

/// Add a new password to the default keychain.
/// - Parameter creds: A `Credentials` struct with the account details to add.
///
/// When adding a new item to the keychain you simply make a query dictionary with the details
/// that you want to add. If a matching item already exists you will not be able to add it again. This error
/// is easy to see as you get a clear status that the item alrady exists.
///
/// When adding a password to an item you need to first encode it as data. When adding a value to
/// an item it will be encrypted by the system.
///
/// Always consider adding a label or other description so that it is easier to find the item in the Keychain.
/// If you don't specify a particular keychain to use, the API will put the item in the default keychain if it is open.
///
/// In this example we are adding an internet item password. There are other types of items you can add
/// such as Generic passwords, certificates, and keys. There are convience methods that can add
/// just the type you want to help cut down on boilerplate.
///
/// Notice how we take advantage of the toll-free bridging between Foundation and CoreFoundation types
/// by using a NSDictionary.
func addSecItem(_ creds: Credentials) {
    let password = creds.password.data(using: .utf8)!
    let addQuery = [kSecClass: kSecClassInternetPassword,
               kSecAttrServer: creds.server,
              kSecAttrAccount: creds.username,
                kSecValueData: password,
                kSecAttrLabel: "This is a test item"] as NSDictionary

    let status = SecItemAdd(addQuery, nil)
    if status != errSecSuccess {
        print("\nCould not add SecItem to default keychain. OSStatus: \(status.string)")
    } else {
        print("\nSucessfully added item for server \(creds.server) to default keychain.")
    }
}

// Create some sample credentials and add them to our keychain.
let creds = Credentials(username: "TheWoz", password: "WheelsOfZeus", server: "appleII.apple.com")
addSecItem(creds)

/// Search the keychain for an item matching a server name
/// - Parameter server: The server attribute to search for.
/// - Returns: A `Credentials` struct with values extracted from the `SecItem`
///
/// Searching for a keychain item is very similar to adding one. You make a query and then use it to copy a matching result.
/// The default is to return only the first matching result. If there are multiple results you can specify a search limit in your query
/// with the `kSecMatchLimit` search attribute. Then you can iterate over the results.
///
/// It is very important to notice that the attributes, the secret data, and the actual item can be returned seperatly. You can always see the
/// item attributes, but you can only access the data if you are allowed access to it by the system. If you try to access
/// the data of an item that you didn't create, or otherwise have access to, you will be denied.
///
/// If you don't specify a `kSecClass` you should check to see what type the found object is.
func findSecItem(_ server: String) -> Credentials? {
    let searchQuery = [kSecClass: kSecClassInternetPassword,
                  kSecAttrServer: server,
            kSecReturnAttributes: true,
                  kSecReturnData: true] as NSDictionary

    var secItem: CFTypeRef?
    let status = SecItemCopyMatching(searchQuery, &secItem)
    if status != errSecSuccess {
        print("Could not add SecItem to default keychain. OSStatus: \(status.string)")
        return nil
    }

    guard let foundItem = secItem as? NSDictionary,
          let passwordData = foundItem[kSecValueData] as? Data,
          let password = String(data: passwordData, encoding: .utf8),
          let account = foundItem[kSecAttrAccount] as? String else { return nil }
    return Credentials(username: account, password: password, server: server)
}

// Search the keychain for the credentials we stored earlier.
if let searchResults = findSecItem("appleII.apple.com") {
    print("\nSearched for \"appleII.apple.com\" in keychain and found username: \(searchResults.username), password: \(searchResults.password)")
}

/// Update a keychain item with new info
/// - Parameter creds: `Credentials` to use to find and update an item.
///
/// Updating a keychain item is fairly simple and very similar to what we've done before. You provide a search
/// query to find an item, then a second dictionary of the attributes that you want to update. Because we aren't retrieving
/// and data from the SecItem we don't need to specify return attributes in the search query.
///
/// In production code you would probably want to update an existing item rather than adding more versions of the same
/// credentials.
func updateSecItem(_ creds: Credentials) {
    let searchQuery = [kSecClass: kSecClassInternetPassword,
                  kSecAttrServer: creds.server] as NSDictionary

    let updateAttributes = [kSecValueData: creds.password.data(using: .utf8)!] as NSDictionary

    let status = SecItemUpdate(searchQuery, updateAttributes)
    if status != errSecSuccess {
        print("\nCould not update keychain item. OSStatus: \(status.string)")
    }
}

// Create a set of updated credentials and then update our keychain item.
let updatedCreds = Credentials(username: "TheWoz", password: "Apple][Forever", server: "appleII.apple.com")
updateSecItem(updatedCreds)

// Search for our new item and then check the values.
if let searchResults = findSecItem("appleII.apple.com") {
    print("\nSearched for \"appleII.apple.com\" in keychain and found username: \(searchResults.username), password: \(searchResults.password)")
}

/// Delete a keychain item for a server name.
/// - Parameter server: The hostname of the Internet Password item to delete.
///
/// Deleting items is very similar to updating them. You can use the same search query to find
/// or delete a `SecItem`.
///
/// By default this API will delete all of the items that match your search. Either constrain the number
/// of search results or iterate over them to only delete the items you want to remove.
func deleteSecItem(_ server: String) {
    let searchQuery = [kSecClass: kSecClassInternetPassword,
                  kSecAttrServer: creds.server] as NSDictionary

    let status = SecItemDelete(searchQuery)
    guard status == errSecSuccess else {
        print("\nCould not delete keychain item. OSStatus: \(status.string)")
        return
    }
    print("\nDeleted keychain item for server: \(server)")
}

//Delete the item we have been working with.
deleteSecItem("appleII.apple.com")

//MARK: - Access Controls


// Create a new keychain item based on the creds from earlier.
addSecItem(creds)

func getSecKeychainItem(_ server: String) -> SecKeychainItem? {
    let searchQuery = [kSecClass: kSecClassInternetPassword,
                  kSecAttrServer: server,
            kSecReturnAttributes: true,
                   kSecReturnRef: true] as NSDictionary

    var secItem: CFTypeRef?
    let status = SecItemCopyMatching(searchQuery, &secItem)
    if status != errSecSuccess {
        print("Could not get SecKeychainItem from default keychain. OSStatus: \(status.string)")
        return nil
    }

    guard let foundItem = secItem as? NSDictionary else {
        print("Could not decode item dictionary.")
        return nil }
    return (foundItem[kSecValueRef] as! SecKeychainItem)
}

func getSecAccess(_ secItem: SecKeychainItem) -> SecAccess? {
    var secAccess: SecAccess?
    let status = SecKeychainItemCopyAccess(secItem, &secAccess)

    if status != errSecSuccess {
        print("Could not get SecAccess from item. OSStatus: \(status.string)")
        return nil
    }
    return secAccess
}

/// Extracts the ACLs from a `SecAccess` instance.
/// - Parameter secAccess: The `SecAccess` instance that you want to retrieve the ACLs from.
/// - Returns: An array of `SecACL` instances.
///
/// By default macOS keychain items have three ACL entries:
///
/// * Owner entry. Determines who can modify the access instance,
/// because it contains the kSecACLAuthorizationChangeACL authorization.
/// The owner entry’s list of trusted apps is empty, so the user is always prompted for permission
///  if someone tries to change the access instance.
///  All access instances must have exactly one owner entry,
///  so this item can’t be removed, although you can modify it.
///
/// * Safe entry. Applies to operations not considered secure, namely encrypting data.
///  This ACL entry trusts all apps by default, because its array of trusted apps is set to nil.
///
/// * Restricted entry. Applies to operations that are considered sensitive, such as decrypting,
///  signing, deriving keys, and exporting keys.
///  The method applies the list of apps given in the trustedlist parameter to this entry.
///  If you set trustedlist to nil, the list of trusted apps contains only the calling app.
func getACLList(secAccess: SecAccess) -> [SecACL]? {
    var aclList: CFArray?
    let status = SecAccessCopyACLList(secAccess, &aclList)
    if status != errSecSuccess {
        print("Could not get SecAccess from item. OSStatus: \(status.string)")
        return nil
    }

    guard let acls = aclList as? [SecACL] else {
        print("Couldn't fetch access data for a keychain item. OSStatus error code: %d", status)
        return nil
    }
    return acls
}

// Find the item and retrieve the SecAccess for it.
let theItem = getSecKeychainItem("appleII.apple.com")
let secAccess = getSecAccess(theItem!)
let secACLs = getACLList(secAccess: secAccess!)


/// Create a trusted application object to use when adjusting a file-based Keychain item ACL.
/// - Parameter path: The application that you want to add to a Keychain item ACL.
/// - Returns: A `SecTrustedApplication` object
///
/// File-based keychains have several access control tools, the most well known being application
/// access ACLs. You can edit these ACLs with the Keychain Access utility in the GUI to add,
///  or remove, access on a per-item, per-application basis.
///
///  The modern Keychain APIs control this access via Keychain Groups rather than adjustable ACLs.
func createSecTrustedApp(_ path: String) -> SecTrustedApplication? {
    var secApp: SecTrustedApplication?
    let status = SecTrustedApplicationCreateFromPath(path, &secApp)
    if status != errSecSuccess {
        print("Could not create SecTrustedApplication. OSStatus: \(status.string)")
        return nil
    }
    return secApp
}






let secTrustApp = createSecTrustedApp("/usr/bin/security")



