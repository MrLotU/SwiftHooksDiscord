import Foundation
import NIO

public class Guild: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient! {
        didSet {
            for member in self.members {
                member.client = client
                member.guildId = self.id
            }
            for channel in self.channels {
                channel.client = client
            }
        }
    }
    
    public let id: Snowflake
    public let name: String
    public let icon: String?
    public let splash: String?
    public let discoverySplash: String?
    public let isOwner: Bool?
    public let ownerId: Snowflake
    public let permissions: Permissions?
    public let region: String
    public let afkChannelId: Snowflake?
    public let afkTimeout: TimeInterval?
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
    public let systemChannelFlags: SystemChannelFlags
    public let rulesChannelId: Snowflake?
    public let joinedAt: String?
    public let isLarge: Bool?
    public let isUnavailable: Bool?
    public let memberCount: Int?
    public let voiceStates: [VoiceState]
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
    public let publicUpdatesChannelId: Snowflake?
    public let maxVideoChannelUsers: Int?
    public let approximateMemberCount: Int?
    public let approximatePresenceCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, icon, splash, discoverySplash = "discover_splash", permissions, region, roles, emojis, features, members, channels, presences
        case isOwner = "is_owner", ownerId = "owner_id", afkChannelId = "afk_channel_id", afkTimeout = "afk_timeout"
        case verificationLevel = "verification_level"
        case defaultMessageNotifications = "default_message_notifications", explicitContentFilter = "explicit_content_filter"
        case mfaLevel = "mfa_level", applicationId = "application_id", widgetEnabled = "widget_enabled", widgetChannelId = "widget_channel_id"
        case systemChannelId = "system_channel_id", systemChannelFlags = "system_channel_flags", rulesChannelId = "rules_channel_id", joinedAt = "joined_at", isLarge = "large", isUnavailable = "unavailable", memberCount = "member_count"
        case voiceStates = "voice_states", maxPresences = "max_presences", vanityUrlCode = "vanity_url_code", maxMembers = "max_members", description, banner
        case premiumTier = "premium_tier", premiumSubscriptionCount = "premium_subscription_count", preferredLocale = "preferred_locale"
        case publicUpdatesChannelId = "public_updates_channel_id", maxVideoChannelUsers = "max_video_channel_users", approximateMemberCount = "approximate_member_count"
        case approximatePresenceCount = "approximate_presence_count"
    }
}

extension Guild {
    public var owner: GuildMember {
        return members[ownerId]! // If this is nil, the universe is broken
    }
    
    public func getPermissions(for member: GuildMember) -> Permissions {
        if member.id == ownerId {
            return .administrator
        }
        let roles = self.roles.filter { member.roles.contains($0.id) }
        return roles.reduce(into: self.roles[self.id]?.permissions ?? []) { $0.formUnion($1.permissions) }
    }
    
    public func createRole(named name: String, permissions: Permissions? = nil, color: Int = 1, isHoisted: Bool = false, isMentionable: Bool = false) -> EventLoopFuture<GuildRole> {
        let p = GuildRoleCreatePayload.init(name: name, permissions: permissions, color: color, hoist: isHoisted, mentionable: isMentionable)
        return client.rest.execute(.GuildRolesCreate(id), p)
    }
    
    public func deleteRole(_ role: GuildRole) {
        client.rest.execute(.GuildRolesDelete(id, role.id))
    }
    
    public func requestGuildMembers() {
//        self.client.
        // TODO: Imp
    }
    
    public func getBans() -> EventLoopFuture<[GuildBan]> {
        return client.rest.execute(.GuildBansList(id))
    }
    
    public func ban(_ member: Snowflakable) throws {
        guard member is GuildMember || member is User else {
            throw DiscordRestError.UnbannableInstance
        }
        
        client.rest.execute(.GuildBansCreate(id, member.snowflakeDescription))
    }
    
    public func unban(_ member: Snowflakable) throws {
        guard member is GuildMember || member is User else {
            throw DiscordRestError.UnbannableInstance
        }
        
        client.rest.execute(.GuildBansRemove(id, member.snowflakeDescription))
    }
    
    public func createCategory(named name: String, at pos: Int? = nil) -> EventLoopFuture<Channel> {
        let p = CreatChannelPayload.init(name: name, type: .category, topic: nil, bitrate: nil, userLimit: nil, rateLimitPerUser: nil, position: pos, permissionOverwrites: nil, parentId: nil, nsfw: nil)
        return client.rest.execute(.GuildChannelsCreate(id), p)
    }
    
    public func createTextChannel(named name: String, at pos: Int? = nil, parent: Channel? = nil, topic: String? = nil, isNsfw: Bool? = nil, rateLimitPerUser: Int? = nil, permissionOverwrites: [PermissionOverwrite]? = nil) throws -> EventLoopFuture<Channel> {
        guard parent == nil || parent?.type == .category else {
            throw DiscordRestError.UnusableParent
        }
        let p = CreatChannelPayload.init(name: name, type: .text, topic: topic, bitrate: nil, userLimit: nil, rateLimitPerUser: rateLimitPerUser, position: pos, permissionOverwrites: permissionOverwrites, parentId: parent?.id, nsfw: isNsfw)
        return client.rest.execute(.GuildChannelsCreate(id), p)
    }
    
    public func createVoiceChannel(named name: String, at pos: Int? = nil, parent: Channel? = nil, bitrate: Int? = nil, userLimit: Int? = nil, overwrites: [PermissionOverwrite]? = nil) throws -> EventLoopFuture<Channel> {
        guard parent == nil || parent?.type == .category else {
            throw DiscordRestError.UnusableParent
        }
        let p = CreatChannelPayload.init(name: name, type: .voice, topic: nil, bitrate: bitrate, userLimit: userLimit, rateLimitPerUser: nil, position: pos, permissionOverwrites: overwrites, parentId: parent?.id, nsfw: nil)
        return client.rest.execute(.GuildChannelsCreate(id), p)
    }
    
    public func leave() {
        client.rest.execute(.UserGuildLeave(id))
    }
    
    public func getEmojis() -> EventLoopFuture<Emoji> {
        return client.rest.execute(.GuildEmojisGet(id))
    }
    
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
        case inviteSplash = "INVITE_SPLASH"
        case vipVoice = "VIP_REGIONS"
        case vanityUrl = "VANITY_URL"
        case verified = "VERIFIED"
        case partnered = "PARTNERED"
        case `public` = "PUBLIC"
        case commerce = "COMMERCE"
        case news = "NEWS"
        case discoverable = "DISCOVERABLE"
        case featureable = "FEATURABLE"
        case animatedIcon = "ANIMATED_ICON"
        case banner = "BANNER"
        case publicDisabled = "PUBLIC_DISABLED"
        case welcomeScreenEnabled = "WELCOME_SCREEN_ENABLED"
    }
    
    public struct SystemChannelFlags: OptionSet, Codable {
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public let rawValue: Int
        public typealias RawValue = Int
        
        public static let suppressJoinNotifications = SystemChannelFlags(rawValue: 1 << 0)
        public static let suppressPremiumSubscriptions = SystemChannelFlags(rawValue: 1 << 1)
    }
    
    public enum PremiumTier: Int, Codable {
        case none, tierOne, tierTwo, tierThree
    }
}
