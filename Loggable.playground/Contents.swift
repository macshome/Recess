import Cocoa
import os.log

protocol Loggable {
    var log: OSLog {get}
}

extension Loggable {
    var log: OSLog {
      return  OSLog(subsystem: "\(Bundle.main.bundleIdentifier ?? "MyApp")", category: "\(type(of: Self.self))")
    }

    func logDefault(_ message: String) {
        print(message)
    }

    func logInfo(_ message: String) {
        print(message)
    }

    func logDebug(_ message: String) {
        print(message)
    }

    func logError(_ message: String) {
        print(message)
    }

    func logFault(_ message: String) {
        print(message)
    }
}

class SomeClass: Loggable {}

let testClass = SomeClass()
testClass.logDebug("This is a test")
debugPrint(testClass.log)
