import Cocoa

  var trialDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

  var licenseDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter
}()

let dateString = "2020-11-28 00:00:00 -0600"

licenseDateFormatter.date(from: dateString)



extension TimeInterval {
    var minutes: TimeInterval { return self * 60 }
    var hours: TimeInterval { return self * 3_600 }
    var days: TimeInterval { return self * 86_400 }
    var weeks: TimeInterval { return self * 604_800 }
    var months: TimeInterval { return self * 2_628_000 }
}

extension Date {
    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }

    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }

    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }

    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }

    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }

    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }

}

let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .medium
dateFormatter.timeZone = .none

let components = DateComponents(calendar: Calendar.current, year: 2020, month: 12, day: 0)
let kTrialExpire = Calendar.current.date(from: components)
let expire = kTrialExpire
let now = Date()
now.timeIntervalSince(expire!)

kTrialExpire?.timeIntervalSinceReferenceDate
dateFormatter.locale = Locale(identifier: "en_US")
print(dateFormatter.string(from: kTrialExpire!))

let past = Date(timeIntervalSinceReferenceDate: 0)
let later = Date(timeIntervalSinceReferenceDate: 10.days)
later.days(sinceDate: past)

let buildDate = "\"Jan  5 2021\"".trimmingCharacters(in: .punctuationCharacters)
buildDate.trimmingCharacters(in: .punctuationCharacters)

let formatter = DateFormatter()
formatter.dateFormat = "MMM d yyyy"
//formatter.dateStyle = .medium
let createdOn = formatter.date(from: buildDate)

TimeZone.current
