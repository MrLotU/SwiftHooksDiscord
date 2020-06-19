import Foundation
import NIO

public final class Guild: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient! {
        didSet {
            for member in self.members ?? [] {
                member.client = client
                member.guildId = self.id
            }
            for channel in self.channels ?? [] {
                channel.client = client
            }
        }
    }
    
    public let id: Snowflake
    public internal(set) var name: String
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
    public let voiceStates: [VoiceState]!
    public internal(set) var members: [GuildMember]!
    public internal(set) var channels: [Channel]!
    public let presences: [GatewayPresenceUpdate]!
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
    
    func copyWith(_ client: DiscordClient) -> Guild {
        let x = Guild(id: id, name: name, icon: icon, splash: splash, discoverySplash: discoverySplash, isOwner: isOwner, ownerId: ownerId, permissions: permissions, region: region, afkChannelId: afkChannelId, afkTimeout: afkTimeout, verificationLevel: verificationLevel, defaultMessageNotifications: defaultMessageNotifications, explicitContentFilter: explicitContentFilter, roles: roles, emojis: emojis, features: features, mfaLevel: mfaLevel, applicationId: applicationId, widgetEnabled: widgetEnabled, widgetChannelId: widgetChannelId, systemChannelId: systemChannelId, systemChannelFlags: systemChannelFlags, rulesChannelId: rulesChannelId, joinedAt: joinedAt, isLarge: isLarge, isUnavailable: isUnavailable, memberCount: memberCount, voiceStates: voiceStates, members: members, channels: channels, presences: presences, maxPresences: maxPresences, maxMembers: maxMembers, vanityUrlCode: vanityUrlCode, description: description, banner: banner, premiumTier: premiumTier, premiumSubscriptionCount: premiumSubscriptionCount, preferredLocale: preferredLocale, publicUpdatesChannelId: publicUpdatesChannelId, maxVideoChannelUsers: maxVideoChannelUsers, approximateMemberCount: approximateMemberCount, approximatePresenceCount: approximatePresenceCount)
        x.client = client
        return x
    }
    
    internal init(id: Snowflake, name: String, icon: String?, splash: String?, discoverySplash: String?, isOwner: Bool?, ownerId: Snowflake, permissions: Permissions?, region: String, afkChannelId: Snowflake?, afkTimeout: TimeInterval?, verificationLevel: Guild.VerificationLevel, defaultMessageNotifications: Guild.NotificationLevel, explicitContentFilter: Guild.ExplicitContentFilterLevel, roles: [GuildRole], emojis: [Emoji], features: [Guild.Feature], mfaLevel: Guild.MFALevel, applicationId: Snowflake?, widgetEnabled: Bool?, widgetChannelId: Snowflake?, systemChannelId: Snowflake?, systemChannelFlags: Guild.SystemChannelFlags, rulesChannelId: Snowflake?, joinedAt: String?, isLarge: Bool?, isUnavailable: Bool?, memberCount: Int?, voiceStates: [VoiceState], members: [GuildMember], channels: [Channel], presences: [GatewayPresenceUpdate], maxPresences: Int?, maxMembers: Int?, vanityUrlCode: String?, description: String?, banner: String?, premiumTier: Guild.PremiumTier, premiumSubscriptionCount: Int?, preferredLocale: String, publicUpdatesChannelId: Snowflake?, maxVideoChannelUsers: Int?, approximateMemberCount: Int?, approximatePresenceCount: Int?) {
        self.id = id
        self.name = name
        self.icon = icon
        self.splash = splash
        self.discoverySplash = discoverySplash
        self.isOwner = isOwner
        self.ownerId = ownerId
        self.permissions = permissions
        self.region = region
        self.afkChannelId = afkChannelId
        self.afkTimeout = afkTimeout
        self.verificationLevel = verificationLevel
        self.defaultMessageNotifications = defaultMessageNotifications
        self.explicitContentFilter = explicitContentFilter
        self.roles = roles
        self.emojis = emojis
        self.features = features
        self.mfaLevel = mfaLevel
        self.applicationId = applicationId
        self.widgetEnabled = widgetEnabled
        self.widgetChannelId = widgetChannelId
        self.systemChannelId = systemChannelId
        self.systemChannelFlags = systemChannelFlags
        self.rulesChannelId = rulesChannelId
        self.joinedAt = joinedAt
        self.isLarge = isLarge
        self.isUnavailable = isUnavailable
        self.memberCount = memberCount
        self.voiceStates = voiceStates
        self.members = members
        self.channels = channels
        self.presences = presences
        self.maxPresences = maxPresences
        self.maxMembers = maxMembers
        self.vanityUrlCode = vanityUrlCode
        self.description = description
        self.banner = banner
        self.premiumTier = premiumTier
        self.premiumSubscriptionCount = premiumSubscriptionCount
        self.preferredLocale = preferredLocale
        self.publicUpdatesChannelId = publicUpdatesChannelId
        self.maxVideoChannelUsers = maxVideoChannelUsers
        self.approximateMemberCount = approximateMemberCount
        self.approximatePresenceCount = approximatePresenceCount
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
        return client.rest.execute(.GuildRolesCreate(id, p))
    }
    
    public func deleteRole(_ role: GuildRole) -> EventLoopFuture<Void> {
        client.rest.execute(.GuildRolesDelete(id, role.id)).toVoidFuture()
    }
    
    public func requestGuildMembers() {
//        self.client.
        // TODO: Imp
    }
    
    public func getBans() -> EventLoopFuture<[GuildBan]> {
        return client.rest.execute(.GuildBansList(id))
    }
    
    public func ban(_ member: Snowflakable, deleteMessagesDays: Int? = nil, reason: String? = nil) -> EventLoopFuture<Void> {
        guard member is GuildMember || member is User else {
            return client.eventLoop.makeFailedFuture(DiscordRestError.UnbannableInstance)
        }
        
        let q = GuildBanQuery(deleteMessageDays: deleteMessagesDays, reason: reason)
        return client.rest.execute(.GuildBansCreate(id, member.snowflakeDescription, q)).toVoidFuture()
    }
    
    public func unban(_ member: Snowflakable) -> EventLoopFuture<Void> {
        guard member is GuildMember || member is User else {
            return client.eventLoop.makeFailedFuture(DiscordRestError.UnbannableInstance)
        }
        
        return client.rest.execute(.GuildBansRemove(id, member.snowflakeDescription)).toVoidFuture()
    }
    
    public func createCategory(named name: String, at pos: Int? = nil) -> EventLoopFuture<Channel> {
        let p = CreatChannelPayload.init(name: name, type: .category, topic: nil, bitrate: nil, userLimit: nil, rateLimitPerUser: nil, position: pos, permissionOverwrites: nil, parentId: nil, nsfw: nil)
        return client.rest.execute(.GuildChannelsCreate(id, p))
    }
    
    public func createTextChannel(named name: String, at pos: Int? = nil, parent: Channel? = nil, topic: String? = nil, isNsfw: Bool? = nil, rateLimitPerUser: Int? = nil, permissionOverwrites: [PermissionOverwrite]? = nil, on client: DiscordClient? = nil) -> EventLoopFuture<Channel> {
        let client: DiscordClient! = client ?? self.client
        guard parent == nil || parent?.type == .category else {
            return client.eventLoop.makeFailedFuture(DiscordRestError.UnusableParent)
        }
        let p = CreatChannelPayload.init(name: name, type: .text, topic: topic, bitrate: nil, userLimit: nil, rateLimitPerUser: rateLimitPerUser, position: pos, permissionOverwrites: permissionOverwrites, parentId: parent?.id, nsfw: isNsfw)
        return client.rest.execute(.GuildChannelsCreate(id, p)).map { (x: Channel) in
            x.client = client
            return x
        }
    }
    
    public func createVoiceChannel(named name: String, at pos: Int? = nil, parent: Channel? = nil, bitrate: Int? = nil, userLimit: Int? = nil, overwrites: [PermissionOverwrite]? = nil, on client: DiscordClient? = nil) -> EventLoopFuture<Channel> {
        let client: DiscordClient! = client ?? self.client
        guard parent == nil || parent?.type == .category else {
            return client.eventLoop.makeFailedFuture(DiscordRestError.UnusableParent)
        }
        let p = CreatChannelPayload.init(name: name, type: .voice, topic: nil, bitrate: bitrate, userLimit: userLimit, rateLimitPerUser: nil, position: pos, permissionOverwrites: overwrites, parentId: parent?.id, nsfw: nil)
        return client.rest.execute(.GuildChannelsCreate(id, p)).map { (c: Channel) in
            c.client = client
            return c
        }
    }
    
    public func leave() -> EventLoopFuture<Void> {
        client.rest.execute(.UserGuildLeave(id)).toVoidFuture()
    }
    
    public func getEmojis() -> EventLoopFuture<[Emoji]> {
        return client.rest.execute(.GuildEmojisGet(id))
    }
    
    public func getIconUrl(_ format: String = "png", _ size: Int = 1024) -> String? {
        guard let icon = self.icon else { return nil }
        return "https://cdn.discord.com/icons/\(id)/\(icon).\(format)?size=\(size)"
    }
    
    public func getSplashUrl(_ format: String = "png", _ size: Int = 1024) -> String? {
        guard let splash = self.splash else { return nil }
        return "https://cdn.discord.com/splashes/\(id)/\(splash).\(format)?size=\(size)"
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
        case community = "COMMUNITY"
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
