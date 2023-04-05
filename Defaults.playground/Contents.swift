import Foundation

func getManagedItems(defaults: UserDefaults) -> [String: Any] {
    let allItems = defaults.dictionaryRepresentation()
    return allItems.filter {
        defaults.objectIsForced(forKey: $0.key)
    }
}

let appID = "com.jamf.connect"
let localSettings = UserDefaults.standard.persistentDomain(forName: appID)!
let managedSettings = getManagedItems(defaults: UserDefaults(suiteName: appID)!)

print(managedSettings.keys)
