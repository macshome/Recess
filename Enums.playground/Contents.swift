import Cocoa


enum OperationType {
        case none, removeCertificate, unpairPhone

        func toString() -> String {
            switch self {
            case .none:
                return ""
            case .removeCertificate:
                return "Remove Certificate"
            case .unpairPhone:
                return "Unpair Phone"
            }
        }
    }
