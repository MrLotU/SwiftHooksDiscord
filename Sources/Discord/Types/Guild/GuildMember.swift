public struct GuildMember: DiscordGatewayType {
    public internal(set) var user: User! // Missing in MESSAGE_CREATE
    public let nick: String?
    public let roles: [Snowflake]
    public let joinedAt: String
    public let isDeafened: Bool
    public let isMuted: Bool
    public internal(set) var guildId: Snowflake? // Only sent with GUILD_CREATE
    
    enum CodingKeys: String, CodingKey {
        case user, nick, roles
        case joinedAt = "joined_at", isDeafened = "deaf", isMuted = "mute", guildId = "guild_id"
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
        return "<GuildMember \(user?.id)>"
    }
}

extension GuildMember {
    public var name: String {
        return nick ?? user.username
    }
    
//    public func kick() {
//        handler.client.execute(.GuildMembersRemove(guild.id, id))
//    }
//    
//    public func ban() throws {
//        try guild.ban(self)
//    }
//    
//    public func unban() throws {
//        try guild.unban(self)
//    }
//    
//    public func setNickname(_ nick: String) {
//        if self.handler.state.me.id == self.user.id {
//            self.handler.client.execute(.GuildMembersModifyNickMe(id), ModifyNickMePayload(nick: nick))
//        } else {
//            let p = ModifyGuildMemberPayload.init(nick: nick, roles: nil, mute: nil, deaf: nil, channel_id: nil)
//            self.handler.client.execute(.GuildMembersModify(guild.id, id), p)
//        }
//    }
//    
//    public func clearNickname() {
//        self.setNickname("")
//    }
//    
//    public func modify(roles: [GuildRole]? = nil, isMuted: Bool? = nil, isDeafened: Bool? = nil, voiceChannel: Snowflake? = nil) {
//        let p = ModifyGuildMemberPayload.init(nick: nil, roles: roles, mute: isMuted, deaf: isDeafened, channel_id: voiceChannel)
//        self.handler.client.execute(.GuildMembersModify(guild.id, id), p)
//    }
//    
//    public func addRole(_ role: GuildRole) {
//        self.handler.client.execute(.GuildMembersRoleAdd(guild.id, id, role.id))
//    }
//    
//    public func removeRole(_ role: GuildRole) {
//        self.handler.client.execute(.GuildMembersRoleRemove(guild.id, id, role.id))
//    }
//    
//    public var isOwner: Bool {
//        return guild.ownerId == id
//    }
//    
//    public var id: Snowflake {
//        return user.id
//    }
//    
//    public var mention: String {
//        if nick != nil {
//            return "<@!\(self.id)>"
//        }
//        return user.mention
//    }
//    
//    public var permissions: Permission {
//        // TODO: Imp
//        fatalError()
//    }
//    
//    public var guild: Guild {
//        // If we get a GuildMember without a guild, something went wrong bigtime
//        // so the crash in here is "ok"
//        guard let gId = self.guildId else { fatalError() }
//        return self.handler.state.guilds[gId]!
//    }
}
