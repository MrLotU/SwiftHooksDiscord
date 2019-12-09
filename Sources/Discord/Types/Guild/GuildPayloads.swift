public struct ModifyGuildPayload: Codable {
    public let name: String
    public let region: String
    public let verificationLevel: Guild.VerificationLevel
    public let defaultNotifications: Guild.NotificationLevel
    public let contentFilterLevel: Guild.ExplicitContentFilterLevel
    public let afkChannelId: Snowflake
    public let afkTimeout: Int
    public let icon: String
    public let ownerId: Snowflake
    public let splash: String
    public let systemChannelId: Snowflake
    
    enum CodingKeys: String, CodingKey {
        case name, region, icon, splash
        case verificationLevel = "verification_level"
        case defaultNotifications = "default_message_notifications"
        case contentFilterLevel = "explicit_content_filter"
        case afkChannelId = "afk_channel_id"
        case afkTimeout = "afk_timeout"
        case ownerId = "owner_id"
        case systemChannelId = "system_channel_id"
    }
}

public struct CreatChannelPayload: Codable {
    public let name: String
    public let type: ChannelType
    public let topic: String?
    public let bitrate: Int?
    public let userLimit: Int?
    public let rateLimitPerUser: Int?
    public let position: Int?
    public let permissionOverwrites: [PermissionOverwrite]?
    public let parentId: Snowflake?
    public let nsfw: Bool?
    
    enum CodingKeys: String, CodingKey {
        case name, type, topic, bitrate, position, nsfw
        case userLimit = "user_limit"
        case rateLimitPerUser = "rate_limit_per_user"
        case permissionOverwrites = "permission_overwrites"
        case parentId = "parent_id"
    }
}

public struct ModifyChannelPositionPayload: Codable {
    public let id: Snowflake
    public let position: Int
}

public struct AddGuildMemberPayload: Codable {
    public let access_token: String
    public let nick: String?
    public let roles: [GuildRole]?
    public let mute: Bool?
    public let deaf: Bool?
}

public struct ModifyGuildMemberPayload: Codable {
    public let nick: String?
    public let roles: [GuildRole]?
    public let mute: Bool?
    public let deaf: Bool?
    public let channel_id: Snowflake?
}

public struct ModifyNickMePayload: Codable {
    public let nick: String?
}

public struct GuildRoleCreatePayload: Codable {
    public let name: String
    public let permissions: Permissions?
    public let color: Int?
    public let hoist: Bool?
    public let mentionable: Bool?
}

public struct ModifyRolePositionPayload: Codable {
    public let id: Snowflake
    public let position: Int
}

public struct ModifyRolePayload: Codable {
    public let name: String?
    public let permissions: Permissions?
    public let color: Int?
    public let hoist: Bool?
    public let mentionable: Bool?
}
