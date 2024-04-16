//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class BrowserDelegate: NSObject, NetServiceBrowserDelegate, NetServiceDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        print(domainString)
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print(service)
        service.delegate = self
        service.resolve(withTimeout: 5.0)
    }

    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("Starting to search")
    }

    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("I gave up searching")
    }

    func netServiceWillResolve(_ sender: NetService) {
        print("will resolve")

    }

    func netServiceDidResolveAddress(_ sender: NetService) {
        print("Did resolve")
    }

    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("Did not resolve")
        print(errorDict)
    }
}



let browser = NetServiceBrowser()
let del = BrowserDelegate()
browser.delegate = del

browser.searchForServices(ofType: "_kerberos._tcp.", inDomain: "jamf.net.")
//browser.searchForRegistrationDomains()
//browser.searchForServices(ofType: "_http._tcp.", inDomain: "local.")

//let service = NetService(domain: "jamf.net.", type: "_ldap._tcp.", name: "_ldap._tcp.jamf.net.")
//service.delegate = del
//service.schedule(in: .main, forMode: .common)
//service.resolve(withTimeout: 5.0)
