import Cocoa

var greeting = "Hello, playground"

dynamic func foo(){
   
}

@_dynamicReplacement(for: foo)
func bar() {
    
}

foo()
