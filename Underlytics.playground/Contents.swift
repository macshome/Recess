
protocol EventRecording {
    func recordEvent(_ eventName: String)
}

extension EventRecording {
    func recordEvent(_ eventName: String = #function) {
        print(eventName)
    }
}

struct TestStruct: EventRecording {

    func testEvent(_ isThisATest: Bool) {
        recordEvent()
    }
}

class TestClass: EventRecording {
    func recordEvent() {

    }

    func testEvent() {
        print("test")
    }
}

let foo = TestStruct()
foo.testEvent(true)

