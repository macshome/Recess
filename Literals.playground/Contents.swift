import Cocoa

var str = "Hello, playground"

func functionOne() {
    let location =  "File:  " + #file + ", Function: " + #function
    print(location)
}

functionOne()
