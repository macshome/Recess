import Cocoa

//if let SUCS = Bundle(path: "/System/Library/PrivateFrameworks/SoftwareUpdateCoreSupport.framework"),
//   SUCS.load(),
//   let SUCD: AnyClass = SUCS.classNamed("SUCoreDevice") {
//    let sel = NSSelectorFromString("hwModelString")
//
//    let inst = SUCD.init()
//    inst.description
//    var methodCount = UInt32(0)
//    let methodList = class_copyMethodList(SUCD, &methodCount)
//
//    for i in 0..<Int(methodCount) {
//        let selName = sel_getName(method_getName((methodList?[i])!))
//        let methodName = String(cString: selName)
//            print(methodName)
//    }
//}

let JCLURL = URL(string: "file:///Library/Security/SecurityAgentPlugins/JamfConnectLogin.bundle")!

if let JCL = Bundle(url: JCLURL),
   JCL.load() {
    print("loaded")
    JCL.isLoaded
    JCL.bundleIdentifier
    JCL.infoDictionary
    let foo: AnyClass? = JCL.classNamed("JCAuthorizationPlugin")
    foo!.init()
}

if let CFJCL = CFBundleCreate(kCFAllocatorSystemDefault, JCLURL as CFURL) {
    CFBundleIsExecutableLoadable(CFJCL)
    print("loaded")
    CFBundleGetIdentifier(CFJCL)
    CFBundleIsExecutableLoaded(CFJCL)
}


