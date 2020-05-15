public struct Emoji: Codable {
    public let id: Snowflake
    public let name: String
    public let roles: [GuildRole]?
    public let user: User?
    public let requiresColons: Bool?
    public let isManaged: Bool?
    public let isAnimated: Bool?
    public let isAvailable: Bool?
    
    public init(id: Snowflake, name: String) {
        self.id = id
        self.name = name
        self.roles = nil
        self.user = nil
        self.requiresColons = nil
        self.isManaged = nil
        self.isAnimated = nil
        self.isAvailable = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, roles, user
        case requiresColons = "require_colons", isManaged = "managed", isAnimated = "animated"
        case isAvailable = "available"
    }
}

public struct ActivityEmoji: Codable {
    public let name: String
    public let id: Snowflake?
    public let animated: Bool?
}

extension Emoji: CustomStringConvertible {
    public var description: String {
        return "<\(self.urlValue)>"
    }
    
    public var urlValue: String {
        return "\(self.isAnimated ?? false ? "a" : ""):\(self.name):\(self.id)"
    }
}

extension Emoji: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return self.id
    }
}

extension Emoji {
    public var url: String {
        return "https://discordapp.com/api/emojis/\(name).\(isAnimated ?? false ? "gif" : "png")"
    }
}

public struct PartialEmoji: Codable {
    public let id: Snowflake?
    public let name: String?
    public let animated: Bool?
}

public struct CreateEmojiPayload: Codable {
    public let name: String
    public let image: String
    public let roles: [Snowflake]?
}

public struct ModifyEmojiPayload: Codable {
    public let name: String?
    public let roles: [Snowflake]?
}
