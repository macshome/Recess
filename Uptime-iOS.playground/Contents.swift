import UIKit

func getUptime() -> Int {
    let nanoseconds = DispatchTime.now()
    return Int(nanoseconds.rawValue / 1000000000)
}

getUptime()
