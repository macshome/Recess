import Cocoa
import Darwin
import Security
import Security.AuthorizationPlugin

//UTGetOSTypeFromString("PlgN" as CFString)
//UTGetOSTypeFromString("Mchn" as CFString)
//
//
//struct __OpaqueAuthorizationEngine {
//    let version = 0
//}
//
//protocol TestableCallbacks {}
//extension TestableCallbacks {
//    var version: UInt32 { return 0 }
//}
//EXIT_SUCCESS
//EXIT_FAILURE
//extension AuthorizationCallbacks {
//    var version: UInt32 { return 0 }
//    var SetResult: {  @convention(c) (AuthorizationEngineRef, AuthorizationResult) -> OSStatus }
//}
//
//var engine = __OpaqueAuthorizationEngine()
//var engPtr = OpaquePointer(UnsafeRawPointer(&engine))
//
//var callbacks = AuthorizationCallbacks.self
//var callbackPtr = (UnsafePointer(&callbacks))


var sesID = SecuritySessionId()
var sesBits = SessionAttributeBits()

SessionGetInfo(callerSecuritySession,
               &sesID,
               &sesBits)

sesID
sesBits.contains(.sessionIsRoot)

struct Foo {
    let a: Int?
    let b: Int?
    var isTrue = true
}

var bar = Foo(a: nil, b: nil)
var baz = Foo(a: 1, b: Int.max, isTrue: false)

MemoryLayout<Foo>.size
MemoryLayout<Foo>.stride
MemoryLayout<Foo>.alignment

MemoryLayout<Foo>.offset(of: \Foo.a)
MemoryLayout<Foo>.offset(of: \Foo.b)
MemoryLayout<Foo>.offset(of: \Foo.isTrue)

MemoryLayout.size(ofValue: bar)
MemoryLayout.stride(ofValue: bar)
MemoryLayout.alignment(ofValue: bar)

MemoryLayout.size(ofValue: baz)
MemoryLayout.stride(ofValue: baz)
MemoryLayout.alignment(ofValue: baz)

let barBytes = Data(bytes: &bar,
                    count: MemoryLayout<Foo>.stride)
barBytes[0]
barBytes[16]
barBytes[25]

// Don't use size for the count when manually looking inside bytes.
let bazBytes = Data(bytes: &baz,
                    count: MemoryLayout<Foo>.stride)
bazBytes[0]

// Because the Int.max value is larger than 8 bytes we need to read more of them.
bazBytes[24]
baz.b
let bBytes = bazBytes[16...23]
let bValue = bBytes.reduce(0) { value, byte in
    return value << 8 | UInt64(byte)
}

Int.max
bazBytes[25]
