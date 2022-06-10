import OSLog

let subsystem = "securityd"
let lookback = Date() - 10.0
let searchPredicate = NSPredicate(format: "(subsystem contains %@) AND (date >=  %@)", subsystem, lookback as NSDate)


do {
    let localStore = try OSLogStore.local()
    let logPosition = localStore.position(timeIntervalSinceEnd: 0.0)
    let result = try localStore.getEntries(with: .reverse, at: logPosition, matching: searchPredicate)
    result.map { guard let entry = $0 as? OSLogEntryLog else {
        return
        }
        print("Timestamp: \(entry.date), Sender: \(entry.sender), subsystem: \(entry.subsystem), Process: \(entry.process), Category: \(entry.category), Contents: \(entry.composedMessage)")
    }
} catch {
    print(error)
}
