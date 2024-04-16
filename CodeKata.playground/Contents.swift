//: Playground - noun: a place where people can play
func minValue(_ numbers: Int...) -> Int {
    let uniquedNumbers = Array(Set(numbers)).sorted()
    return uniquedNumbers.reduce(0) {$0 * 10 + $1}
}

minValue(1, 9, 3, 1, 7, 4, 6, 6, 7)
