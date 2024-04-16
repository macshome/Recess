import Foundation
import dnssd
import PlaygroundSupport

let youyou = UUID()
MemoryLayout.size(ofValue: youyou)
let str = youyou.uuidString
MemoryLayout.size(ofValue: str)

//PlaygroundPage.current.needsIndefiniteExecution = true

//class DNSResolver {
//    typealias DNSRecordType = Int
//
//    func bjVersion() {
//        var vers: UInt32?
//        var size = UInt32(MemoryLayout.size(ofValue: vers))
//        let err = DNSServiceGetProperty(kDNSServiceProperty_DaemonVersion,
//                                 &vers,
//                                 &size)
//        if err != kDNSServiceErr_NoError {
//            print("Blowed up!")
//            return
//        }
//        print(vers)
//    }
//
//    func resolve(_ host: String, type: DNSRecordType) {
//        print(host, type)
//    }
//}
//
//let sut = DNSResolver()
//sut.bjVersion()
//sut.resolve("www.apple.com", type: kDNSServiceType_SRV)

/// DNS Parsing
enum DecodeError: Swift.Error {
    case invalidMessageSize
    case invalidLabelSize
    case invalidLabelOffset
    case unicodeDecodingError
    case invalidIntegerSize
    case invalidIPAddress
    case invalidDataSize
    case invalidQuestion
}

let testSRVRecord = "AAAAZABYCEtUVy1EQzAxBGphbWYDbmV0AA=="
let testrecord = Data(base64Encoded: testSRVRecord)!

extension BinaryInteger {
    init(data: Data, position: inout Data.Index) throws {
        let start = position
        guard data.formIndex(&position, offsetBy: MemoryLayout<Self>.size, limitedBy: data.endIndex) else {
            throw DecodeError.invalidIntegerSize
        }
        let bytes = Array(Data(data[start..<position]).reversed())
        self = bytes.withUnsafeBufferPointer {
            $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) {
                return $0.pointee
            }
        }
    }
}

var position = testrecord.startIndex
try Int16(data: testrecord, position: &position)
try Int16(data: testrecord, position: &position)
try Int16(data: testrecord, position: &position)
position

let name = testrecord[7...testrecord.endIndex - 1]
String(data: name, encoding: .utf8)
