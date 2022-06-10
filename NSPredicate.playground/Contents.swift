import Cocoa
let regexPredicate = NSPredicate(format: "SELF MATCHES %@", ".{4,}+")
regexPredicate.evaluate(with: "thddd")
