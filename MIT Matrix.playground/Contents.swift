import Foundation

let n = 40
let rand = { Double.random(in: 0...1) }

var start = Date.now

let A = Array(repeating: Array(repeating: rand(), count: n), count: n)
print("Array A created in \(String(format: "%0.6f", Date().timeIntervalSince(start))) seconds")

start = Date.now
let B = Array(repeating: Array(repeating: rand(), count: n), count: n)
print("Array B created in \(String(format: "%0.6f", Date().timeIntervalSince(start))) seconds")

start = Date.now
var C = Array(repeating: Array(repeating: 0.0, count: n), count: n)
print("Array C created in \(String(format: "%0.6f", Date().timeIntervalSince(start))) seconds")

start = Date.now

for i in 0..<n {
    for k in 0..<n {
        for j in 0..<n {
            C[i][j] += A[i][k] * B[k][j]
        }
    }
}

print("Loop executed in: \(String(format: "%0.6f", Date().timeIntervalSince(start))) seconds")
