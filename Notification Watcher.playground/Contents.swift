//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class Watcher {
    
    private let noted: CFNotificationCallback = { _, _, name,_,_ in
        print(name!)
    }
    
    init() {

        print("Register for CFNotifications")
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        nil,
                                        noted,
                                        "com.apple.system.DirectoryService.InvalidateCache.group" as CFString,
                                        nil,
                                        .deliverImmediately)

        print("Register for NSNotifications")
        DistributedNotificationCenter.default().addObserver(forName: nil,
                                                            object: nil,
                                                            queue: .main) { note in
            print(note)

        }
        print("Startup done...")
    }
}

let watcher = Watcher()

dispatchMain()

