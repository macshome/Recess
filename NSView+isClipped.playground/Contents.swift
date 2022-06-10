import Cocoa

extension NSView {
    var isClipped: Bool {
        set {
            view.wantsLayer = true
            layer?.masksToBounds = newValue
        }
        get {
            guard let layer = layer else {
                return false
            }
            return layer.masksToBounds
        }
    }
}

let view = NSView()

view.isClipped
view.layer?.masksToBounds

view.isClipped = true
view.isClipped
view.layer?.masksToBounds

view.isClipped = false
view.isClipped
view.layer?.masksToBounds


