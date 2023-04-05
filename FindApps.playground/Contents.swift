import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Simple class to search for things with `NSMetadataQuery`.
class Searcher {
    // This is just for timing things
    let startTime = Date()

    // Setup the bits we need to construct a Spotlight search
    let metadataSearch = NSMetadataQuery()

    // The simple predicate here is matching any bundle ID that starts with 'com.jamf.connect'
    let searchPredicate = NSPredicate(fromMetadataQueryString: "kMDItemCFBundleIdentifier == 'com.jamf.connect*'")

    // We only need to search the Data volume as we can't install on the system one.
    let dataVolume = URL(fileURLWithPath: "/System/Volumes/Data")

    // In init we use the properties we just created.
    init() {
        self.metadataSearch.predicate = self.searchPredicate
        self.metadataSearch.searchScopes = [self.dataVolume]

        // I'm grouping results here, but that's because this code is from a different project.
        // This will show us which bundle ID is in what type of file bundle though.
        self.metadataSearch.groupingAttributes = ["kMDItemContentType"]

        // Metadata Queries are async and we listen for updates. In this case just that the search finished.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(done),
                                               name: .NSMetadataQueryDidFinishGathering,
                                               object: self.metadataSearch)
    }

    func startSearch() {
        // Just a wrapper to start the search.
        metadataSearch.start()
    }
    func stopSearch() {
        // Stop the search and the playground.
        metadataSearch.stop()
        PlaygroundPage.current.finishExecution()
    }

    // Simple method to be called when the search is done and print results.
    @objc func done()  {
        // Just our search time for utility.
        let time = Date().timeIntervalSince(startTime)

        // How many results did we find?
        let count = metadataSearch.resultCount
        print("Found \(count) results on APFS Data volume in \(time) seconds.\n")

        // Look at each group of results and print out the paths.
        for group in metadataSearch.groupedResults {
            print("Found: \(group.resultCount) of type: \(group.value)\n")
            if group.resultCount < 10 {
                for item in group.results {
                    let mdItem = item as! NSMetadataItem
                    print("Path: \(mdItem.value(forAttribute: kMDItemPath as String) as Any)")
                }
            }
        }
        // Stop the search as we are all done.
        stopSearch()
    }
}

let foo = Searcher()

foo.startSearch()
