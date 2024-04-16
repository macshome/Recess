import OpenDirectory

//var passPolicies: [AnyHashable: Any]

do {
    let node = try ODNode.init(session: ODSession.default(), type: ODNodeType(kODNodeTypeLocalNodes))
    let passPolicies = try node.accountPolicies()


for policy in passPolicies {
    print(policy)
                guard let policyContent = policy as? [String: String] else { continue }
                let predicate = NSPredicate(format: policyContent)
                let result = predicate.evaluate(with: password)
                print(result)
}

} catch {
    print(error.localizedDescription)
}
