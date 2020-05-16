public struct ModifyGuildPayload: Codable {
    public let name: String?
    public let region: String?
    public let verificationLevel: Guild.VerificationLevel?
    public let defaultNotifications: Guild.NotificationLevel?
    public let contentFilterLevel: Guild.ExplicitContentFilterLevel?
    public let afkChannelId: Snowflake?
    public let afkTimeout: Int?
    public let icon: String?
    public let ownerId: Snowflake?
    public let splash: String?
    public let banner: String?
    public let systemChannelId: Snowflake?
    public let rulesChannelId: Snowflake?
    public let publicUpdatesChannelId: Snowflake?
    public let preferredLocale: String?
    
    enum CodingKeys: String, CodingKey {
        case name, region, icon, splash, banner
        case verificationLevel = "verification_level"
        case defaultNotifications = "default_message_notifications"
        case contentFilterLevel = "explicit_content_filter"
        case afkChannelId = "afk_channel_id"
        case afkTimeout = "afk_timeout"
        case ownerId = "owner_id"
        case systemChannelId = "system_channel_id"
        case rulesChannelId = "rules_channel_id"
        case publicUpdatesChannelId = "public_updates_channel_id"
        case preferredLocale = "preferred_locale"
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
    public let roles: [Snowflake]?
    public let mute: Bool?
    public let deaf: Bool?
}

public struct ModifyGuildMemberPayload: Codable {
    public let nick: String?
    public let roles: [Snowflake]?
    public let mute: Bool?
    public let deaf: Bool?
    public let channel_id: Snowflake?
}

public struct ModifyNickMePayload: Codable {
    public let nick: String?
}

public struct GuildRoleCreatePayload: Codable {
    public let name: String?
    public let permissions: Permissions?
    public let color: Int?
    public let hoist: Bool?
    public let mentionable: Bool?
}


public typealias ModifyRolePositionPayload = [_ModifyRolePositionPayload]
public struct _ModifyRolePositionPayload: Codable {
    public let id: Snowflake
    public let position: Int?
}

public struct ModifyRolePayload: Codable {
    public let name: String?
    public let permissions: Permissions?
    public let color: Int?
    public let hoist: Bool?
    public let mentionable: Bool?
}

public struct GuildPruneResult: Codable {
    public let pruned: Int?
}

public struct GuildIntegrationCreatePayload: Codable {
    public let type: String
    public let id: Snowflake
}

public struct ModifyGuildIntegrationPayload: Codable {
    public let expire_behaviour: IntegrationExpireBehavior?
    public let expire_grace_period: Int?
    public let enable_emoticons: Bool?
}

public struct UnavailableGuild: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient!
    public let id: Snowflake
    public let unavailable: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, unavailable
    }
    
    func copyWith(_ client: DiscordClient) -> UnavailableGuild {
        var x = self
        x.client = client
        return x
    }
}

public struct GuildBan: Codable {
    public let reason: String?
    public let user: User
}

public struct GuildPreview: Codable {
    let id: Snowflake
    let name: String
    let icon: String?
    let splash: String?
    let discoverySplash: String?
    let emojis: [Emoji]
    let features: [Guild.Feature]
    let approximateMemberCount: Int
    let approximatePresenceCount: Int
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, icon, splash, discoverySplash = "discovery_splash"
        case emojis, features, approximateMemberCount = "approximate_member_count"
        case approximatePresenceCount = "approximate_presence_count", description
    }
}

public struct GuildWidget: Codable {
    let enabled: Bool
    let channelId: Snowflake?
    
    enum CodingKeys: String, CodingKey {
        case enabled, channelId = "channel_id"
    }
}

public struct GuildIntegration: Codable {
    public let id: Snowflake
    public let name: String
    public let type: String
    public let enabled: Bool
    public let syncing: Bool
    public let roleId: Snowflake
    public let enableEmoticons: Bool?
    public let expireBehavior: IntegrationExpireBehavior
    public let expireGracePeriod: Int
    public let user: User
    public let account: IntegrationAccount
    public let syncedAt: String
}

public enum IntegrationExpireBehavior: Int, Codable {
    case removeRole, kick
}

public struct IntegrationAccount: Codable {
    let id: String
    let name: String
}
