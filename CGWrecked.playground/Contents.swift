import Cocoa
import CoreGraphics

var rect1 = CGRect(x: 50, y: 50, width: 100, height: 20)
var rect2 = CGRect(x: 50, y: 50, width: 100, height: 20)

rect1 == rect2

var rect3 = CGRect(x: 50, y: 30, width: 100, height: 20)
var rect4 = CGRect(x: 50, y: 50, width: 100, height: 20)

rect3 == rect4

var rect5 = CGRect(x: 50, y: 30, width: 100, height: 20)
var rect6 = CGRect(x: 50, y: 50, width: 100, height: -20)

rect5 == rect6

rect5.maxX
rect5.maxY

rect6.maxX
rect6.maxY
