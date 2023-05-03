import Foundation
import Darwin
import PlaygroundSupport

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true

class A: NSObject {
    var task: Process?
    var slaveFile: FileHandle?
    var masterFile: FileHandle?
    var slavePath = ""

    override init() {
        self.task = Process()
        var masterFD: Int32 = 0
        masterFD = posix_openpt(O_RDWR)
        grantpt(masterFD)
        unlockpt(masterFD)
        self.masterFile = FileHandle.init(fileDescriptor: masterFD)
        self.slavePath = String.init(cString: ptsname(masterFD))
        self.slaveFile = FileHandle.init(forUpdatingAtPath: slavePath)
        self.task!.executableURL = URL(fileURLWithPath: "/bin/sh")
//        self.task!.arguments = ["-c", "say foobar"]
        self.task!.standardOutput = slaveFile
        self.task!.standardInput = slaveFile
        self.task!.standardError = slaveFile
    }

    func run() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }
            do {
                try self.task!.run()
            } catch {
                print("Something went wrong.\n")
            }
        }
        let data = self.masterFile!.availableData
        let strData = String(data: data, encoding: .utf8)
        print("Output: " + strData!)
        sleep(1)
        self.masterFile!.write("echo foo\n".data(using: .utf8)!)
        slavePath
        sleep(1)
        let data1 = self.masterFile!.availableData
        let strData1 = String(data: data1, encoding: .utf8)!
        print("Output: "+strData1)
    }
}

let a = A()
a.run()
