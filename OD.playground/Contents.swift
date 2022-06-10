import OpenDirectory

let kODAttributeOktaUser = "dsAttrTypeStandard:OktaUser" // deprecated in favor of kODAttributeIdPUser
let kODAttributeIdPUser = "dsAttrTypeStandard:NetworkUser"

enum DSQueryableResults: Error {
    case localUser
    case notLocalUser
}

enum DSQueryableErrors: Error {
    case noLocalUsersFound
    case multipleUsersFound
}

/// The `DSQueryable` protocol allows adopters to easily search and manipulate the DSLocal node of macOS.
public protocol DSQueryable {}

// MARK: - Implimentations for DSQuerable protocol
public extension DSQueryable {

    /// `ODNode` to DSLocal for queries and account manipulation.
    var localNode: ODNode? {
        do {
            // // logger.openDirectory.debug(message: "File: " + #file + ", Function: " + #function  + ":  Finding the DSLocal node.")
            return try ODNode.init(session: ODSession.default(), type: ODNodeType(kODNodeTypeLocalNodes))
        } catch {
            // // logger.openDirectory.error(message: "File: " + #file + ", Function: " + #function  + ":  ODError creating local node.")
            return nil
        }
    }

    /// Conviennce function to discover if a shortname has an existing local account.
    ///
    /// - Parameter shortName: The name of the user to search for as a `String`.
    /// - Returns: `true` if the user exists in DSLocal, `false` if not.
    /// - Throws: Either an `ODFrameworkErrors` or a `DSQueryableErrors` if there is an error or the user is not local.
    func isUserLocal(_ shortName: String) throws -> Bool {
        // // logger.openDirectory.debug(message: "File: " + #file + "running, Function: " + #function)
        do {
            _ = try getLocalRecord(shortName)
        } catch DSQueryableResults.notLocalUser {
            return false
        } catch {
            throw error
        }
        return true
    }

    /// Checks a local username and password to see if they are valid.
    ///
    /// - Parameters:
    ///   - userName: The name of the user to search for as a `String`.
    ///   - userPass: The password for the user being tested as a `String`.
    /// - Returns: `true` if the name and password combo are valid locally. `false` if the validation fails.
    /// - Throws: Either an `ODFrameworkErrors` or a `DSQueryableErrors` if there is an error.
    func isLocalPasswordValid(userName: String, userPass: String) throws -> Bool {
        // // logger.openDirectory.debug(message: "File: " + #file + "running, Function: " + #function)
        do {
            let userRecord = try getLocalRecord(userName)
            try userRecord.verifyPassword(userPass)
        } catch {
            let castError = error as NSError
            switch castError.code {
            case Int(kODErrorCredentialsInvalid.rawValue):
                // // logger.openDirectory.info(message: "File: " + #file + "running, Function: " + #function  + ":  Tested password for user account: \(userName) is not valid.")
                return false
            default:
                throw error
            }
        }
        return true
    }

    /// Searches DSLocal for an account short name and returns the `ODRecord` for the user if found.
    ///
    /// - Parameter shortName: The name of the user to search for as a `String`.
    /// - Returns: The `ODRecord` of the user if one is found in DSLocal.
    /// - Throws: Either an `ODFrameworkErrors` or a `DSQueryableErrors` if there is an error or the user is not local.
    func getLocalRecord(_ shortName: String) throws -> ODRecord {
        // // logger.openDirectory.debug(message: "File: " + #file + "running, Function: " + #function)
        do {
            // // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  Building OD query for name \(shortName)")
            let query = try ODQuery.init(node: localNode,
                                         forRecordTypes: kODRecordTypeUsers,
                                         attribute: kODAttributeTypeGUID,
                                         matchType: ODMatchType(kODMatchEqualTo),
                                         queryValues: shortName,
                                         returnAttributes: kODAttributeTypeNativeOnly,
                                         maximumResults: 0)
            let records = try query.resultsAllowingPartial(false) as! [ODRecord]

            if records.count > 1 {
                // // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  More than one local user found for name.")
                throw DSQueryableErrors.multipleUsersFound
            }
            guard let record = records.first else {
                // // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  No local user found.")
                throw DSQueryableResults.notLocalUser
            }
            // // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  Found local user: \(record).")
            return record
        } catch {
//            // // logger.openDirectory.error(message: "File: " + #file + ", Function: " + #function  + ":  ODError while trying to check for local user: \(error.localizedDescription).")
            throw error
        }
    }

