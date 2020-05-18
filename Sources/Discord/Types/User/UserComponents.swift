import Foundation

public struct ModifyUserPayload: Codable {
    public let username: String
    public let avatar: String?
}

public struct UserGuildsMeQuery: QueryItemConvertible {
    public let before: Snowflake?
    public let after: Snowflake?
    public let limit: Int?
    
    public func toQueryItems() -> [URLQueryItem] {
        var arr = [
            URLQueryItem(name: "before", value: before?.asString),
            URLQueryItem(name: "after", value: after?.asString)
        ]
        if let l = limit {
            arr.append(URLQueryItem(name: "limit", value: "\(l)"))
        }
        return arr
    }
}

public struct CreateDMPayload: Codable {
    public let recipient_id: Snowflake
}

public struct CreateGroupDMPayload: Codable {
    public let access_tokens: [String]
    public let nicks: [Snowflake: String]
}

public struct UserConnection: Codable {
    public let id: String
    public let name: String
    public let type: String
    public let isRevoked: Bool
    public var integrations: [GuildIntegration]
    public let isVerified: Bool
    public let friendSync: Bool
    public let showActivity: Bool
    public let visibility: Visibility
    
    public enum Visibility: Int, Codable {
        case none, everyone
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, visibility, integrations
        case isRevoked = "revoked", isVerified = "is_verified"
        case friendSync = "friend_sync", showActivity = "show_activity"
    }
}

public struct Activity: Codable {
    public let name: String
    public let type: ActivityType
    public let url: String?
    public let created_at: Int?
    public let timestamps: ActivityTimestamps?
    public let applicationId: Snowflake?
    public let details: String?
    public let state: String?
    public let emoji: ActivityEmoji?
    public let party: Party?
    public let assets: Assets?
    public let secrets: Secrets?
    public let instance: Bool?
    public let flags: Int?
    
    public struct Secrets: Codable {
        public let join: String?
        public let spectate: String?
        public let match: String?
    }
    
    public struct Assets: Codable {
        public let largeImage: String?
        public let largeText: String?
        public let smallImage: String?
        public let smallText: String?
        
        enum CodingKeys: String, CodingKey {
            case largeImage = "large_image", largeText = "large_text"
            case smallImage = "small_image", smallText = "small_text"
        }
    }
    
    public struct Party: Codable {
        public let id: String?
        public let size: [Int]?
    }
    
    public struct ActivityTimestamps: Codable {
        public let start: Int?
        public let end: Int?
    }
    
    public enum ActivityType: Int, Codable {
        case game, streaming, listening, custom = 4
    }
}

public enum PremiumType: Int, Codable {
    case none, nitroClassic, nitro
}

public enum Flags: Int, Codable {
    case none
    case employee
    case partner
    case events
    case bugHunter
    case houseBravery
    case houseBrilliance
    case earlySupporter
    case teamUser
    case system
}
