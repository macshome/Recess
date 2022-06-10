enum AccountType: String {
    case Standard, Admin
}

struct UserInfo {
    var username: String
    var password: String
    var longName: String
    var accountType: AccountType
}

let standardTestUser = UserInfo(username: "administrator@admin.com",
                                password: "J@mf1234",
                                longName: "Administartor Okta",
                                accountType: .Standard)
