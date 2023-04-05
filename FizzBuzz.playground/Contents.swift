import Foundation

//let arr1 = [1,2,3]
//DispatchQueue.concurrentPerform(iterations: 1000) { num in
//
//    var str = ""
//
//    if num % 3 == 0 {
//        str += "Fizz"
//    }
//
//    if num % 5 == 0 {
//        str += "Buzz"
//    }
//
//    if str.isEmpty { str = String(num) }
//    print(str)
//}

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

//let arr = ContiguousArray(1...1000)
//
//let start = Date()
//arr.withUnsafeBufferPointer { unsafedArray -> () in
//    unsafedArray.forEach() { i in
//        switch(i % 3 == 0, i % 5 == 0){
//        case (true, true):
//            print("FizzBuzz")
//        case (true, false):
//            print("Fizz")
//        case (false, true):
//            print("Buzz")
//        default:
//            print(i)
//        }
//    }
//}
//let stop = Date()
//print(stop.timeIntervalSince(start))

//let start = Date()
//for num in 1...1000 {
//
//    if num % 3 == 0 && num % 5 == 0 {
//    print("FizzBuzz")
//    }
//    if num % 3 == 0 {
//        print("Fizz")
//    }
//
//    if num % 5 == 0 {
//        print("Buzz")
//    }
//}
//let stop = Date()
//print(stop.timeIntervalSince(start))

let start = Date()

for _ in 1...1000 {
        print(12345)
}
let stop = Date()
print(stop.timeIntervalSince(start))
