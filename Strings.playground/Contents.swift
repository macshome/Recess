import Foundation

var path: String? = "/App"
path?.cString(using: .utf8)
path?.utf8CString

let mockToken = "floop"
let mockStringData = "floop".data(using: .utf8)

let mockData = mockToken.data(using: .utf8) ?? Data()

