import Cocoa
import OpenDirectory


// You can click on each try line to see each operation.

// Get the local node
let localNode = try! ODNode(session: .default(), type: ODNodeType(kODNodeTypeLocalNodes))

// A query to get the admin group
var query = try! ODQuery(node: localNode,
                         forRecordTypes: kODRecordTypeGroups,
                         attribute: kODAttributeTypeRecordName,
                         matchType: ODMatchType(kODMatchEqualTo),
                         queryValues: "Admin",
                         returnAttributes: kODAttributeTypeNativeOnly,
                         maximumResults: 1)

// Run the query
let adminGroup = try! query.resultsAllowingPartial(false).first as! ODRecord

// We need to authenciate or be running as root to edit the database.
try! localNode.setCredentialsWithRecordType(nil, recordName: "josh.wisenbaker", password: "")

// Create a new group with one member and a known GUID
let newGroup = try! localNode.createRecord(withRecordType: kODRecordTypeGroups,
                       name: "ElevatorOperators",
                            attributes: [kODAttributeTypeGroupMembership: ["josh.wisenbaker"]])

// Add our new group to the nested groups attribute of the Admin group
try! adminGroup.addMemberRecord(newGroup)

// Go take a look and see what was created in Direcory Utility
// When you are done you can come back here and run the rest of the playground to remove what we made

// Remove the nested groups from admin
try! adminGroup.removeMemberRecord(newGroup)

// Remove the group we made
try! newGroup.delete()
