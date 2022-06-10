import CryptoKit

@available(OSX 10.15, *)
extension SHA256Digest {
    var string: String {
        self.compactMap { String(format: "%02x", $0) }.joined()
    }
}

