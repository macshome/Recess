
let migrate = true
let localLoginAllowed = true
let isUserLocal = true
let isOktaUser = true

isUserLocal && migrate && isOktaUser

false && true
false && false
true && true
true && false 

false || true
false || false
true || true
true || false

class UserModel {
var adminOverride: Bool?
}

let userData = UserModel()
let adminOverride = userData.adminOverride ?? false
adminOverride.description
