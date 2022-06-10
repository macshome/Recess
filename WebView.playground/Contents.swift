//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport
import WebKit

let nibFile = NSNib.Name("MyView")
var topLevelObjects:  NSArray

let web = WebView()
NSClassFromString("WebView")?.performSelector(onMainThread: Selector("_enableRemoteInspector") , with: nil, waitUntilDone: true)
topLevelObjects.adding(web)

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }

// Present the view in Playground
PlaygroundPage.current.liveView = views[0] as! NSView

