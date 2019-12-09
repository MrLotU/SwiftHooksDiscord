import Foundation
import NIO

public struct UnavailableGuild: DiscordGatewayType {
    public let id: Snowflake
    public let unavailable: Bool
}

public struct GuildBan: Codable {
    public let reason: String?
    public let user: User
}

public class Guild: DiscordGatewayType {
    public let id: Snowflake
    public let name: String
    public let icon: String?
    public let splash: String?
    public let isOwner: Bool?
    public let ownerId: Snowflake
    public let permissions: Permissions?
    public let region: String
    public let afkChannelId: Snowflake?
    public let afkTimeout: TimeInterval?
    public let embedEnabled: Bool?
    public let embedChannelId: Snowflake?
    public let verificationLevel: VerificationLevel
    public let defaultMessageNotifications: NotificationLevel
    public let explicitContentFilter: ExplicitContentFilterLevel
    public internal(set) var roles: [GuildRole]
    public internal(set) var emojis: [Emoji]
    public let features: [Feature]
    public let mfaLevel: MFALevel
    public let applicationId: Snowflake?
    public let widgetEnabled: Bool?
    public let widgetChannelId: Snowflake?
    public let systemChannelId: Snowflake?
    public let joinedAt: String?
    public let isLarge: Bool?
    public let isUnavailable: Bool?
    public let memberCount: Int?
//    public let voiceStates: [VoiceState]
    public internal(set) var members: [GuildMember]
    public internal(set) var channels: [Channel]
    public let presences: [GatewayPresenceUpdate]
    public let maxPresences: Int?
    public let maxMembers: Int?
    public let vanityUrlCode: String?
    public let description: String?
    public let banner: String?
    public let premiumTier: PremiumTier
    public let premiumSubscriptionCount: Int?
    public let preferredLocale: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, icon, splash, permissions, region, roles, emojis, features, members, channels, presences
        case isOwner = "is_owner", ownerId = "owner_id", afkChannelId = "afk_channel_id", afkTimeout = "afk_timeout"
        case embedEnabled = "embed_enabled", embedChannelId = "embed_channel_id", verificationLevel = "verification_level"
        case defaultMessageNotifications = "default_message_notifications", explicitContentFilter = "explicit_content_filter"
        case mfaLevel = "mfa_level", applicationId = "application_id", widgetEnabled = "widget_enabled", widgetChannelId = "widget_channel_id"
        case systemChannelId = "system_channel_id", joinedAt = "joined_at", isLarge = "large", isUnavailable = "unavailable", memberCount = "member_count"
        case maxPresences = "max_presences", vanityUrlCode = "vanity_url_code", maxMembers = "max_members", description, banner
        case premiumTier = "premium_tier", premiumSubscriptionCount = "premium_subscription_count", preferredLocale = "preferred_locale"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Snowflake.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
        self.splash = try container.decodeIfPresent(String.self, forKey: .splash)
        self.isOwner = try container.decodeIfPresent(Bool.self, forKey: .isOwner)
        self.ownerId = try container.decode(Snowflake.self, forKey: .ownerId)
        self.permissions = try container.decodeIfPresent(Permissions.self, forKey: .permissions)
        self.region = try container.decode(String.self, forKey: .region)
        self.afkChannelId = try container.decodeIfPresent(Snowflake.self, forKey: .afkChannelId)
        let timeout = try container.decodeIfPresent(Int.self, forKey: .afkTimeout)
        self.afkTimeout = timeout != nil ? Double(exactly: timeout!) : nil
        self.embedEnabled = try container.decodeIfPresent(Bool.self, forKey: .embedEnabled)
        self.embedChannelId = try container.decodeIfPresent(Snowflake.self, forKey: .embedChannelId)
        self.verificationLevel = try container.decode(VerificationLevel.self, forKey: .verificationLevel)
        self.defaultMessageNotifications = try container.decode(NotificationLevel.self, forKey: .defaultMessageNotifications)
        self.explicitContentFilter = try container.decode(ExplicitContentFilterLevel.self, forKey: .explicitContentFilter)
        self.roles = try container.decodeIfPresent([GuildRole].self, forKey: .roles) ?? []
        self.emojis = try container.decodeIfPresent([Emoji].self, forKey: .emojis) ?? []
        self.features = try container.decodeIfPresent([Feature].self, forKey: .features) ?? []
        self.mfaLevel = try container.decode(MFALevel.self, forKey: .mfaLevel)
        self.applicationId = try container.decodeIfPresent(Snowflake.self, forKey: .applicationId)
        self.widgetEnabled = try container.decodeIfPresent(Bool.self, forKey: .widgetEnabled)
        self.widgetChannelId = try container.decodeIfPresent(Snowflake.self, forKey: .widgetChannelId)
        self.systemChannelId = try container.decodeIfPresent(Snowflake.self, forKey: .systemChannelId)
        self.joinedAt = try container.decodeIfPresent(String.self, forKey: .joinedAt)
        self.isLarge = try container.decodeIfPresent(Bool.self, forKey: .isLarge)
        self.isUnavailable = try container.decodeIfPresent(Bool.self, forKey: .isUnavailable)
        self.memberCount = try container.decodeIfPresent(Int.self, forKey: .memberCount)
        self.members = try container.decodeIfPresent([GuildMember].self, forKey: .members) ?? []
        self.channels = try container.decodeIfPresent([Channel].self, forKey: .channels) ?? []
        self.presences = try container.decodeIfPresent([GatewayPresenceUpdate].self, forKey: .presences) ?? []
        self.maxPresences = try container.decodeIfPresent(Int.self, forKey: .maxPresences)
        self.maxMembers = try container.decodeIfPresent(Int.self, forKey: .maxMembers)
        self.vanityUrlCode = try container.decodeIfPresent(String.self, forKey: .vanityUrlCode)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.banner = try container.decodeIfPresent(String.self, forKey: .banner)
        self.premiumTier = try container.decodeIfPresent(PremiumTier.self, forKey: .premiumTier)
        self.premiumSubscriptionCount = try container.decodeIfPresent(Int.self, forKey: .premiumSubscriptionCount)
        self.preferredLocale = try container.decode(String.self, forKey: .preferredLocale)
    }
}

