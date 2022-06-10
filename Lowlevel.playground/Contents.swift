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



