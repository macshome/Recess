import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class watcher {
    init() {
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(self.logit(note:)),
                                                          name: nil,
                                                          object: nil)
    }

    @objc func logit(note: NSNotification) {
        print(note)
    }
}

let myWatcher = watcher()

