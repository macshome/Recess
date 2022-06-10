import Cocoa
import SystemConfiguration
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

class Reacher {
    var reachCheck = false
    var localOnly = false
    let reachCheckDate = Date()

    func checkInternet() {
        OperationQueue.main.addOperation {

            let host = "okta.okta.com"
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
}

let pinger = Reacher()
pinger.checkInternet()
