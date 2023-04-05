import OSLog

let destination = URL(fileURLWithPath: "/tmp", isDirectory: true)
let folderBaseName = "ConnectLogs/"

let path = destination.appendingPathComponent(folderBaseName + Int(Date().timeIntervalSinceReferenceDate).description, isDirectory: true)
let folderPath = destination.appending(path: folderBaseName + Int(Date().timeIntervalSinceReferenceDate).description, directoryHint: .isDirectory)

NSTemporaryDirectory()
let process = "com.jamf.connect"
let lookback = Date() - 1800.0
//let jcSearchPredicate = NSPredicate(format: "(subsystem == %@) AND (date >=  %@)", process, lookback as NSDate)
let jcSearchPredicate = NSPredicate(format: "(subsystem CONTAINS %@ ) && NOT (subsystem CONTAINS \"com.jamf.connect.Logtoy\")", process)


do {
    let localStore = try OSLogStore.local()
    let logPosition = localStore.position(date: lookback)
    logPosition.description
    let result = try localStore.getEntries(at: logPosition, matching: jcSearchPredicate)

    let messages = result
        .compactMap { $0 as? OSLogEntryLog }
        .map { "Timestamp: \($0.date), Sender: \($0.sender), subsystem: \($0.subsystem), Process: \($0.process), Category: \($0.category), Contents: \($0.composedMessage)"
        }
    messages.joined(separator: "\n")
} catch {
    print(error)
}
