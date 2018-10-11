import Foundation

public struct Response {
    public let createdAt: Date
    public let users: [User]
}

extension Response: Codable {
    enum CodingKeys : String, CodingKey {
        case response
        case createdAt = "created_at"
        case users
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.createdAt = try response.decode(Date.self, forKey: .createdAt)
        self.users = try response.decode([User].self, forKey: .users)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        try response.encode(createdAt, forKey: .createdAt)
        var users = response.nestedContainer(keyedBy: CodingKeys.self, forKey: .users)
        try users.encode(self.users, forKey: .users)
    }
}
