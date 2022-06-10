import Cocoa
import Network
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//if let targetUrl = URL(string: "https://www.google.com") {
//    let endpoint = NWEndpoint.url(targetUrl)
//    let connection = NWConnection(to: endpoint, using: .tls)
//    connection.state
//    connection.start(queue: .main)
//    connection.state
//}

class NetworkMonitor {
    static let sharedInstance = NetworkMonitor()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")

    var currentGateways = [NWEndpoint]()

    func startMonitor() {
        monitor.pathUpdateHandler = {  [weak self] path in
            if path.status == .satisfied {
                if self?.currentGateways == path.gateways {
                    print("We refreshed on the same network")
                    
                } else {
                    print("Connected to a new network")
                }
                self?.currentGateways = path.gateways
            } else {
                print("No connection.")
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitor() {
        monitor.cancel()
    }
}
NetworkMonitor.sharedInstance.startMonitor()

