import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func fetchData(url: String) async throws -> (Data, URLResponse) {
    let url = URL(string: url)
    let request = URLRequest(url: url!)

    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = ["User-Agent" : "FakeAgent"]

    let session = URLSession(configuration: config)
    return try await session.data(for: request)
}

let start = Date()
let fetched = try await fetchData(url: "https://www.jamf.com")
let elapsed = -start.timeIntervalSince(Date())
print(fetched)
print("\nWas fetched in: \(elapsed) seconds.")

PlaygroundPage.current.finishExecution()
