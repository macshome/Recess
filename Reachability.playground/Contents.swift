import Cocoa
import SystemConfiguration
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let host = "https://okta.okta.com"

class Reacher {
    var reachCheck = false
    var localOnly = false
    let reachCheckDate = Date()

    func checkInternetSCReachability() {
        OperationQueue.main.addOperation {


            let myReach = SCNetworkReachabilityCreateWithName(nil, host)
            var flag = SCNetworkReachabilityFlags.reachable
            print("Auth failed, checking for network access")

            if !SCNetworkReachabilityGetFlags(myReach!, &flag) {
                print("Can't determine reachability")
                self.localOnly = true
            }

            if (flag.rawValue != UInt32(kSCNetworkFlagsReachable)) {
                // network isn't reachable
                print("Network isn't reachable, falling back to local auth")
                self.localOnly = true
            }

            self.reachCheck = true
        }

        while !reachCheck && (abs(reachCheckDate.timeIntervalSinceNow) < 3) {
            RunLoop.main.run(mode: RunLoop.Mode.default, before: Date.distantFuture)
            print("Wait wait wait")
        }
        print("Checks finished")
    }

    func checkInternetURLSession() {

        let url = URL(string: host)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Some URLSession error happened: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let httpResponse = response as? HTTPURLResponse
                print("Didn't get a 200:OK from the server. Found: \(String(describing: httpResponse?.statusCode))")
                return
            }
            guard httpResponse.statusCode == 200 else {
                print("Didn't get a 200:OK from the server. Found: \(String(describing: httpResponse.statusCode))")
                return
            }
            print("Connection success")
        }
        task.resume()
    }

}

let pinger = Reacher()
//pinger.checkInternetSCReachability()
pinger.checkInternetURLSession()

