import Cocoa
import CoreServices

//LSCopyApplicationURLsForURL(URL(string: "http://www.apple.com")! as CFURL, .viewer)?.takeUnretainedValue() as? [URL]
//
//URL(string: "file:///Applications/Safari%20Technology%20Preview.app/")
//
//struct BrowserFinder {
//    private static let staticUrl = URL(string: "http://www.apple.com")!
//    private static var browserOverride: String? {
//        return UserDefaults.standard.string(forKey: "Preferences.preferredBrowser")
//    }
//
//    static var installedBrowsers: [String]? {
//        guard let browserList = LSCopyApplicationURLsForURL(staticUrl as CFURL, .viewer)?.takeUnretainedValue() as? [URL] else { return nil }
//        return browserList.map { $0.deletingPathExtension().lastPathComponent }
//    }
//
//    static var defaultBrowser: String? {
//        if let browserOverride = browserOverride { return browserOverride }
//        guard let defaultBrowser = NSWorkspace.shared.urlForApplication(toOpen: staticUrl)?.deletingPathExtension().lastPathComponent else { return nil }
//        return defaultBrowser
//    }
//}
//
//BrowserFinder.installedBrowsers
//BrowserFinder.defaultBrowser

func getLoginItems() -> (fileList: LSSharedFileList, items: [LSSharedFileListItem])? {
    guard let sharedFileList = LSSharedFileListCreate(nil,
                                                      kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                                                      nil) else { return nil }
    let fileList = sharedFileList.takeRetainedValue()
    let loginItemsListSnapshot: NSArray = LSSharedFileListCopySnapshot(fileList, nil)?.takeRetainedValue() as! NSArray
    let loginItems = loginItemsListSnapshot as? [LSSharedFileListItem]
    return (fileList, loginItems ?? [])
}

let items = getLoginItems()
items?.items.forEach {
    print($0)
}
