//: Playground - noun: a place where people can play

import IOKit
import Foundation


private var platformExpert: io_service_t {
    IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
}

func getIOPlatformString(_ key: String) -> String {
    guard let iopString = IORegistryEntryCreateCFProperty(platformExpert,
                                                          (key as CFString),
                                                          kCFAllocatorDefault,
                                                          0).takeUnretainedValue() as? String else {
        return "foo"
    }
    return iopString
}


// Get crazy and hook Gestalt
public class MobileGestalt {

    public enum Query: String {
        case provisioningUDID = "ProvisioningUniqueDeviceID"
    }

    typealias MGCopyAnswer = @convention(c) (CFString) -> CFString?
    let handle: UnsafeMutableRawPointer?
    let copyAnswerRef: MGCopyAnswer?

    public init() {
        handle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_GLOBAL | RTLD_LAZY)
        if let handleRef = handle,
           let sym = dlsym(handleRef, "MGCopyAnswer") {
            copyAnswerRef = unsafeBitCast(sym, to: MGCopyAnswer.self)
        } else {
            copyAnswerRef = nil
        }
    }

    deinit {
        guard let handleRef = handle else { return }
        dlclose(handleRef)
    }

    public func getValue(for query: Query) -> String? {
        guard let ref = copyAnswerRef else { return nil }
        return ref(query.rawValue as NSString) as String?
    }
}

let gestalt = MobileGestalt()
gestalt.getValue(for: .provisioningUDID)
getIOPlatformString("IOPlatformUUID")


// This only works on ARM
func getProductDescriptionARM() -> String? {
    let appleSiliconProduct = IORegistryEntryFromPath(kIOMainPortDefault, "IOService:/AppleARMPE/product")
    let cfKeyValue = IORegistryEntryCreateCFProperty(appleSiliconProduct, "product-description" as CFString, kCFAllocatorDefault, 0)
    IOObjectRelease(appleSiliconProduct)
    let keyValue: AnyObject? = cfKeyValue?.takeUnretainedValue()
    if keyValue != nil, let data = keyValue as? Data {
        return String(data: data, encoding: String.Encoding.utf8)?.trimmingCharacters(in: CharacterSet(["\0"]))
    }
    return nil
}

getProductDescriptionARM()
