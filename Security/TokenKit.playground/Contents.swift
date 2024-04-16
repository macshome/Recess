import Cocoa
import CryptoTokenKit
//import PlaygroundSupport
//PlaygroundPage.current.needsIndefiniteExecution = true

//class TokenKVO: NSObject {
//    @objc let watcher =  TKTokenWatcher()
//    var observer: NSKeyValueObservation?
//
//    override init() {
//        super.init()
//        observer = observe(\.watcher.tokenIDs) { object, change in
//            print("tokens changed to \(object.watcher.tokenIDs)")
//        }
//    }
//}
//
//let testKVO = TokenKVO()
class mockItem: TKTokenKeychainKey {
    private var privCanSign = false
    override var canSign: Bool {
        get { return privCanSign }
        set { privCanSign = newValue }
    }
//    override var canDecrypt: Bool

    init!(canSign: Bool = false, canDecrypt: Bool = false) {
        print("in init")
        super.init(certificate: nil, objectID: "foo")
        print("Made super")
        self.canSign = canSign
//        self.canDecrypt = canDecrypt
    }

}

class MockToken: TKToken {

}

let foo = mockItem()
print(foo!.canSign)


