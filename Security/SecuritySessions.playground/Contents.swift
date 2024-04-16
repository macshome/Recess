import Cocoa

// Security Session
//
// You can access bits about the security session to get some basic info. You can only get info about your own session.
// Other than the session id, the values are all Bools.
var sessionID = SecuritySessionId()
var sessionAttrs = SessionAttributeBits()

let result = SessionGetInfo(callerSecuritySession,
                            &sessionID,
                            &sessionAttrs)

if result != errSessionSuccess {
    print("Could not get session info. Error \(result)")
} else {
    print("SecuritySessionID: \(sessionID)")
    print("Security Session has graphic access: \(sessionAttrs.contains(.sessionHasGraphicAccess))")
    print("Security Session is running as root \(sessionAttrs.contains(.sessionIsRoot))")
    print("Security Session has a TTY: \(sessionAttrs.contains(.sessionHasTTY))")
    print("Security Session is remote: \(sessionAttrs.contains(.sessionIsRemote))\n")
}

// Window Server Session
//
// You can get a CFDictionary of all the current window server info. If there isn't any info it means there isn't a session.
// You can find a fair ammount of info abou the current session in the values of the CGSession dictionary.
// Note that the kCGSSessionAuditIDKey matches the SecuritySessionId.
//
// You can also listen for kCGNotifyGUIConsoleSessionChanged to tell you if the session has changed in some way.
// Listening for kCGNotifyGUISessionUserChanged will let you know when a login or logout has been completed.
if var cgSession = CGSessionCopyCurrentDictionary() as? [String: Any] {
    for item in cgSession {
        print("\(item.key): \(item.value)")
    }
} else {
    print("Could not get current CGSession.")
}
