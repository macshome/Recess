import Cocoa
import AVFoundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


if let device = AVCaptureDevice.default(for: .audio) {
    let formatDescription = device.activeFormat.formatDescription
//    print(formatDescription)

    device.observe(\AVCaptureDevice.activeFormat, options: .new) { format, change in
        print("Format is now \(formatDescription)")
    }
}

