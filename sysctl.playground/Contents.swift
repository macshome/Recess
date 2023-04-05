import Darwin

func getProcessList() {
    // Requesting the pid of 0 from systcl will return all pids
    var mib = [CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0]
    var bufferSize = 0

    // To find the needed buffer size you call sysctl with a nil results pointer.
    // This sets the size of the buffer needed in the bufferSize pointer.
    if sysctl(&mib, UInt32(mib.count), nil, &bufferSize, nil, 0) < 0 {
        perror(&errno)
        return
    }

    // Determine how many kinfo_proc struts were returned.
    // Using stride rather than size will take alligment into account.
    let entryCount = bufferSize / MemoryLayout<kinfo_proc>.stride

    // Create our buffer to be filled with the list of processes and allocate it.
    // Use defer to make sure it's deallocated when the scope ends.
    var procList: UnsafeMutablePointer<kinfo_proc>?
    procList = UnsafeMutablePointer.allocate(capacity: bufferSize)
    defer { procList?.deallocate() }

    // Now we actually perform our query to get all the processes.
    if sysctl(&mib, UInt32(mib.count), procList, &bufferSize, nil, 0) < 0 {
        perror(&errno)
        return
    }

    // Simply step through the returned bytes and lookup the data you want.
    // If the pid is 0 that means it's invalid and should be ignored.
    for index in 0...entryCount {
        guard let pid = procList?[index].kp_proc.p_pid,
              pid != 0,
              let comm = procList?[index].kp_proc.p_comm else {
            continue
        }

        // p_comm returns the first 16 characters of the process name as a tuple of CChars.
        // An easy way to convert it to to an array of CChars is with a Mirror.
        //
        // If you want the full names you can make another sysctl request for the KERN_PROCARGS2 mib
        // on each pid.
        let name = String(cString: Mirror(reflecting: comm).children.map(\.value) as! [CChar])
        print("PID: \(pid), Name: \(name)")
    }
}

getProcessList()
