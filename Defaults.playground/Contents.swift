import Foundation

if let diagDefaults = UserDefaults.standard.persistentDomain(forName: "com.apple.security.tokenlogin") {
    let data = diagDefaults["3F667154071B6DED593619213ACBEBA56E27412E"] as! Data
   let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
    print(plist)
}

