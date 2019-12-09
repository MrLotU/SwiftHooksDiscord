public struct MessageActivity: Codable {
    public let type: MessageActivityType
    public let party_id: String?
}

public enum MessageActivityType: Int, Codable {
    case join = 1, spectate = 2, listen = 3, joinRequest = 5
}

public struct Reaction: Codable {
    public let count: Int
    public let me: Bool
    public let emoji: PartialEmoji?
}

public struct MessageApplication: Codable {
    public let id: Snowflake
    public let cover_image: String?
    public let description: String
    public let icon: String?
    public let name: String
}

public struct MessageFlags: OptionSet, Codable {
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public let rawValue: Int
    public typealias RawValue = Int
    
    public static let crossposted = MessageFlags(rawValue: 1 << 0)
    public static let isCrossposted = MessageFlags(rawValue: 1 << 1)
    public static let suppressEmbed = MessageFlags(rawValue: 1 << 2)
    public static let sourceMessageDeleted = MessageFlags(rawValue: 1 << 3)
    public static let urgent = MessageFlags(rawValue: 1 << 4)
}

public struct MessageReference: Codable {
    public let message_id: Snowflake?
    public let channel_id: Snowflake
    public let guild_id: Snowflake?
}

public struct Attachment: Codable {
    public let id: Snowflake
    public let filename: String
    public let size: Int
    public let url: String
    public let proxy_url: String
    public let height: Int?
    public let width: Int?
}

public struct ChannelMention: Codable {
    public let id: Snowflake
    public let guildId: Snowflake
    public let type: ChannelType
    public let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, type, name
        case guildId = "guild_id"
    }
}
