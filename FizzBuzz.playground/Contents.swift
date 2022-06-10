import Foundation

let arr1 = [1,2,3]
DispatchQueue.concurrentPerform(iterations: 1000) { num in

    var str = ""

    if num % 3 == 0 {
        str += "Fizz"
    }

    if num % 5 == 0 {
        str += "Buzz"
    }

    if str.isEmpty { str = String(num) }
    print(str)

}

//for num in 1...1000 {
//    let ptr = UnsafeMutablePointer<String>.allocate(capacity: 8)
//    ptr.initialize(to: "")
//
//    if num % 3 == 0 {
//        ptr.pointee += "Fizz"
//    }
//
//    if num % 5 == 0 {
//        ptr.pointee += "Buzz"
//    }
//
//    if ptr.pointee.isEmpty { ptr.pointee = String(num) }
//    print(ptr.pointee)
//}


