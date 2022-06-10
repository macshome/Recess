import Cocoa
enum UIState: CaseIterable {
    case busy
    case notReady
    case passwordChange
    case ready
}

extension UIState {
    enum UIState {
        case foo
    }
}

class Foo {


    var uiState = UIState.UIState.foo

}


let test = Foo()

test.uiState = .busy

test.uiState

test.uiState = .ready
test.uiState
