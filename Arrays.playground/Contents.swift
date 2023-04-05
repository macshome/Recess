import Cocoa

var testAry = ["--recursive", "--parallel", "--strict"]
print(testAry)
testAry.isEmpty

testAry.contains("bar")

testAry.filter { $0 != "--strict" }

if let idx = testAry.firstIndex(of: "bar") {
    testAry.remove(at: idx)
}

testAry
//foo

//
//extension Dictionary where Key == String {
//    public mutating func lowercaseKeys() {
//        for key in self.keys {
//            self[String(describing: key).lowercased() as Key] = self.removeValue(forKey: key)
//        }
//    }
//}
//
//let menuIndex = ["lastusername",
//                 "passwordexpiration",
//                 "connect",
//                 "changepassword",
//                 "resetpassword",
//                 "actions",
//                 "home",
//                 "shares",
//                 "getsoftware",
//                 "gethelp",
//                 "preferences",
//                 "about",
//                 "quit",
//                "quit"]
//
//var custom: [String: String]? = ["preferences": "Choices", "Quit": "Stop it!"]
//let quitItem = NSMenuItem()
//quitItem.title = "quitjamfconnect"
//quitItem.tag = 12
//
//menuIndex[12].lowercased()
////hidden.contains(shouldHide.title)
////menuIndex.firstIndex(of: shouldHide)
//func titleFor(_ menuItem: NSMenuItem) -> String {
//    guard let customItems = custom else {
//        return menuItem.title
//    }
//
//    if let customTitle = customItems[menuIndex[menuItem.tag]] {
//        return customTitle
//    }
//
//    let currentTitle = menuItem.title
//
//    if let customTitle = customItems[currentTitle] {
//        return customTitle
//    }
//
//
//
//    return currentTitle
//}
//
//custom?.lowercaseKeys()
//custom?["quit"]
//
//titleFor(quitItem)
//var newDict = [String: String]()
//
//for (key, value) in custom! {
//    newDict[key.lowercased()] = value
//}
//newDict["quit"]
//
//extension Array where Element: Hashable {
//
//    func filterDuplicates() -> Array<Element> {
//        var set = Set<Element>()
//        var filteredArray = Array<Element>()
//        for item in self {
//            if set.insert(item).inserted {
//                filteredArray.append(item)
//            }
//        }
//        return filteredArray
//    }
//}
//
//let newArray = Array(Set(menuIndex))
//print(newArray)
