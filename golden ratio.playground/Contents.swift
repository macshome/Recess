//: Playground - noun: a place where people can play

import Cocoa

func goldenRatio() {
    var x: Double = 0
    var y: Double = 1
    for _ in 1 ... 100 {
        print(x + y)
        let newValue = x + y
        x = y
        y = newValue
    }
}

goldenRatio()


