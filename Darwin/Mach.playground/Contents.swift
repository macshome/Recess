import Darwin.Mach

struct PreviousPorts {
    static var masks: UInt32 = 0
    static var ports: UInt32 = 0
    static var behaviors: UInt32 = 0
    static var flavors: UInt32 = 0
    static var count: mach_msg_type_number_t = 0
}

let thisTask = mach_task_self_
var result: kern_return_t = 0

func setExceptionPort() {
    var exceptionPort = mach_msg_type_name_t(MACH_PORT_NULL)

    let mask = exception_mask_t(EXC_MASK_BAD_ACCESS | EXC_MASK_BAD_INSTRUCTION | EXC_MASK_ARITHMETIC | EXC_MASK_SOFTWARE | EXC_MASK_BREAKPOINT)

    result = task_get_exception_ports(thisTask, mask, &PreviousPorts.masks, &PreviousPorts.count, &PreviousPorts.ports, &PreviousPorts.behaviors, &PreviousPorts.flavors)
    if result != KERN_SUCCESS {
        print("Couldn't get current exception ports")
    }

    if exceptionPort == MACH_PORT_NULL {
        result = mach_port_allocate(thisTask, MACH_PORT_RIGHT_RECEIVE, &exceptionPort)
        if result != KERN_SUCCESS {
            print("Couldn't create new port")
        }

        result = mach_port_insert_right(thisTask, exceptionPort, exceptionPort, mach_msg_type_name_t(MACH_MSG_TYPE_MAKE_SEND))
        if result != KERN_SUCCESS {
            print("Couldn't insert port right")
        }
    }

    //let kr = task_set_exception_ports(thisTask, mask, exceptionPort, (EXCEPTION_DEFAULT | Int32(truncatingIfNeeded: MACH_EXCEPTION_CODES)), THREAD_STATE_NONE)
    //kr
}

//setExceptionPort()
