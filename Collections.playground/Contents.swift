
//let s1 = Set([1,2,3])
//let s2 = Set([4,5,6])
//let s3 = Set([s1, s2])
//
//s3.isSuperset(of: s3) && s3.isSubset(of: s3)
//s3.contains(s1) && s3.contains(s2)

let digits = /[0-9+]/

let testData = """
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
  """

let numbers = testData.split(separator: "\n").map {
    var firstNumber = String(($0.firstMatch(of: digits)?.first)!)
    guard $0.matches(of: digits).count > 1 else {
        return Int(firstNumber)!
    }

    firstNumber += String((String($0.reversed()).firstMatch(of: digits)?.first)!)
    return Int(firstNumber)!
} as [Int]

