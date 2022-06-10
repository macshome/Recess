import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var isScreenLocked: Bool {
    guard let wssProperties = CGSessionCopyCurrentDictionary() as? [String : Any], (wssProperties["CGSSessionScreenIsLocked"] != nil) else {
        return false
    }
    return true
}

Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
    print(isScreenLocked)
}
