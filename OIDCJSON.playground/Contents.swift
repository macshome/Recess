import Foundation

struct OIDCUser: Codable {
    var name: String
    var aud: String
    var iss: String
    var iat: Date?
    var nbf: Date?
    var family_name: String
    var given_name: String

    enum CodingKeys: CodingKey {
        case name, aud, iss, iat, nbf, family_name, given_name
    }

    init(name: String, aud: String, iss: String, iat: Date, nbf: Date, family_name: String, given_name: String) {
        self.name = name
        self.aud = aud
        self.iss = iss
        self.iat = iat
        self.nbf = nbf
        self.family_name = family_name
        self.given_name = given_name
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        aud = (try? values.decode(String.self, forKey: .aud)) ?? ""
        iss = (try? values.decode(String.self, forKey: .iss)) ?? ""
        iat = (try? values.decode(Date.self, forKey: .iat)) ?? nil
        nbf = (try? values.decode(Date.self, forKey: .nbf)) ?? nil
        family_name = (try? values.decode(String.self, forKey: .family_name)) ?? ""
        given_name = (try? values.decode(String.self, forKey: .given_name)) ?? ""
    }
}

struct TopLevel: Codable {
    let aud, iss: String
    let iat, nbf, exp: Int
    let aio: String
    let amr: [String]
    let familyName, givenName: String
    let groups: [String]
    let ipaddr, name, nonce, oid: String
    let roles: [String]
    let sub, tid, uniqueName, upn: String
    let uti, ver: String

    enum CodingKeys: String, CodingKey {
        case aud, iss, iat, nbf, exp, aio, amr
        case familyName = "family_name"
        case givenName = "given_name"
        case groups, ipaddr, name, nonce, oid, roles, sub, tid
        case uniqueName = "unique_name"
        case upn, uti, ver
    }
}

// MARK: Convenience initializers

extension TopLevel {
    
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(TopLevel.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
