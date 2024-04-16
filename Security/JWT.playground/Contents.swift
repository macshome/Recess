import CryptoKit
import Foundation

extension Data {
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

struct Header: Encodable {
    let alg = "HS256"
    let typ = "JWT"
}

struct Payload: Encodable {
    let sub = "1234567890"
    let name = "John Doe"
    let iat = 1516239022
}

let secret = "your-256-bit-secret"
let privateKey = SymmetricKey(data: Data(secret.utf8))

let headerJSONData = try! JSONEncoder().encode(Header())
let headerBase64String = headerJSONData.urlSafeBase64EncodedString()

let payloadJSONData = try! JSONEncoder().encode(Payload())
let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()

let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)

let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
let signatureBase64String = Data(signature).urlSafeBase64EncodedString()

let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
print(token) // eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
