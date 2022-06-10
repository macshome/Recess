import Cocoa
import CoreGraphics

let mainDisplay = CGMainDisplayID()
let currentDisplayMode = CGDisplayCopyDisplayMode(mainDisplay)
let avaliableDisplayModes = CGDisplayCopyAllDisplayModes(mainDisplay, nil)! as NSArray
for display in avaliableDisplayModes {
    let displayMode = display
    print(displayMode)
}
