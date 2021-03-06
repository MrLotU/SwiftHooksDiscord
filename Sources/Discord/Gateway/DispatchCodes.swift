import Foundation
import protocol NIO.EventLoop

extension CommandEvent {
    public var discord: DiscordClient? {
        guard let h = hook as? DiscordHook else { return nil }
        return _DiscordClient(h, eventLoop: eventLoop)
    }
}

public struct DiscordDispatch: EventDispatch, DiscordClient {
    public let eventLoop: EventLoop
    private let client: DiscordClient
    private let _hooks: SwiftHooks?
    
    public var rest: DiscordRESTClient {
        client.rest
    }
    
    public var state: State {
        client.state
    }
    
    public var options: DiscordHookOptions {
        client.options
    }
    
    public var hooks: SwiftHooks {
        precondition(_hooks != nil, "Hooks not found. You can only access hooks when using DiscordHook through the SwiftHooks backbone.")
        return _hooks!
    }
    
    public init?(_ h: _Hook, eventLoop: EventLoop) {
        guard let h = h as? DiscordHook else { return nil }
        self.eventLoop = eventLoop
        self.client = _DiscordClient(h, eventLoop: eventLoop)
        self._hooks = h.hooks
    }
}

public struct _DiscordEvent<ContentType: PayloadType>: _Event {
    public typealias E = DiscordEvent
    public typealias D = DiscordDispatch
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
}

public enum Discord {
    public static let hello = _DiscordEvent(._hello, GatewayHello.self)
    public static let ready = _DiscordEvent(._ready, GatewayReady.self)
    public static let resumed = _DiscordEvent(._resumed, GatewayResumed.self)
    public static let invalidSession = _DiscordEvent(._invalidSession, Empty.self)
    public static let channelCreate = _DiscordEvent(._channelCreate, Channel.self)
    public static let channelUpdate = _DiscordEvent(._channelUpdate, Channel.self)
    public static let channelDelete = _DiscordEvent(._channelDelete, Channel.self)
    public static let channelPinsUpdate = _DiscordEvent(._channelPinsUpdate, GatewayChannelPinsUpdate.self)
    public static let guildCreate = _DiscordEvent(._guildCreate, Guild.self)
    public static let guildUpdate = _DiscordEvent(._guildUpdate, Guild.self)
    public static let guildDelete = _DiscordEvent(._guildDelete, UnavailableGuild.self)
    public static let guildBanAdd = _DiscordEvent(._guildBanAdd, GatewayGuildBanEvent.self)
    public static let guildBanRemove = _DiscordEvent(._guildBanRemove, GatewayGuildBanEvent.self)
    public static let guildEmojisUpdate = _DiscordEvent(._guildEmojisUpdate, GatewayGuildEmojisUpdate.self)
    public static let guildIntegrationsUpdate = _DiscordEvent(._guildIntegrationsUpdate, GatewayGuildIntegrationsUpdate.self)
    public static let guildMemberAdd = _DiscordEvent(._guildMemberAdd, GuildMember.self)
    public static let guildMemberRemove = _DiscordEvent(._guildMemberRemove, GatewayGuildMemberRemove.self)
    public static let guildMemberUpdate = _DiscordEvent(._guildMemberUpdate, GatewayGuildMemberUpdate.self)
    public static let guildMembersChunk = _DiscordEvent(._guildMembersChunk, GatewayGuildMembersChunk.self)
    public static let guildRoleCreate = _DiscordEvent(._guildRoleCreate, GatewayGuildRoleEvent.self)
    public static let guildRoleUpdate = _DiscordEvent(._guildRoleUpdate, GatewayGuildRoleEvent.self)
    public static let guildRoleDelete = _DiscordEvent(._guildRoleDelete, GatewayGuildRoleDelete.self)
    public static let messageCreate = _DiscordEvent(._messageCreate, Message.self)
    public static let messageUpdate = _DiscordEvent(._messageUpdate, Message.self)
    public static let messageDelete = _DiscordEvent(._messageDelete, GatewayMessageDelete.self)
    public static let messageDeleteBulk = _DiscordEvent(._messageDeleteBulk, GatewayMessageDeleteBulk.self)
    public static let messageReactionAdd = _DiscordEvent(._messageReactionAdd, GatewayMessageReactionEvent.self)
    public static let messageReactionRemove = _DiscordEvent(._messageReactionRemove, GatewayMessageReactionEvent.self)
    public static let messageReactionRemoveAll = _DiscordEvent(._messageReactionRemoveAll, GatewayMessageReactionRemoveAll.self)
    public static let presenceUpdate = _DiscordEvent(._presenceUpdate, GatewayPresenceUpdate.self)
    public static let typingStart = _DiscordEvent(._typingStart, GatewayTypingStart.self)
    public static let userUpdate = _DiscordEvent(._userUpdate, User.self)
    public static let voiceStateUpdate = _DiscordEvent(._voiceStateUpdate, Empty.self)
    public static let voiceServerUpdate = _DiscordEvent(._voiceServerUpdate, GatewayVoiceServerUpdate.self)
    public static let webhooksUpdate = _DiscordEvent(._webhooksUpdate, GatewayWebhooksUpdate.self)
}

public struct Empty: Codable, PayloadType, QueryItemConvertible {
    public func toQueryItems() -> [URLQueryItem] {
        return []
    }
}
