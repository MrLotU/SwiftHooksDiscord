import Foundation

// MARK: - Connection
public struct GatewayHello: DiscordGatewayType {
    public let heartbeatInterval: Int
    public let trace: [String]
    
    enum CodingKeys: String, CodingKey {
        case heartbeatInterval = "heartbeat_interval"
        case trace = "_trace"
    }
}

public struct GatewayReady: DiscordGatewayType {
    public let version: Int
    public let user: User
    public let privateChannels: [String]
    public let guilds: [UnavailableGuild]
    public let sessionId: String
    public let trace: [String]
    
    enum CodingKeys: String, CodingKey {
        case version = "v", user, guilds
        case privateChannels = "private_channels"
        case sessionId = "session_id"
        case trace = "_trace"
    }
}

public struct GatewayResumed: DiscordGatewayType {
    public let trace: [String]
    
    enum CodingKeys: String, CodingKey {
        case trace = "_trace"
    }
}

// MARK: - Channel
public struct GatewayChannelPinsUpdate: DiscordGatewayType {
    public let channelId: Snowflake
    public let lastPinTimestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case lastPinTimestamp = "last_pin_timestamp"
    }
}

// MARK: - Guild
public struct GatewayGuildBanEvent: DiscordGatewayType {
    public let guildId: Snowflake
    public let user: User
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case user
    }
}

public struct GatewayGuildEmojisUpdate: DiscordGatewayType {
    public let guildId: Snowflake
    public let emojis: [Emoji]
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case emojis
    }
}

public struct GatewayGuildIntegrationsUpdate: DiscordGatewayType {
    public let guildId: Snowflake
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
    }
}

public struct GatewayGuildMemberRemove: DiscordGatewayType {
    public let guildId: Snowflake
    public let user: User
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case user
    }
}

public struct GatewayGuildMemberUpdate: DiscordGatewayType {
    public let guildId: Snowflake
    public let roles: [Snowflake]
    public let user: User
    public let nick: String
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case roles, user, nick
    }
}

public struct GatewayGuildMembersChunk: DiscordGatewayType {
    public let guildId: Snowflake
    public let members: [GuildMember]
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case members
    }
}

public struct GatewayGuildRoleEvent: DiscordGatewayType {
    public let guildId: Snowflake
    public let role: GuildRole
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case role
    }
}

public struct GatewayGuildRoleDelete: DiscordGatewayType {
    public let guildId: Snowflake
    public let roleId: Snowflake
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id", roleId = "role_id"
    }
}

// MARK: - Message
public struct GatewayMessageDelete: DiscordGatewayType {
    public let id: Snowflake
    public let channelId: Snowflake
    public let guildId: Snowflake?
    
    enum CodingKeys: String, CodingKey {
        case id
        case channelId = "channel_id", guildId = "guild_id"
    }
}

public struct GatewayMessageDeleteBulk: DiscordGatewayType {
    public let ids: [Snowflake]
    public let channelId: Snowflake
    public let guildId: Snowflake?
    
    enum CodingKeys: String, CodingKey {
        case ids
        case channelId = "channel_id", guildId = "guild_id"
    }
}

public struct GatewayMessageReactionEvent: DiscordGatewayType {
    public let userId: Snowflake
    public let channelId: Snowflake
    public let messageId: Snowflake
    public let guildId: Snowflake
    public let emoji: PartialEmoji
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id", channelId = "channel_id"
        case messageId = "message_id", guildId = "guild_id"
        case emoji
    }
}

public struct GatewayMessageReactionRemoveAll: DiscordGatewayType {
    public let channelId: Snowflake
    public let messageId: Snowflake
    public let guildId: Snowflake
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id", messageId = "message_id", guildId = "guild_id"
    }
}

// MARK: - Status

public struct GatewayStatusUpdate: Codable {
    let since: Int?
    let game: Activity?
    let status: UserStatus
    let afk: Bool
}

// MARK: - Presence
public struct GatewayPresenceUpdate: DiscordGatewayType {
    public let user: PartialUser
    public let roles: [Snowflake]?
    public let game: Activity?
    public let guildId: Snowflake?
    public let status: UserStatus?
    public let activities: [Activity]
    public let clientStatus: ClientStatus
    public let premiumSince: String?
    public let nick: String?
    
    enum CodingKeys: String, CodingKey {
        case user, roles, game, status, activities, nick
        case guildId = "guild_id"
        case clientStatus = "client_status"
        case premiumSince = "premium_since"
    }
}

public struct ClientStatus: Codable {
    public let desktop: String?
    public let mobile: String?
    public let web: String?
}

public struct GatewayTypingStart: DiscordGatewayType {
    public let channelId: Snowflake
    public let guildId: Snowflake
    public let userId: Snowflake
    public let timestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id", guildId = "guild_id", userId = "user_id"
        case timestamp
    }
}

// MARK: - Voice
public struct GatewayVoiceServerUpdate: DiscordGatewayType {
    public let token: String
    public let guildId: Snowflake
    public let endpoint: String
    
    enum CodingKeys: String, CodingKey {
        case token, endpoint
        case guildId = "guild_id"
    }
}

// MARK: - Webhooks
public struct GatewayWebhooksUpdate: DiscordGatewayType {
    public let guildId: Snowflake
    public let channelId: Snowflake
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id", channelId = "channel_id"
    }
}
