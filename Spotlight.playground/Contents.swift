import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class Searcher {
    let startTime = Date()
    
    let metadataSearch = NSMetadataQuery()
    let searchPredicate = NSPredicate(fromMetadataQueryString: "kMDItemContentTypeTree == 'public.executable' ||  kMDItemContentTypeTree == 'public.shell-script'")
    let dataVolume = URL(fileURLWithPath: "/System/Volumes/Data")
    
    init() {
        self.metadataSearch.predicate = self.searchPredicate
        self.metadataSearch.searchScopes = [self.dataVolume]
        self.metadataSearch.groupingAttributes = ["kMDItemContentType"]
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(done),
                                               name: .NSMetadataQueryDidFinishGathering,
                                               object: self.metadataSearch)
    }
    
    func startSearch() {
        metadataSearch.start()
    }
    func stopSearch() {
        metadataSearch.stop()
        NotificationCenter.default.removeObserver(self)
        PlaygroundPage.current.finishExecution()
    }
    
    @objc func done()  {
        let time = Date().timeIntervalSince(startTime)
        
        let count = metadataSearch.resultCount
        print("Found \(count) results on APFS Data volume in \(time) seconds.")
        
        for group in metadataSearch.groupedResults {
            print("Found: \(group.resultCount) of type: \(group.value)")
            if group.resultCount < 10 {
                for item in group.results {
                    print((item as! NSMetadataItem).value(forAttribute: kMDItemPath as String))
                }
                
            }
            
        }
        
        let firstItemAttrs = metadataSearch.results.randomElement() as! NSMetadataItem
        if let value = firstItemAttrs.value(forAttribute: kMDItemPath as String) {
            print(value)
            print(firstItemAttrs.attributes)
        }
        stopSearch()
    }
}

let foo = Searcher()

foo.startSearch()
