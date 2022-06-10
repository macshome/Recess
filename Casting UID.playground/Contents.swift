import Cocoa
import Darwin
import CoreFoundation

let uid = getuid()
let foo = geteuid()
let bar = String(cString: getlogin()!)
let puid = 501

//String(cString: bar)
let cuid = uint32(puid)

let bpuid = uid_t.init(bitPattern: Int32(puid))

MemoryLayout.size(ofValue: uid)
MemoryLayout.size(ofValue: puid)
MemoryLayout.size(ofValue: cuid)
MemoryLayout.size(ofValue: bpuid)

var data = UInt32(uid)
let dataSize = MemoryLayout.size(ofValue: data)
//let ptr = UnsafeMutableRawPointer.allocate(byteCount: dataSize, alignment: 1)

let ptr = UnsafeMutablePointer<UInt32>.allocate(capacity: 4)
ptr.initialize(to: uid)
let rawPtr = UnsafeMutableRawPointer(ptr)

func getFromKeychain(_ string: String) throws -> String {
    return ""
}

try? getFromKeychain("Foo")
