import Foundation

extension TimeInterval {
    var seconds: TimeInterval { self }
    var minutes: TimeInterval { self * 60 }
    var hours: TimeInterval { self * 3_600 }
    var days: TimeInterval { self * 86_400 }
    var weeks: TimeInterval { self * 604_800 }
    var months: TimeInterval { self * 2_628_000 }

    static func minutes(_ numberOfMinutes: Int) -> TimeInterval {
        60 * Double(numberOfMinutes)
    }
}

print("42 seconds == \(42.seconds) seconds. Duh.")
print("1138 minutes == \(1138.minutes) seconds")
print("119 hours == \(119.hours) seconds")
print("9 days == \(9.days) seconds")
print("1 weeks == \(1.weeks) seconds")
print("11 months == \(11.months) seconds")

// Sample usage
Date(timeIntervalSinceNow: 22.days + 8.hours)
