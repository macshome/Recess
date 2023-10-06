import Cocoa
import CoreServices

// Different ways of finding out about disk space on macOS.

// This method from CoreServices lets you find the space the OS considers "purgable"
// You can trigger a purge as well with `CSDiskSpaceStartRecovery`
let path = URL(fileURLWithPath: "/")
let possibleBytes = CSDiskSpaceGetRecoveryEstimate(path as NSURL)

let formattedPurgeable = formattedBytes(possibleBytes)
print("Total purgable space:")
print("Approximatly " + formattedPurgeable + " of purgeable data on this Mac.")

// You can use the newer URLResourceKey to find out space info
// There are keys you can access here to learn things about file types and purgability as well.
do {
    let values = try path.resourceValues(forKeys: [.volumeAvailableCapacityKey,
                                                   .volumeAvailableCapacityForImportantUsageKey,
                                                   .volumeAvailableCapacityForOpportunisticUsageKey])
    if let capacity = values.volumeAvailableCapacity,
       let importantCapacity = values.volumeAvailableCapacityForImportantUsage,
       let oppoCapacity = values.volumeAvailableCapacityForOpportunisticUsage {
        print("\nUsing the fancy new URLResourceKeys:")
        print("Available capacity: \(formattedBytes(capacity))")
        print("Available capacity for important usage: \(formattedBytes(importantCapacity))")
        print("Available capacity for oppertunistic usage: \(formattedBytes(oppoCapacity))")
        print("Capacity minus Important Usage should equal purgable: \(formattedBytes((Int64(importantCapacity - Int64(capacity)))))")
    } else {
        print("Capacity is unavailable")
    }
    
    // You can always use the trust old FileAttributes as well
    let attributes = try FileManager.default.attributesOfFileSystem(forPath: "/")
    if let fileKeySize = attributes[.systemFreeSize] as? Int64 {
        print("\nUsing the trusty old FileAttributeKeys:")
        print("Available capacity: \(formattedBytes(fileKeySize))")
    }
    
} catch {
    print("Error retrieving capacity: \(error.localizedDescription)")
}

// If you like living dangerously...
var stat = statvfs()
let result = statvfs("/", &stat)
if result != noErr {
    print("statvfs exploded. Disk is probably on fire.")
} else {
    print("\nGetting crazy with POSIX:")
    print("Available capacity: \(formattedBytes(Int64(Int(stat.f_bavail) * Int(stat.f_frsize))))")
}

// A helper function for printing
func formattedBytes(_ bytes: any BinaryInteger) -> String {
    return ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .file)
}
