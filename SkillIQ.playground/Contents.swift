import Foundation

func compute(_ input: Int, completion: @escaping (Int) -> Void) -> Int {
    var result = input - 1
    DispatchQueue.main.async {
        result += 1
        completion(result % 2)
    }
    return result
}
let x = compute(43) { _ in }
