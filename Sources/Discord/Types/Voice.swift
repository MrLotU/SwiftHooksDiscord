public struct VoiceState: Codable, DiscordHandled {
    public internal(set) var client: DiscordClient! {
        didSet {
            self.member?.client = self.client
            self.member?.guildId = self.guildId
        }
    }
    
    public let guildId: Snowflake?
    public let channelId: Snowflake?
    public let userId: Snowflake
    public let member: GuildMember?
    public let sessionId: String
    public let deaf: Bool
    public let mute: Bool
    public let selfDeaf: Bool
    public let selfMute: Bool
    public let selfStream: Bool?
    public let suppress: Bool
    
    enum CodingKeys: String, CodingKey {
        case guildId = "guild_id", channelId = "channel_id", userId = "user_id"
        case member, sessionId = "session_id", deaf, mute, selfDeaf = "self_deaf"
        case selfMute = "self_mute", selfStream = "self_stream", suppress
    }
}

public struct VoiceRegion: Codable {
    public let id: String
    public let name: String
    public let vip: Bool
    public let optimal: Bool
    public let deprecated: Bool
    public let custom: Bool
}
