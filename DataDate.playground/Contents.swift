import Cocoa


var now = Date()
now.description
let nowData = Data(bytes: &now, count: MemoryLayout<Date>.size)
let tmpPath = URL(fileURLWithPath: "/tmp/nowData")
try nowData.write(to: tmpPath)

tmpPath.path
let readData = try NSData(contentsOf: tmpPath) as Data
let dataDate = readData.withUnsafeBytes { $0.load(as: Date.self) }
dataDate

