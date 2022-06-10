//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class JCNetworkMonitor {

    typealias NetworkChangeAction = () -> ()

    var whenReachable: NetworkChangeAction?
    var whenUnreachable: NetworkChangeAction?
    var networkChanged: NetworkChangeAction?

    public enum MonitorStatus {
        case started
        case stopped
        case alreadyRunning
    }

    public enum InternetStatus {
        case online
        case offline
        case refresh
    }

    var networkStatus: InternetStatus = .offline {
        didSet {
            if oldValue == networkStatus {
                print("Network change without status change. isOnline is still: \(networkStatus)")
                reachabilityChanged(.refresh)
            } else {
                print("Updated isOnline to \(networkStatus)")
                reachabilityChanged(networkStatus)
            }
        }
    }

    let cfNotificationName = "com.apple.system.config.network_change"
    var cfSelf: UnsafeRawPointer?
    let cfCallback: CFNotificationCallback = { (cfnc, observer, name, _, _) -> Swift.Void in
        if let observer = observer, let name = name {
            let instance = Unmanaged<JCNetworkMonitor>.fromOpaque(observer).takeUnretainedValue()
            instance.checkNotification(name.rawValue as String)
        }
    }

    var isFirstNotification = true
    var rateLimit = 2.0
    var isRunning = false
    var noteLastTimestamp = Date()

    init() {
        self.cfSelf = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        checkNotification(cfNotificationName)
    }

    deinit {
        self.removeObserver()
    }

    func reachabilityChanged(_ status: InternetStatus) {
        switch status {
        case .online:
            self.whenReachable?()
        case .offline:
            self.whenUnreachable?()
        case .refresh:
            self.networkChanged?()
        }
    }

    func networkRefresh() {
        self.networkChanged?()
    }

    @discardableResult public func startNetworkMonitor(_ rateLimit: TimeInterval = 2.0) -> MonitorStatus {
        self.rateLimit = rateLimit

        if isRunning {
            return .alreadyRunning
        }
        registerObserver()
        isRunning = true
        return .started
    }

    @discardableResult public func stopNetworkMonitor() -> MonitorStatus {
        if isRunning {
            removeObserver()
            isRunning = false
            return .stopped
        }
        return .stopped
    }

    func checkNotification(_ name: String) {
        if name == cfNotificationName, rateLimitCheck() {
            checkNetwork()
        }
    }

    func checkNetwork() {
        guard let url = URL(string: "https://www.google.com") else { return }

        URLSession(configuration: .ephemeral).dataTask(with: url) { (_, response, error) in
            if let error = error as? URLError {
                print(error.localizedDescription)
                self.networkStatus = .offline
            }
            if response != nil {
                self.networkStatus = .online
            }
        }.resume()

    }

    func rateLimitCheck() -> Bool {
        if isFirstNotification {
            isFirstNotification = false
            return true
        }

        let timeCalled = Date()
        if timeCalled.timeIntervalSince(noteLastTimestamp) > rateLimit {
            noteLastTimestamp = Date()
            return true
        }
        return false
    }

    func registerObserver() {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        cfSelf,
                                        cfCallback,
                                        cfNotificationName as CFString,
                                        nil,
                                        .deliverImmediately)
    }

    func removeObserver() {
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), cfSelf, nil, nil)
    }
}

protocol Reachable {
    var networkMonitor: JCNetworkMonitor { get }
    func networkChanged()
}
extension Reachable {
  @discardableResult func startNetworkMonitor() -> JCNetworkMonitor.MonitorStatus {
        networkMonitor.whenReachable = { self.networkChanged() }
        networkMonitor.whenUnreachable = { self.networkChanged() }
        networkMonitor.networkChanged = { self.networkChanged() }
        return networkMonitor.startNetworkMonitor()
    }

 @discardableResult func stopNetworkMontior() -> JCNetworkMonitor.MonitorStatus {
       return networkMonitor.stopNetworkMonitor()
    }
}

class Observer: Reachable {
    var networkMonitor = JCNetworkMonitor()

    init() {
        startNetworkMonitor()
        networkMonitor.networkChanged = { self.networkRefreshed() }
    }

    func networkChanged() {
        print("whenReachable fired")
    }

    func networkRefreshed() {
        print("Refresh fired")
    }

}

let obs = Observer()
