import Cocoa
import OpenDirectory

var localNode: ODNode? {
    do {
        return try ODNode.init(session: ODSession.default(), type: ODNodeType(kODNodeTypeLocalNodes))
    } catch {
        return nil
    }
}

if let policy = try? localNode?.accountPolicies() {
    let policyDict = policy as NSDictionary
    let passwordPolicy = policyDict.value(forKeyPath: "policyCategoryPasswordContent.policyContent")
    print(passwordPolicy)
}

//[NSString stringWithFormat:@"%@ matches '.{8,}+'", kODPolicyAttributePassword];
