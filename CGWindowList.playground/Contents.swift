import Cocoa

//let someText = NSTextField()
//someText.stringValue = "Foobar"
//someText.textDidChange(Notification(name: NSText.didChangeNotification))

let windowList = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID)! as! [[String: AnyObject]]
let myWindows: [AnyObject] = windowList.compactMap {
    if $0[kCGWindowOwnerName as String] as! String == "zoom.us" {
        return $0[kCGWindowNumber as String]!
    }
    return nil
}

myWindows

let windowListImage = CGImage(windowListFromArrayScreenBounds: .infinite,
                              windowArray: myWindows as CFArray,
                              imageOption: .bestResolution)
windowListImage

let windowzListImage = CGWindowListCreateImage(.infinite,
                                               .optionOnScreenOnly,
                                               myWindows.first as! CGWindowID,
                                               .bestResolution)

windowzListImage
