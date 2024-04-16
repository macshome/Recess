import CryptoKit
import Foundation


//func makeKeypair() {
//    if SecureEnclave.isAvailable {
//        let privateKey = try! SecureEnclave.P256.Signing.PrivateKey()
//        let publicKey = privateKey.publicKey
//
//        let publicBits = publicKey.rawRepresentation
//        let someData = "Some sample Data to sign.".data(using: .utf8)!
//        let signature = try! privateKey.signature(for: someData)
//
//        if publicKey.isValidSignature(signature, for: someData) {
//            print("Signature is valid")
//        }
//    }
//}
//
//makeKeypair()

let text = "something something something"
let hash = try? SHA256.hash(data: text.data(using: .utf8)!)
print(hash ?? "doh!")
hash?.withUnsafeBytes { ptr in
    ptr.copyBytes(to: <#T##UnsafeMutableBufferPointer<DestinationType>#>, count: <#T##Int#>)
    String(bytesNoCopy: ptr, length: ptr.count, encoding: .utf8, freeWhenDone: true)

}

