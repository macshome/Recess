import Cocoa

func isDNDEnabled() -> Bool {
    // Some constants so we don't make typos
    let kPlistStorePath = "/Library/Preferences/com.apple.ncprefs.plist"

    //check for DND and return true if it is on

    // It's simpler to just use the Home directory function to get the logged in console user home.
    let ncPrefsUrl = URL(
        fileURLWithPath: String(NSHomeDirectory() + kPlistStorePath)
    )

    // If I don't know the layout of a plist, then I like to just read it directly into a Dict.
    if let prefs = NSDictionary(contentsOf: ncPrefsUrl) as? [String: Any],
       let dndPrefs = try? plistFromData(prefs["dnd_prefs"] as! Data),
       let userPrefs = dndPrefs["userPref"] as? [String: Any]
    {
        // If we got here we just return if it is enabled or not.
        return userPrefs["enabled"] as! Bool
    }

    // If we failed to find the prefs just return false.
    return false
}

func plistFromData(_ data: Data) throws -> [String:Any] {
    try PropertyListSerialization.propertyList(
        from: data,
        format: nil
    ) as! [String:Any]
}


isDNDEnabled()
