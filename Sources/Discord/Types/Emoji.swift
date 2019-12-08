public struct Emoji: Codable {
    public let id: Snowflake
    public let name: String
    public let user: User?
    public let roles: [GuildRole]?
    public let requiresColons: Bool
    public let isManaged: Bool
    public let isAnimated: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, user, roles
        case requiresColons = "require_colons", isManaged = "managed", isAnimated = "animated"
    }
}

public struct ActivityEmoji: Codable {
    public let name: String
    public let id: Snowflake?
    public let animated: Bool?
}

extension Emoji: CustomStringConvertible {
    public var description: String {
        return "<\(self.isAnimated ? "a" : ""):\(self.name):\(self.id)>"
    }
}

extension Emoji: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return self.id
    }
}

extension Emoji {
    public var url: String {
        return "https://discordapp.com/api/emojis/\(name).\(isAnimated ? "gif" : "png")"
    }
}

public struct PartialEmoji: Codable {
    public let id: Snowflake?
    public let name: String
}

public struct CreateEmojiPayload: Codable {
    public let name: String
    public let image: String
    public let roles: [Snowflake]
}

public struct ModifyEmojiPayload: Codable {
    public let name: String?
    public let roles: [Snowflake]?
}
