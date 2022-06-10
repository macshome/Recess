import Cocoa

func getUptime() -> String {
    let nanoseconds = DispatchTime.now()
    let seconds = Int(nanoseconds.rawValue / 1000000000)
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .full
    guard let uptime = formatter.string(from: TimeInterval(seconds)) else {
        return "Unknown"
    }
    return uptime
}

getUptime()
