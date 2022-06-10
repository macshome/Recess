import Foundation
import NetFS

// Generally you want to use type inferrence rather than specific types.
// i.e. don't annotate all the types, just let it figure it out.
let fileSystemProtocol = "smb"
var serverName = "0.0.0.0"
var shareName = "test"
var userName = "username"
var password = "password"

// Rather than have these as functions it's simpler just to declare them as properties
let openOptionsDict = [kNAUIOptionKey: kNAUIOptionAllowUI, kNetFSUseGuestKey: false] as NSMutableDictionary

// If you really never need to put anything in this then it may be simpler to just
// put `NSMutableDictionary()` in the mounting method.
// Easier still is to just pass nil if it isn't required.
let mountOptionsDict = NSMutableDictionary()


func mountShare(fileSystemProtocol: String, serverAddress: String, shareName: String, userName: String, password: String) {
    let mountPoint = "/Volumes/".appending(shareName)

    // Using guard here lets us exit early if there is a problem and it removes the forced unwrap.
    guard let sharePath = NSURL(string: "\(fileSystemProtocol)://\(serverAddress)/\(shareName)") else {
        print("Couldn't create URL")
        return
    }

    // When calling long methods it can help readability to add returns after each argument.
    let mountStatus = NetFSMountURLSync(sharePath,
                                        nil,
                                        userName as CFString,
                                        password as CFString,
                                        openOptionsDict,
                                        nil,
                                        nil)

    // Using a switch here allows us to quickly test for statuses.
    switch mountStatus {
    // We got a 0 back, all good.
    case noErr:
        print("Mounted: \(String(describing: sharePath))")
    // The mountpoint exists (error 17), try to unmount and mount again.
    // Generally you shouldn't pre-flight things by testing for conditions like this. Just try
    // to do what you want to do and handle any errors that pop up.
    case EEXIST:
        print("Mount already exists. Attempt to unmount and remount.")

        // Try to unmount it. If that works then try mounting again.
        if unmount(mountPoint, 0) == noErr {
            print("\(mountPoint) was unmounted")
            mountShare(fileSystemProtocol: fileSystemProtocol,
                       serverAddress: serverName,
                       shareName: shareName,
                       userName: userName,
                       password: password)
        }
    // Some other status happened so just print it and bail.
    default:
        print("Error: \(mountStatus) sharePath: \(String(describing: sharePath)) Not Valid")
    }
}

mountShare(fileSystemProtocol: fileSystemProtocol, serverAddress: serverName, shareName: shareName, userName: userName, password: password)
