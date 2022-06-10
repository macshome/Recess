import Cocoa
import OpenDirectory

struct LocalPassPolicyObject {
    let description: String?   // localized description of the rule
    let regEx: NSRegularExpression?    // regex of the rule
    var compliant: Bool    // is current proposed password compliant
}

// Class to read in local password policies and then test them against a proposed password

class LocalPassPolicy {

    let session = ODSession.default()   // OD session
    var policyRaw = [AnyHashable: Any]() // holds the raw policy from the node
    var policyClean = [LocalPassPolicyObject]()  // holds the policy after it's been interpreted

    var compliant = false // global if the proposed pass meets all requirements
    let currentLocale = NSLocale.current.languageCode // current language code
    var debug = false // enables debug messages

    init() {
        // get policy
        do {
            let node = try ODNode.init(session: session, type: ODNodeType(kODNodeTypeLocalNodes))
            policyRaw = try node.accountPolicies()
//            print(policyRaw)
            parsePolicy()
        } catch {
            // no local policy found
            // on any recent version of macOS, we should never get here
            // as all users should be required to have a 4 character password, which is listed as policy
//            logger.passwordPolicy.info(message: "No local policy found")
        }
    }

    func parsePolicy() {
        policyClean.removeAll()

        if policyRaw.count > 0 {
            for item in policyRaw {
                if let itemArray = item.value as? Array<Any> {
                    for each in itemArray {
                        if let policyItem = each as? [String: AnyObject] {

                            var description: String?
                            var regEx: NSRegularExpression?

                            if let desc = policyItem["policyContentDescription"] as? [String: String] {
                                if let text = desc[currentLocale ?? "English"] {
                                    description = text
                                } else {
                                    description = desc["en"]
                                }
                            }

                            if let content = policyItem["policyContent"] as? String {

                                //TODO: currently we can only match rules that are actual RegEx and the ascending characters rule is not, so we're ignoring it for now

                                if !content.contains("policyAttributePassword matches") {
                                    continue
                                }

                                let expression = content.replacingOccurrences(of: "policyAttributePassword matches ", with: "").replacingOccurrences(of: "'", with: "")

                                regEx = try? NSRegularExpression.init(pattern: expression, options: .init(rawValue: 0))
                            }

                            policyClean.append(LocalPassPolicyObject(description: description, regEx: regEx, compliant: false))
                            print(policyClean)
                        }
                    }
                }
            }
        }
    }

    /// Validates a proposed password against the current rule set
    ///
    /// - Parameter pass: String - proposed password to test
    /// - Returns: Bool - if proposed password is compliant
    func validatePass(pass: String) -> Bool {

        compliant = true

        // Make sure that we have a policy to check
        if policyClean.isEmpty { return compliant }

        for item in 0...(policyClean.count - 1) {
            if ((policyClean[item].regEx?.numberOfMatches(in: pass, options: .anchored, range: NSMakeRange(0, pass.count))) ?? 0 ) > 0 {
                policyClean[item].compliant = true

//                logger.passwordPolicy.debug(message: "Item: \(policyClean[item].description ?? "")")
//                logger.passwordPolicy.debug(message: "True")
            } else {
                compliant = false
//                logger.passwordPolicy.debug(message: "Item: \(policyClean[item].description ?? "")")
//                logger.passwordPolicy.debug(message: "False")
            }
        }
        return compliant
    }

    func builtInValidate(pass: String) -> Bool {
        do {
            let node = try ODNode.init(session: session, type: ODNodeType(kODNodeTypeLocalNodes))
            try node.passwordContentCheck(pass, forRecordName: "")
            return true
        } catch  {
            print(error.localizedDescription)
        }
        return false
    }
}

let testPolicy = LocalPassPolicy()

testPolicy.validatePass(pass: "12333")
testPolicy.builtInValidate(pass: "123")
