//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
import Cocoa

class Watcher {
    init() {

        DistributedNotificationCenter.default().addObserver(forName: .NSSystemClockDidChange,
                                                            object: nil,
                                                            queue: .main) { note in
            print(note)

        }
    }
}

let watcher = Watcher()

dispatchMain()