extension Guild {
    public var owner: GuildMember {
        return members[ownerId]! // If this is nil, the universe is broken
    }
    
//    public func get_permissions(for member: GuildMember) -> Permission {
//        if member.id == ownerId {
//            return .administrator
//        }
//        // TODO: Imp
//        fatalError()
//    }
//
//    public func createRole(named name: String, permissions: Permission? = nil, color: Int = 1, isHoisted: Bool = false, isMentionable: Bool = false) -> EventLoopFuture<GuildRole> {
//        let p = GuildRoleCreatePayload.init(name: name, permissions: permissions, color: color, hoist: isHoisted, mentionable: isMentionable)
//        return handler.client.execute(.GuildRolesCreate(id), p)
//    }
//
//    public func deleteRole(_ role: GuildRole) {
//        handler.client.execute(.GuildRolesDelete(id, role.id))
//    }
//
//    public func requestGuildMembers() {
//        // TODO: Imp
//    }
//
//    public func getBans() -> EventLoopFuture<[GuildBan]> {
//        return handler.client.execute(.GuildBansList(id))
//    }
//
//    public func ban(_ member: Snowflakable) throws {
//        guard member is GuildMember || member is User else {
//            throw DiscordRestError.UnbannableInstance
//        }
//
//        handler.client.execute(.GuildBansCreate(id, member.snowflakeDescription))
//    }
//
//    public func unban(_ member: Snowflakable) throws {
//        guard member is GuildMember || member is User else {
//            throw DiscordRestError.UnbannableInstance
//        }
//
//        handler.client.execute(.GuildBansRemove(id, member.snowflakeDescription))
//    }
//
//    public func createCategory(named name: String, at pos: Int? = nil) -> EventLoopFuture<Channel> {
//        let p = CreatChannelPayload.init(name: name, type: .category, topic: nil, bitrate: nil, userLimit: nil, rateLimitPerUser: nil, position: pos, permissionOverwrites: nil, parentId: nil, nsfw: nil)
//        return handler.client.execute(.GuildChannelsCreate(id), p)
//    }
//
//    public func createTextChannel(named name: String, at pos: Int? = nil, parent: Channel? = nil, topic: String? = nil, isNsfw: Bool? = nil) throws -> EventLoopFuture<Channel> {
//        guard parent == nil || parent?.type == .category else {
//            throw DiscordRestError.UnusableParent
//        }
//        let p = CreatChannelPayload.init(name: name, type: .text, topic: topic, bitrate: nil, userLimit: nil, rateLimitPerUser: nil, position: pos, permissionOverwrites: nil, parentId: parent?.id, nsfw: isNsfw)
//        return handler.client.execute(.GuildChannelsCreate(id), p)
//    }
//
//    public func createVoiceChannel(named name: String, at pos: Int? = nil, parent: Channel? = nil, bitrate: Int? = nil, userLimit: Int? = nil, rateLimitPerUser: Int? = nil) throws -> EventLoopFuture<Channel> {
//        guard parent == nil || parent?.type == .category else {
//            throw DiscordRestError.UnusableParent
//        }
//        let p = CreatChannelPayload.init(name: name, type: .voice, topic: nil, bitrate: bitrate, userLimit: userLimit, rateLimitPerUser: rateLimitPerUser, position: pos, permissionOverwrites: nil, parentId: parent?.id, nsfw: nil)
//        return handler.client.execute(.GuildChannelsCreate(id), p)
//    }
//
//    public func leave() {
//        handler.client.execute(.UserGuildLeave(id))
//    }
//
//    public func getEmojis() -> EventLoopFuture<Emoji> {
//        return handler.client.execute(.GuildEmojisGet(id))
//    }
    
