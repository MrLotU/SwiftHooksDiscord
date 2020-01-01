import Foundation

// MARK: - Connection
public struct GatewayHello: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient!
    public let heartbeatInterval: Int
    public let trace: [String]
    
    enum CodingKeys: String, CodingKey {
        case heartbeatInterval = "heartbeat_interval"
        case trace = "_trace"
    }
}

public struct GatewayReady: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient!
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

public struct GatewayResumed: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient!
    public let trace: [String]
    
    enum CodingKeys: String, CodingKey {
        case trace = "_trace"
    }
}

// MARK: - Channel
public struct GatewayChannelPinsUpdate: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient!
    public let channelId: Snowflake
    public let lastPinTimestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case lastPinTimestamp = "last_pin_timestamp"
    }
}

// MARK: - Guild
public struct GatewayGuildBanEvent: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient!
    public let guildId: Snowflake
    public let user: User
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case user
    }
}

public struct GatewayGuildEmojisUpdate: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient!
    public let guildId: Snowflake
    public let emojis: [Emoji]
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case emojis
    }
}

public struct GatewayGuildIntegrationsUpdate: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient!
    public let guildId: Snowflake
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
    }
}

public struct GatewayGuildMemberRemove: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
    public let guildId: Snowflake
    public let user: User
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case user
    }
}

public struct GatewayGuildMemberUpdate: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
    public let guildId: Snowflake
    public let roles: [Snowflake]
    public let user: User
    public let nick: String
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case roles, user, nick
    }
}

public struct GatewayGuildMembersChunk: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
    public let guildId: Snowflake
    public let members: [GuildMember]
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case members
    }
}

public struct GatewayGuildRoleEvent: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
    public let guildId: Snowflake
    public let role: GuildRole
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id"
        case role
    }
}

public struct GatewayGuildRoleDelete: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
    public let guildId: Snowflake
    public let roleId: Snowflake
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id", roleId = "role_id"
    }
}

// MARK: - Message
public struct GatewayMessageDelete: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
    public let id: Snowflake
    public let channelId: Snowflake
    public let guildId: Snowflake?
    
    enum CodingKeys: String, CodingKey {
        case id
        case channelId = "channel_id", guildId = "guild_id"
    }
}

public struct GatewayMessageDeleteBulk: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
    public let ids: [Snowflake]
    public let channelId: Snowflake
    public let guildId: Snowflake?
    
    enum CodingKeys: String, CodingKey {
        case ids
        case channelId = "channel_id", guildId = "guild_id"
    }
}

public struct GatewayMessageReactionEvent: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
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

public struct GatewayMessageReactionRemoveAll: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
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
public struct GatewayPresenceUpdate: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
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

public struct GatewayTypingStart: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
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
public struct GatewayVoiceServerUpdate: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
    public let token: String
    public let guildId: Snowflake
    public let endpoint: String
    
    enum CodingKeys: String, CodingKey {
        case token, endpoint
        case guildId = "guild_id"
    }
}

// MARK: - Webhooks
public struct GatewayWebhooksUpdate: DiscordGatewayType, DiscordHandled {
public internal(set) var client: DiscordClient!
    public let guildId: Snowflake
    public let channelId: Snowflake
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id", channelId = "channel_id"
    }
}
