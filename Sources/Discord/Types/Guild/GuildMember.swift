import NIO
import Foundation

public final class GuildMember: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient! {
        didSet {
            self.user?.client = client
        }
    }
    public internal(set) var user: User! // Missing in MESSAGE_CREATE or MESSAGE_UPDATE
    public internal(set) var nick: String?
    public internal(set) var roles: [Snowflake]
    public let joinedAt: Date
    public let premiumSince: String?
    public let isDeafened: Bool
    public let isMuted: Bool
    public internal(set) var guildId: Snowflake? // Only sent with GUILD_CREATE
    
    enum CodingKeys: String, CodingKey {
        case user, nick, roles, joinedAt = "joined_at"
        case premiumSince = "premium_since", isDeafened = "deaf", isMuted = "mute", guildId = "guild_id"
    }
    
    func copyWith(_ client: DiscordClient) -> GuildMember {
        let x = GuildMember(user: user, nick: nick, roles: roles, joinedAt: joinedAt, premiumSince: premiumSince, isDeafened: isDeafened, isMuted: isMuted, guildId: guildId)
        x.client = client
        return x
    }
    
    internal init(user: User?, nick: String?, roles: [Snowflake], joinedAt: Date, premiumSince: String?, isDeafened: Bool, isMuted: Bool, guildId: Snowflake? = nil) {
        self.user = user
        self.nick = nick
        self.roles = roles
        self.joinedAt = joinedAt
        self.premiumSince = premiumSince
        self.isDeafened = isDeafened
        self.isMuted = isMuted
        self.guildId = guildId
    }
    
    
    public lazy var guild: Guild = {
        // If we get a GuildMember without a guild, something went wrong bigtime
        // so the crash in here is "ok"
        guard let gId = self.guildId else { fatalError() }
        return self.client.state.guilds[gId]!
    }()
}

extension GuildMember: Userable {
    public var identifier: String? {
        return self.id.asString
    }
}

extension GuildMember: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return user.snowflakeDescription
    }
}

extension GuildMember: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return user.description
    }
    
    public var debugDescription: String {
        return "<GuildMember \(user?.id.description ?? "")>"
    }
}

extension GuildMember {
    public var name: String {
        return nick ?? user.username
    }
    
    public func kick() -> EventLoopFuture<Void> {
        client.rest.execute(.GuildMembersRemove(guild.id, id)).toVoidFuture()
    }
    
    public func ban() -> EventLoopFuture<Void> {
        guild.ban(self)
    }
    
    public func unban() -> EventLoopFuture<Void> {
        guild.unban(self)
    }
    
    public func setNickname(_ nick: String) -> EventLoopFuture<Void> {
        if self.client.state.me.id == self.user.id {
            return self.client.rest.execute(.GuildMembersModifyNickMe(guild.id, ModifyNickMePayload(nick: nick))).toVoidFuture()
        } else {
            let p = ModifyGuildMemberPayload.init(nick: nick, roles: nil, mute: nil, deaf: nil, channel_id: nil)
            return self.client.rest.execute(.GuildMembersModify(guild.id, id, p)).toVoidFuture()
        }
    }
    
    public func clearNickname() -> EventLoopFuture<Void> {
        self.setNickname("").toVoidFuture()
    }
    
    public func modify(roles: [GuildRole]? = nil, isMuted: Bool? = nil, isDeafened: Bool? = nil, voiceChannel: Snowflake? = nil) -> EventLoopFuture<Void> {
        let p = ModifyGuildMemberPayload.init(nick: nil, roles: roles?.map(\.id), mute: isMuted, deaf: isDeafened, channel_id: voiceChannel)
        return self.client.rest.execute(.GuildMembersModify(guild.id, id, p)).toVoidFuture()
    }

    public func addRole(_ role: GuildRole) -> EventLoopFuture<Void> {
        self.client.rest.execute(.GuildMembersRoleAdd(guild.id, id, role.id)).toVoidFuture()
    }

    public func removeRole(_ role: GuildRole) -> EventLoopFuture<Void> {
        self.client.rest.execute(.GuildMembersRoleRemove(guild.id, id, role.id)).toVoidFuture()
    }

    public var isOwner: Bool {
        return guild.ownerId == id
    }
    
    public var id: Snowflake {
        return user.id
    }
    
    public var mention: String {
        return user.mention
    }
    
    public var permissions: Permissions {
        self.guild.getPermissions(for: self)
    }
}
