import Cocoa
import CoreServices


let path = NSURL(fileURLWithPath: "/System/Volumes/Data")
let possibleBytes = CSDiskSpaceGetRecoveryEstimate(path)

let formattedPurgeable = ByteCountFormatter.string(fromByteCount: Int64(possibleBytes), countStyle: .file)

print("Approximatly " + formattedPurgeable + " of purgeable data on this Mac.")
