import Cocoa

if let mounts = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: [.volumeURLForRemountingKey], options: [] ) {
    mounts.map { mountURL in
        if let values = try? mountURL.resourceValues(forKeys: [.volumeURLForRemountingKey]), values.volumeURLForRemounting != nil {
            if let shareURL = values.volumeURLForRemounting {
                print(shareURL)
            }
        }
    }
}
