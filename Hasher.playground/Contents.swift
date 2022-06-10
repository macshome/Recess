import Foundation
import CryptoKit

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
    
    return digest.map {
        String(format: "%02hhX", $0)
    }.joined()
}


let serial = "A1B2C3D4E5F6"
let hash = MD5(string: serial)
let digest = Insecure.MD5.hash(data: serial.data(using: .utf8)!)
let shard = (strtoul(hash, nil, 16))
print(shard)

