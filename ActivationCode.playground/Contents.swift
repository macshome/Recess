import Foundation
let codeMap = ["0123456789ABCDEF0123456789ABCDEF0",
               "BCDEF00123456789ABCDEF0123456789A",
               "789ABCDEF00123456789ABCDEF0123456",
               "456789ABCDEF00123456789ABCDEF0123",
               "DEF00123456789ABCDEF0123456789ABC",
               "3456789ABCDEF00123456789ABCDEF012",
               "6789ABCDEF00123456789ABCDEF012345",
               "123456789ABCDEF0123456789ABCDEF00",
               "DEF00123456789ABCDEF0123456789ABC",
               "F0123456789ABCDEF00123456789ABCDE",
               "56789ABCDEF0123456789ABCDEF001234",
               "89ABCDEF0123456789ABCDEF001234567",
               "23456789ABCDEF00123456789ABCDEF01",
               "CDEF0123456789ABCDEF00123456789AB",
               "ABCDEF0123456789ABCDEF00123456789",
               "EF00123456789ABCDEF0123456789ABCD"]

let alpahbet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ3456789"

func genrateActivationCode(seatCount: Int, renewalDate: String, productCode: Int, licenseType: Int, randomKey: Int, seperator: String) {

}

func customIndexOf(mapString: String, character: String, index: Int) {

}

let dateString = "05/22/2018"
let words = dateString.split(separator: "/")
let month = Int(words[0])
let day = Int(words[1])
let year = Int(words[2])

let seatCount = 300
let one = seatCount >> 8 | seatCount >> 16 | seatCount >> 24 | seatCount

let productCode = 2
let two = productCode >> 8 | productCode >> 16 | productCode >> 24 | productCode

let randomKey = 399
let three = randomKey >> 8 | randomKey >> 16 | randomKey >> 24 | randomKey

var acHash = productCode + one + two + three + month! + day! + year!
acHash &= 255

let mapString = codeMap[acHash % codeMap.count]
let pos = acHash % codeMap.count
let hex = String(format:"%X", productCode)


