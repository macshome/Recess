import Cocoa
import Foundation

if let SUCS = Bundle(path: "/System/Library/PrivateFrameworks/SoftwareUpdateCoreSupport.framework"),
   SUCS.load(),
   let SUCD: AnyClass = SUCS.classNamed("SUCoreDevice") {
    let sel = NSSelectorFromString("hwModelString")

    let inst = SUCD.init()
    inst.description
    var methodCount = UInt32(0)
    let methodList = class_copyMethodList(SUCD, &methodCount)

    for i in 0..<Int(methodCount) {
        let selName = sel_getName(method_getName((methodList?[i])!))
        let methodName = String(cString: selName)
            print(methodName)
    }


}

