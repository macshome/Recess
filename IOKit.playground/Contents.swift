//: Playground - noun: a place where people can play

import IOKit


private var platformExpert: io_service_t {
    IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
}

func getIOPlatformString(_ key: String) -> String {
    guard let iopString = IORegistryEntryCreateCFProperty(platformExpert,
                                                          (key as! CFString),
                                                          kCFAllocatorDefault,
                                                          0).takeUnretainedValue() as? String else {
        return "foo"
    }
    return iopString
}

getIOPlatformString("IOPlatformUUID")
