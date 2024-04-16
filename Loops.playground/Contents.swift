import Cocoa

var greeting = "Hello, playground"

for (index, value) in greeting.enumerated() {
    if index > 10 { break }
    print("\(value) at index: \(index)")
}

for index in greeting.indices {
    print("\(greeting[index]) at index: \(index)")
    print(greeting[greeting.index(greeting.startIndex, offsetBy: 4)])
}

//repeat {
//
//} while true
