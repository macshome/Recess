import Cocoa
import DispatchIntrospection
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


var backgroundDispatchQueue = DispatchQueue(label: "test.foo", qos: .background, attributes: .concurrent)
var isEmpty = false

backgroundDispatchQueue.async {
    sleep(8)
    print("I can count to 8!")

}

backgroundDispatchQueue.async {
    sleep(2)
    print("I can count to 2!")

}

backgroundDispatchQueue.async(flags: .barrier) {
    print("All Done!")
    isEmpty = true
    PlaygroundPage.current.needsIndefiniteExecution = false
}

while isEmpty == false {
    print("Still working...")
    sleep(1)
}