    /// Finds all local user records on the Mac.
    ///
    /// - Returns: A `Array` that contains the `ODRecord` for every account in DSLocal.
    /// - Throws: An error from `ODFrameworkErrors` if something fails.
    func getAllLocalUserRecords() throws -> [ODRecord] {
//        // // logger.openDirectory.debug(message: "File: " + #file + "running, Function: " + #function)
        do {
            let query = try ODQuery.init(node: localNode,
                                         forRecordTypes: kODRecordTypeUsers,
                                         attribute: kODAttributeTypeRecordName,
                                         matchType: ODMatchType(kODMatchEqualTo),
                                         queryValues: kODMatchAny,
                                         returnAttributes: kODAttributeTypeAllAttributes,
                                         maximumResults: 0)
            return try query.resultsAllowingPartial(false) as! [ODRecord]
        } catch {

//            // // logger.openDirectory.error(message: "File: " + #file + ", Function: " + #function  + ":  ODError while finding all local users: \(error.localizedDescription).")
            throw error
        }
    }

    /// Returns all the non-system users on a system above UID 500.
    ///
    /// - Returns: A `Array` that contains the `ODRecord` of all the non-system user accounts in DSLocal.
    /// - Throws: An error from `ODFrameworkErrors` if something fails.
    func getAllNonSystemUsers() throws -> [ODRecord] {
//        // // logger.openDirectory.debug(message: "File: " + #file + "running, Function: " + #function)
        do {
            let allRecords = try getAllLocalUserRecords()
            let nonSystem = try allRecords.filter { (record) -> Bool in
                guard let uid = try record.values(forAttribute: kODAttributeTypeUniqueID) as? [String] else {
                    return false
                }
                return Int(uid.first ?? "") ?? 0 > 500 && record.recordName.first != "_"
            }
            return nonSystem
        } catch {
//            // // logger.openDirectory.error(message: "File: " + #file + ", Function: " + #function  + ":  ODError while finding non-system local users: \(error.localizedDescription).")
            throw error
        }
}
}

enum OktaQueryErrors: Error {
    case noMigrationCandidates
}

// MARK: - Okta extensions for the DSQueryable Protocol.
extension DSQueryable {
    /// Check to see if a given local user has the `kODAttributeOktaUser` set on their account.
    ///
    /// - Parameter shortName: The shortname of the user to check as a `String`.
    /// - Returns: `true` if the user has an Okta attribute. Otherwise `false`.
    /// - Throws: A `ODFrameworkErrors` or a `DSQueryableErrors` if there is an error.
    public func checkForOktaUser(_ shortName: String) throws -> Bool {
        // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  Checking for Okta username")
        do {
            let userRecord = try getLocalRecord(shortName)

            let names = try? userRecord.values(forAttribute: kODAttributeIdPUser)
            if names == nil {
                let names2 = try? userRecord.values(forAttribute: kODAttributeOktaUser)
                if names2 == nil {
                    return false
                }
            }
            return true
        } catch DSQueryableResults.notLocalUser {
            return false
        } catch {
            throw error
        }
    }

    /// Search in DSLocal and find any potential migration users.
    ///
    /// - Parameter excludeList: An optional `Array` of `String` values to exclude from the candidate list. These are typically set in the `.MigrateUsersHide` preference key.
    /// - Returns: The shortnames of the users to offer for Okta migration in an `Array` of `String` values.
    /// - Throws: A `ODFrameworkErrors` or a `DSQueryableErrors` if there is an error. Throws `OktaQueryErrors.noMigrationCandidates` if no results are found.
    public func findOktaMigrationCandidates(excludeList: [String] = [String]()) throws -> [String] {
        do {
            // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  Checking for Okta migration users.")
            var candidates = [String]()
            // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  Getting all user records.")
            let records = try getAllNonSystemUsers()
            // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  Filtering records")
            let filtered = try records.filter({ (record) -> Bool in
                if excludeList.contains(record.recordName) {
                    // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  User is exluded")
                    return false
                }
                if try checkForOktaUser(record.recordName) {
                    // logger.openDirectory.info(message: "File: " + #file + ", Function: " + #function  + ":  User has Okta Attribute")
                    return false
                }
                return true
            })
            for record in filtered {
                candidates.append(record.recordName)
            }
            if candidates.isEmpty {
                // logger.openDirectory.error(message: "File: " + #file + ", Function: " + #function  + ":  No Candidates")
                throw OktaQueryErrors.noMigrationCandidates
            }
            return candidates
        } catch {
            // logger.openDirectory.error(message: "File: " + #file + ", Function: " + #function  + ":  No Candidates")
            throw error
        }
    }
}


class Lookuper: DSQueryable {}

let sut = Lookuper()
let consoleRecord = try? sut.getLocalRecord("ED05F054-E81E-41A7-BCA8-A31118049EC6")
if let name = consoleRecord?.value(forKey: kODAttributeTypeUserShell) {
    name.self
}

let name2 = try? consoleRecord?.values(forAttribute: kODAttributeTypeRecordName).first
name2 as? String
