//: Playground - noun: a place where people can play

import Cocoa
import IOKit.network
import SystemConfiguration

let root = IORegistryGetRootEntry(kIOMasterPortDefault)
let consoleUsers = IORegistryEntryCreateCFProperty(root,
                                  "IOConsoleUsers" as CFString,
                                  kCFAllocatorDefault,
                                  0).takeUnretainedValue().lastObject as! Dictionary<String, AnyObject>

consoleUsers[kCGSessionUserNameKey]
consoleUsers["kCGSessionLongUserNameKey"]

public extension Host {

    var deviceIdentifier: String { String(bytes: getIOPlatformData("product-name"), encoding: .utf8) ?? "no id found" }
    var macAddress: String { getMacAddress() }
    var serialNumber: String { getIOPlatformString(kIOPlatformSerialNumberKey) }
    var uuid: String { getIOPlatformString(kIOPlatformUUIDKey) }
    var osVersionString: String { ProcessInfo.processInfo.operatingSystemVersionString }
    var coreCount: Int { ProcessInfo.processInfo.processorCount }
    var phyisicalMemory: Int { Int((((ProcessInfo.processInfo.physicalMemory / 1024) / 1024) / 1024)) }
    var consoleUser: String? { getCurrentUser() }

    private var platformExpert: io_service_t {
        IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
    }

    private func getIOPlatformString(_ key: String) -> String {
        IORegistryEntryCreateCFProperty(platformExpert,
                                        key as CFString,
                                        kCFAllocatorDefault,
                                        0).takeUnretainedValue() as! String
    }

    private func getIOPlatformData(_ key: String) -> Data {
        IORegistryEntryCreateCFProperty(platformExpert,
                                        key as CFString,
                                        kCFAllocatorDefault,
                                        0).takeUnretainedValue() as! Data
    }

    private func getCurrentUser() -> String? {
        guard let consoleUser = SCDynamicStoreCopyConsoleUser(nil, nil, nil) else {
            return nil
        }
        return consoleUser as String
    }

    private func getMacAddress() -> String {
        let matchingDir = IOBSDNameMatching(kIOMasterPortDefault, 0, "en0")
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, matchingDir)

        guard let data = IORegistryEntryCreateCFProperty(io_registry_entry_t(service),
                                                         kIOMACAddress as CFString,
                                                         kCFAllocatorDefault,
                                                         0).takeUnretainedValue() as? Data else {
                                                            return "No en0 MAC address found"
        }
        return String(format: "%02x:%02x:%02x:%02x:%02x:%02x", data[0], data[1], data[2], data[3], data[4], data[5])
    }
}


Host.current().consoleUser
Host.current().uuid
Host.current().serialNumber
Host.current().deviceIdentifier
Host.current().macAddress
Host.current().osVersionString
Host.current().coreCount
Host.current().phyisicalMemory

