public struct MessageActivity: Codable {
    public let type: MessageActivityType
    public let party_id: String?
}

public enum MessageActivityType: Int, Codable {
    case join, spectate, listen, joinRequest
}

public struct Reaction: Codable {
    public let count: Int
    public let me: Bool
    public let emoji: PartialEmoji?
}

public struct MessageApplication: Codable {
    public let id: Snowflake
    public let cover_image: String
    public let description: String
    public let icon: String
    public let name: String
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
