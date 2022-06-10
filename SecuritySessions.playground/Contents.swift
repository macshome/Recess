import Cocoa
//import CoreGraphics


var sessionID = SecuritySessionId()
var sessionAttrs = SessionAttributeBits()

SessionGetInfo(callerSecuritySession,
               &sessionID,
               &sessionAttrs)

sessionID
sessionAttrs.contains(.sessionHasGraphicAccess)
sessionAttrs.contains(.sessionIsRoot)
sessionAttrs.contains(.sessionHasTTY)
sessionAttrs.contains(.sessionIsRemote)

