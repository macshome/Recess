
struct Analytics {
    enum Events {
        case loginSucceeded
        case loginFailed(reason: String)
        case calltrace(function: String = #function)
    }
}

extension Analytics.Events {
    var name: String {
        switch self {
        case .calltrace:
            return "callTrace"
        case .loginFailed:
            return "loginFailed"
        default:
            return String(describing: self)
        }
    }

    var userInfo: [String : String] {
        switch self {
        case .calltrace(let function):
            return ["methodCalled" : function]
        case .loginFailed(let reason):
            return ["error": reason]
        default:
            return [:]
        }
    }
}

extension Analytics {
    struct Manager {
        private let engine: AnalyticEngine

        init(engine: AnalyticEngine) {
            self.engine = engine
        }

        func record(_ event: Analytics.Events) {
            engine.postEvent(named: event.name, userInfo: event.userInfo)
        }
    }
}

protocol AnalyticEngine {
    func postEvent(named name: String, userInfo: [String : String])
}

protocol Traceable {
    var analytics: Analytics.Manager { get }
}



struct TestEngine: AnalyticEngine {
    func postEvent(named name: String, userInfo: [String : String]) {
        print(name, userInfo)
    }
}


class TestClass: Traceable {
    var analytics: Analytics.Manager

    init(analytics: Analytics.Manager) {
        self.analytics = analytics
    }

   func login() {
    analytics.record(.loginSucceeded)
    }

    func failed() {
        analytics.record(.loginFailed(reason: "Bad cheese."))
    }

    func traceThis(_ input: String)  {
        analytics.record(.calltrace())

    }
}


let sut = TestClass(analytics: Analytics.Manager(engine: TestEngine()))

sut.login()

sut.traceThis("A string")
sut.failed()
