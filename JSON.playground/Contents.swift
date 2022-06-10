

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


struct Updates: Codable {
    let publicAssetSets, assetSets: AssetSets
    
    private enum CodingKeys: String, CodingKey {
        case publicAssetSets = "PublicAssetSets"
        case assetSets = "AssetSets"
    }
}

struct AssetSets: Codable {
    let updates: [Update]
    
    private enum CodingKeys: String, CodingKey {
        case updates = "iOS"
    }
}

struct Update: Codable {
    let productVersion, postingDate, expirationDate: String
    let supportedDevices: [String]
    
    private enum CodingKeys: String, CodingKey {
        case productVersion = "ProductVersion"
        case postingDate = "PostingDate"
        case expirationDate = "ExpirationDate"
        case supportedDevices = "SupportedDevices"
    }
}

class UpdateFetcher {
    var updateServiceData: Updates?
    
    func getCurrentUpdates() {
        let url = URL(string: "https://gdmf.apple.com/v2/pmv")!
        let downloader = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            
             if let mimeType = httpResponse.mimeType,
                mimeType == "application/json",
                let data = data {
                DispatchQueue.main.async {
                    self.updateServiceData = try? JSONDecoder().decode(Updates.self, from: data)
                    print(self.updateServiceData!.publicAssetSets.updates.first!)
                }
            }
        }
        downloader.resume()
    }
}

let fetcher = UpdateFetcher()
fetcher.getCurrentUpdates()
