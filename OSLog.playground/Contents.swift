import OSLog

//let destination = URL(fileURLWithPath: "/tmp", isDirectory: true)
//let folderBaseName = "ConnectLogs/"
//
//let path = destination.appendingPathComponent(folderBaseName + Int(Date().timeIntervalSinceReferenceDate).description, isDirectory: true)
//let folderPath = destination.appending(path: folderBaseName + Int(Date().timeIntervalSinceReferenceDate).description, directoryHint: .isDirectory)
//
//NSTemporaryDirectory()
//let process = "com.jamf.connect"
//let lookback = Date() - 1800.0
////let jcSearchPredicate = NSPredicate(format: "(subsystem == %@) AND (date >=  %@)", process, lookback as NSDate)
//let jcSearchPredicate = NSPredicate(format: "(subsystem CONTAINS %@ ) && NOT (subsystem CONTAINS \"com.jamf.connect.Logtoy\")", process)
//
//
//do {
//    let localStore = try OSLogStore.local()
//    let logPosition = localStore.position(date: lookback)
//    logPosition.description
//    let result = try localStore.getEntries(at: logPosition, matching: jcSearchPredicate)
//
//    let messages = result
//        .compactMap { $0 as? OSLogEntryLog }
//        .map { "Timestamp: \($0.date), Sender: \($0.sender), subsystem: \($0.subsystem), Process: \($0.process), Category: \($0.category), Contents: \($0.composedMessage)"
//        }
//    messages.joined(separator: "\n")
//} catch {
//    print(error)
//}

let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
let sym = dlsym(RTLD_DEFAULT, "_os_activity_current")
let OS_ACTIVITY_CURRENT = unsafeBitCast(sym, to: os_activity_t.self)
let dso = UnsafeMutableRawPointer(mutating: #dsohandle)

let desc: StaticString = "My Custom Activity"
        desc.withUTF8Buffer { buffer in
            if let address = buffer.baseAddress {
                let descriptionBuffer = UnsafeRawPointer(address).assumingMemoryBound(to: Int8.self)
            }
        }

func fooBar() {

}
