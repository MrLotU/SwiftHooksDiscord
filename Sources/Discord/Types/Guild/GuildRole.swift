public struct GuildRole: Codable {
    public let id: Snowflake
    public let name: String
    public let color: Int
    public let isHoisted: Bool
    public let position: Int
    public let permissions: Permissions
    public let isManaged: Bool
    public let isMentionable: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, color, position, permissions
        case isHoisted = "hoist", isManaged = "managed", isMentionable = "mentionable"
    }
}

extension GuildRole: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return self.id
    }
}

extension GuildRole {
    public var mention: String {
        return "<@&\(id)>"
    }
}
