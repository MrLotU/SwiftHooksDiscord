public class GuildMember: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient! {
        didSet {
            self.user?.client = client
        }
    }
    public internal(set) var user: User! // Missing in MESSAGE_CREATE or MESSAGE_UPDATE
    public let nick: String?
    public let roles: [Snowflake]
    public let joinedAt: String
    public let premiumSince: String?
    public let isDeafened: Bool
    public let isMuted: Bool
    public internal(set) var guildId: Snowflake? // Only sent with GUILD_CREATE
    
    enum CodingKeys: String, CodingKey {
        case user, nick, roles, joinedAt = "joined_at"
        case premiumSince = "premium_since", isDeafened = "deaf", isMuted = "mute", guildId = "guild_id"
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
    
    public func kick() {
        client.rest.execute(.GuildMembersRemove(guild.id, id))
    }
    
    public func ban() throws {
        try guild.ban(self)
    }
    
    public func unban() throws {
        try guild.unban(self)
    }
    
    public func setNickname(_ nick: String) {
        if self.client.state.me.id == self.user.id {
            self.client.rest.execute(.GuildMembersModifyNickMe(id), ModifyNickMePayload(nick: nick))
        } else {
            let p = ModifyGuildMemberPayload.init(nick: nick, roles: nil, mute: nil, deaf: nil, channel_id: nil)
            self.client.rest.execute(.GuildMembersModify(guild.id, id), p)
        }
    }
    
    public func clearNickname() {
        self.setNickname("")
    }
    
    public func modify(roles: [GuildRole]? = nil, isMuted: Bool? = nil, isDeafened: Bool? = nil, voiceChannel: Snowflake? = nil) {
        let p = ModifyGuildMemberPayload.init(nick: nil, roles: roles?.map(\.id), mute: isMuted, deaf: isDeafened, channel_id: voiceChannel)
        self.client.rest.execute(.GuildMembersModify(guild.id, id), p)
    }

    public func addRole(_ role: GuildRole) {
        self.client.rest.execute(.GuildMembersRoleAdd(guild.id, id, role.id))
    }

    public func removeRole(_ role: GuildRole) {
        self.client.rest.execute(.GuildMembersRoleRemove(guild.id, id, role.id))
    }

    public var isOwner: Bool {
        return guild.ownerId == id
    }
    
    public var id: Snowflake {
        return user.id
    }
    
    public var mention: String {
        if nick != nil {
            return "<@!\(self.id)>"
        }
        return user.mention
    }
    
    public var permissions: Permissions {
        self.guild.getPermissions(for: self)
    }
    
    public var guild: Guild {
        // If we get a GuildMember without a guild, something went wrong bigtime
        // so the crash in here is "ok"
        guard let gId = self.guildId else { fatalError() }
        return self.client.state.guilds[gId]!
    }
}
