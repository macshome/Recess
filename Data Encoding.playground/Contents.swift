//: Playground - noun: a place where people can play

import Cocoa
import CryptoKit

func makeKeypair() -> Data  {
        let privateKey = try! SecureEnclave.P256.Signing.PrivateKey()
        let publicKey = privateKey.publicKey

        return publicKey.rawRepresentation
}

struct QRPayload: Codable {
    let deviceName: String
    let nonce: UUID
    let publicKey: Data
}

let name = "It Me"
let nonce = UUID()
let key = makeKeypair()

var raw = QRPayload(deviceName: name,
                     nonce: nonce,
                     publicKey: key)


if let encoded = try? PropertyListEncoder().encode(raw) {
    let decoded = try PropertyListDecoder().decode(QRPayload.self, from: encoded)
    print(decoded)
}


