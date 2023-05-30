import Cocoa

func usingWorkspace() -> String {
    var isRemovable = ObjCBool(false)
    var isWritable = ObjCBool(false)
    var isUnmountable = ObjCBool(false)
    var description: NSString?
    var type: NSString?

    if !NSWorkspace.shared.getFileSystemInfo(forPath: "/",
                                             isRemovable: &isRemovable,
                                             isWritable: &isWritable,
                                             isUnmountable: &isUnmountable,
                                             description: &description,
                                             type: &type) {
        return "Could not get info with NSWorkspace"
    }

    let result = "isRemovable: \(isRemovable)\nisWritable: \(isWritable)\nisUnmountable: \(isUnmountable)\nDescription: \(description!)\ntype: \(type!)"
    return result
}


print(usingWorkspace())

