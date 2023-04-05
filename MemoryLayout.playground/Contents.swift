import Foundation

// Playground for exploring memory layout in Swift.

// A simple struct
struct Foo {
    let a: Int?
    let b: Int?
    var isTrue = true
}

// Two instances
var bar = Foo(a: nil, b: 123)
var baz = Foo(a: 100, b: Int.max, isTrue: false)

// Always use the static values when asking about a type.
MemoryLayout<Foo>.size
MemoryLayout<Foo>.stride
MemoryLayout<Foo>.alignment

// The layout of the structs are the same, regardless if the values are nil or not.
// The size of the struct depends on the data inside it.
MemoryLayout.size(ofValue: bar)
MemoryLayout.stride(ofValue: bar)
MemoryLayout.alignment(ofValue: bar)

MemoryLayout.size(ofValue: baz)
MemoryLayout.stride(ofValue: baz)
MemoryLayout.alignment(ofValue: baz)

// Use the offset to find where inside the bytes a value is located.
// This shows the byte at which each value is stored.
MemoryLayout<Foo>.offset(of: \Foo.a)
MemoryLayout<Foo>.offset(of: \Foo.b)
MemoryLayout<Foo>.offset(of: \Foo.isTrue)


// Always use the stride when getting the byte count of a type.
let barBytes = Data(bytes: &bar,
                    count: MemoryLayout<Foo>.stride)

// You can use subscript to read bytes from the data. Each byte is a UInt8 value.
barBytes[0]
barBytes[16]
barBytes[25]

// Don't use size for the count when manually looking inside bytes.
// You might end up starting to read the next object too early.
let bazBytes = Data(bytes: &baz,
                    count: MemoryLayout<Foo>.stride)
bazBytes[0]
bazBytes[16]
bazBytes[25]

// Int on Swift is 64-bits so it is larger than one byte can hold.
bazBytes[16]
baz.b

// Because of that you need to read all 8 bytes of the storage.
// Slice out just the bytes for `baz.b` as a Data chunk and convert to an int.
let bBytes = bazBytes[16...23]

// Swift Int is also little endian. To convert bytes back to an Int we need to specify that.
Int(littleEndian: bBytes.withUnsafeBytes { $0.pointee } )
