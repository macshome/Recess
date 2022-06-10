
/// Find the factors of an integer.
///
/// - Parameter dividend: The integer to be factored.
/// - Returns: An array of integers.

public func findFactors(of dividend: Int) -> [Int] {
    var factors = Set<Int>()
    for divisor in 1...dividend where dividend.isMultiple(of: divisor) {
        factors.insert(divisor)
    }
    return factors.sorted()
}

/// Find the greatest common divisor of two integers.
///
/// - Parameters:
///   - integerA: An integer.
///   - integerB: An integer.
/// - Returns: An integer.

public func findGreatestCommonDivisor(of integerA: Int, and integerB: Int) -> Int {
    let remainder = integerA % integerB
    if remainder != 0 {
        return findGreatestCommonDivisor(of: integerB, and: remainder)
    } else {
        return integerB
    }
}

/// Find the least common multiple of two integers.
///
/// - Parameters:
///   - integerA: An integer.
///   - integerB: An integer.
/// - Returns: An integer.

public func findLeastCommonMultiple(of integerA: Int, and integerB: Int) -> Int {
    var integerA = integerA
    let temp = integerA
    while integerA.isMultiple(of: integerB) == false {
        integerA += temp
    }
    return integerA
}

public enum Message: String {
    case invalidArguments = "Not enough or invalid arguments."
}


/// Writes the factors of one or more integers into the standard output.
///
/// - Parameter input: An array of strings.

public func showFactors(of input: [String]) {
//    let input = input
    guard input.count >= 2 else {
        return print("\(Message.invalidArguments.rawValue)")
    }
    for element in 1...input.count - 1 {
        guard let integer = Int(input[element]) else {
            return print("\(Message.invalidArguments.rawValue)")
        }
        let result = findFactors(of: integer)
        print("\(result)")
    }
}

/// Writes the greatest common divisor of two integers into the standard output.
///
/// - Parameter input: An array of strings.

public func showGreatestCommonDivisor(of input: [String]) {
//    let input = input
    guard input.count >= 3, let integerA = Int(input[1]), let integerB = Int(input[2]) else {
        return print("\(Message.invalidArguments.rawValue)")
    }
    let result = findGreatestCommonDivisor(of: integerA, and: integerB)
    print("[\(result)]")
}

/// Writes the least common multiple of two integers into the standard output.
///
/// - Parameter input: An array of strings.

public func showLeastCommonMultiple(of input: [String]) {
//    let input = input
    guard input.count >= 3, let integerA = Int(input[1]), let integerB = Int(input[2]) else {
        return print("\(Message.invalidArguments.rawValue)")
    }
    let result = findLeastCommonMultiple(of: integerA, and: integerB)
    print("[\(result)]")

}


let numbers = ["1", "4", "8", "200"]
showFactors(of: numbers)
showLeastCommonMultiple(of: numbers)
showGreatestCommonDivisor(of: numbers)

4.isMultiple(of: 2)
