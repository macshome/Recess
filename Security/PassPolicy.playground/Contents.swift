import OpenDirectory

var localNode: ODNode? {
    do {
        return try ODNode.init(session: ODSession.default(), type: ODNodeType(kODNodeTypeLocalNodes))
    } catch {
        return nil
    }
}

let user = try? localNode?.record(withRecordType: kODRecordTypeUsers, name: NSUserName(), attributes: nil)

if let globalPolicy = try? localNode?.accountPolicies() {
    let policyDict = globalPolicy as NSDictionary
    let passwordPolicy = policyDict.value(forKeyPath: "policyCategoryPasswordContent.policyContent")
    print(passwordPolicy.debugDescription)
}

if let userPolicy = try? user?.recordDetails(forAttributes: ["accountPolicyData"]) {
    let policyDict = userPolicy as NSDictionary
    print(policyDict.description)
} else {
    print("no user policy set")
}


let count = try? user?.values(forAttribute: "accountPolicyData")

