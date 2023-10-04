import Cocoa

let cfNoteName = CFNotificationName("com.apple.system.DirectoryService.InvalidateCache.group" as CFString)
CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), cfNoteName, nil, nil, true)