    public func getIconUrl(_ format: String = "png", _ size: Int = 1024) -> String? {
        guard let icon = self.icon else { return nil }
        return "https://cdn.discordapp.com/icons/\(id)/\(icon).\(format)?size=\(size)"
    }
    
    public func getSplashUrl(_ format: String = "png", _ size: Int = 1024) -> String? {
        guard let splash = self.splash else { return nil }
        return "https://cdn.discordapp.com/splashes/\(id)/\(splash).\(format)?size=\(size)"
    }
}

extension Guild: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return self.id
    }
}

extension Guild {
    public enum NotificationLevel: Int, Codable {
        case allMessages, onlyMentions
    }

    public enum ExplicitContentFilterLevel: Int, Codable {
        case disabled, membersWithoutRoles, allMembers
    }

    public enum MFALevel: Int, Codable {
        case none, elevated
    }

    public enum VerificationLevel: Int, Codable {
        case none, low, medium, high, veryHigh
    }
    
    public enum Feature: String, Codable {
        case vipVoice = "VIP_REGIONS"
        case vanityUrl = "VANITY_URL"
        case inviteSplash = "INVITE_SPLASH"
        case verified = "VERIFIED"
        case moreEmojis = "MORE_EMOJI"
        case partnered = "PARTNERED"
        case `public` = "PUBLIC"
        case commerce = "COMMERCE"
        case news = "NEWS"
        case discoverable = "DISCOVERABLE"
        case featureable = "FEATURABLE"
        case animatedIcon = "ANIMATED_ICON"
        case banner = "BANNER"
    }
    
    public enum PremiumTier: Int, Codable {
        case none, tierOne, tierTwo, tierThree
    }
}
