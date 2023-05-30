import Foundation
import Darwin
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//let launchPath = "/bin/ls"
//let arguments = ["-la"]
//
//let process = Process()
//let pipe = Pipe()
//
//process.standardOutput = pipe
//process.standardError = pipe
//process.arguments = arguments
//process.launchPath = launchPath
//process.terminationHandler = { process in
//  let data = pipe.fileHandleForReading.readDataToEndOfFile()
//  let output = String(data: data, encoding: .utf8)
//  let exitCode = Int(process.terminationStatus)
//  print(output ?? "no output")
//}
//
//try? process.run()


try Process.run(URL(string: "file:///bin/ls")!, arguments: ["-al"]) { process in
    print("Exit code: \(process.terminationStatus)")
}
