import Cocoa

class Completer {

var pairingCompletion: (() -> Void)?

func willPair(completion: (() -> Void)?) {
    // When pairing via CLI pairing, completion is a call to exit
    // When pairing via GUI pairing, completion is nil
    // In either case, defining this completion signals is pairing
    // without need of making and managing an additional variable for this
    self.pairingCompletion = completion ?? { /* is pairing */ }
}
}

let foo = Completer()

foo.willPair(completion: nil)
foo.pairingCompletion 
