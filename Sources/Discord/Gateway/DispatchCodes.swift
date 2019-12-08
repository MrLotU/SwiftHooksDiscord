import Foundation

public struct _DiscordEvent<E: EventType, ContentType: PayloadType>: _Event {
    public let event: E
    public init(_ e: E, _ t: ContentType.Type) {
        self.event = e
    }
}

public enum DiscordEvent: String, Codable, EventType {
    case _hello = "HELLO"
    case _ready = "READY"
    case _resumed = "RESUMED"
    case _invalidSession = "INVALID_SESSION"
    case _channelCreate = "CHANNEL_CREATE"
    case _channelUpdate = "CHANNEL_UPDATE"
    case _channelDelete = "CHANNEL_DELETE"
    case _channelPinsUpdate = "CHANNEL_PINS_UPDATE"
    case _guildCreate = "GUILD_CREATE"
    case _guildUpdate = "GUILD_UPDATE"
    case _guildDelete = "GUILD_DELETE"
    case _guildBanAdd = "GUILD_BAN_ADD"
    case _guildBanRemove = "GUILD_BAN_REMOVE"
    case _guildEmojisUpdate = "GUILD_EMOJIS_UPDATE"
    case _guildIntegrationsUpdate = "GUILD_INTEGRATIONS_UPDATE"
    case _guildMemberAdd = "GUILD_MEMBER_ADD"
    case _guildMemberRemove = "GUILD_MEMBER_REMOVE"
    case _guildMemberUpdate = "GUILD_MEMBER_UPDATE"
    case _guildMembersChunk = "GUILD_MEMBERS_CHUNK"
    case _guildRoleCreate = "GUILD_ROLE_CREATE"
    case _guildRoleUpdate = "GUILD_ROLE_UPDATE"
    case _guildRoleDelete = "GUILD_ROLE_DELETE"
    case _messageCreate = "MESSAGE_CREATE"
    case _messageUpdate = "MESSAGE_UPDATE"
    case _messageDelete = "MESSAGE_DELETE"
    case _messageDeleteBulk = "MESSAGE_DELETE_BULK"
    case _messageReactionAdd = "MESSAGE_REACTION_ADD"
    case _messageReactionRemove = "MESSAGE_REACTION_REMOVE"
    case _messageReactionRemoveAll = "MESSAGE_REACTION_REMOVE_ALL"
    case _presenceUpdate = "PRESENCE_UPDATE"
    case _typingStart = "TYPING_START"
    case _userUpdate = "USER_UPDATE"
    case _voiceStateUpdate = "VOICE_STATE_UPDATE"
    case _voiceServerUpdate = "VOICE_SERVER_UPDATE"
    case _webhooksUpdate = "WEBHOOKS_UPDATE"

//    public static let hello = _DiscordEvent(DiscordEvent._hello, GatewayHello.self)
//    public static let ready = _DiscordEvent(DiscordEvent._ready, GatewayReady.self)
//    public static let resumed = _DiscordEvent(DiscordEvent._resumed, GatewayResumed.self)
//    public static let invalidSession = _DiscordEvent(DiscordEvent._invalidSession, Empty.self)
//    public static let channelCreate = _DiscordEvent(DiscordEvent._channelCreate, Channel.self)
//    public static let channelUpdate = _DiscordEvent(DiscordEvent._channelUpdate, Channel.self)
//    public static let channelDelete = _DiscordEvent(DiscordEvent._channelDelete, Channel.self)
//    public static let channelPinsUpdate = _DiscordEvent(DiscordEvent._channelPinsUpdate, GatewayChannelPinsUpdate.self)
    public static let guildCreate = _DiscordEvent(DiscordEvent._guildCreate, Guild.self)
    public static let guildUpdate = _DiscordEvent(DiscordEvent._guildUpdate, Guild.self)
//    public static let guildDelete = _DiscordEvent(DiscordEvent._guildDelete, UnavailableGuild.self)
//    public static let guildBanAdd = _DiscordEvent(DiscordEvent._guildBanAdd, GatewayGuildBanEvent.self)
//    public static let guildBanRemove = _DiscordEvent(DiscordEvent._guildBanRemove, GatewayGuildBanEvent.self)
//    public static let guildEmojisUpdate = _DiscordEvent(DiscordEvent._guildEmojisUpdate, GatewayGuildEmojisUpdate.self)
//    public static let guildIntegrationsUpdate = _DiscordEvent(DiscordEvent._guildIntegrationsUpdate, GatewayGuildIntegrationsUpdate.self)
//    public static let guildMemberAdd = _DiscordEvent(DiscordEvent._guildMemberAdd, GuildMember.self)
//    public static let guildMemberRemove = _DiscordEvent(DiscordEvent._guildMemberRemove, GatewayGuildMemberRemove.self)
//    public static let guildMemberUpdate = _DiscordEvent(DiscordEvent._guildMemberUpdate, GatewayGuildMemberUpdate.self)
//    public static let guildMembersChunk = _DiscordEvent(DiscordEvent._guildMembersChunk, GatewayGuildMembersChunk.self)
//    public static let guildRoleCreate = _DiscordEvent(DiscordEvent._guildRoleCreate, GatewayGuildRoleEvent.self)
//    public static let guildRoleUpdate = _DiscordEvent(DiscordEvent._guildRoleUpdate, GatewayGuildRoleEvent.self)
//    public static let guildRoleDelete = _DiscordEvent(DiscordEvent._guildRoleDelete, GatewayGuildRoleDelete.self)
    public static let messageCreate = _DiscordEvent(DiscordEvent._messageCreate, DiscordMessage.self)
    public static let messageUpdate = _DiscordEvent(DiscordEvent._messageUpdate, DiscordMessage.self)
//    public static let messageDelete = _DiscordEvent(DiscordEvent._messageDelete, GatewayMessageDelete.self)
//    public static let messageDeleteBulk = _DiscordEvent(DiscordEvent._messageDeleteBulk, GatewayMessageDeleteBulk.self)
//    public static let messageReactionAdd = _DiscordEvent(DiscordEvent._messageReactionAdd, GatewayMessageReactionEvent.self)
//    public static let messageReactionRemove = _DiscordEvent(DiscordEvent._messageReactionRemove, GatewayMessageReactionEvent.self)
//    public static let messageReactionRemoveAll = _DiscordEvent(DiscordEvent._messageReactionRemoveAll, GatewayMessageReactionRemoveAll.self)
//    public static let presenceUpdate = _DiscordEvent(DiscordEvent._presenceUpdate, GatewayPresenceUpdate.self)
//    public static let typingStart = _DiscordEvent(DiscordEvent._typingStart, GatewayTypingStart.self)
//    public static let userUpdate = _DiscordEvent(DiscordEvent._userUpdate, User.self)
    public static let voiceStateUpdate = _DiscordEvent(DiscordEvent._voiceStateUpdate, Empty.self)
//    public static let voiceServerUpdate = _DiscordEvent(DiscordEvent._voiceServerUpdate, GatewayVoiceServerUpdate.self)
//    public static let webhooksUpdate = _DiscordEvent(DiscordEvent._webhooksUpdate, GatewayWebhooksUpdate.self)
}

public struct Empty: PayloadType { }
