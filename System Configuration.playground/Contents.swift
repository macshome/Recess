import Cocoa
import SystemConfiguration

//var dynamicContext = SCDynamicStoreContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
//let dcAddress = withUnsafeMutablePointer(to: &dynamicContext, {UnsafeMutablePointer<SCDynamicStoreContext>($0)})

let store = SCDynamicStoreCreate(nil, "playground" as CFString, nil, nil)

let keyList = SCDynamicStoreCopyKeyList(store, ".*" as CFString)


//if let dynamicStore = SCDynamicStoreCreate(kCFAllocatorDefault, "com.jamf.connect.networknotification" as CFString, changed, dcAddress) {
//    let keysArray = ["State:/Network/Global/IPv4" as CFString, "State:/Network/Global/IPv6"] as CFArray
//    SCDynamicStoreSetNotificationKeys(dynamicStore, nil, keysArray)
//    let loop = SCDynamicStoreCreateRunLoopSource(kCFAllocatorDefault, dynamicStore, 0)
//    CFRunLoopAddSource(CFRunLoopGetCurrent(), loop, .defaultMode)
//}
