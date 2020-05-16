import NIO
import Foundation

public final class Channel: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient! {
        didSet {
            for user in self.recipients ?? [] {
                user.client = client
            }
        }
    }
    public let id: Snowflake
    public let type: ChannelType
    public internal(set) var guildId: Snowflake?
    public let position: Int?
    public let permissionOverwrites: [PermissionOverwrite]?
    public let name: String?
    public let topic: String?
    public let nsfw: Bool?
    public let lastMessageId: Snowflake?
    public let bitrate: Int?
    public let userLimit: Int?
    public let ratelimitPerUser: Int?
    public let recipients: [User]?
    public let icon: String?
    public let ownerId: Snowflake?
    public let applicationId: Snowflake?
    public let parentId: Snowflake?
    public let lastPinTimestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, position, name, topic, nsfw, bitrate, recipients, icon
        case guildId = "guild_id", permissionOverwrites = "permission_overwrites"
        case lastMessageId = "last_message_id", userLimit = "user_limit"
        case ratelimitPerUser = "ratelimit_per_user", ownerId = "owner_id"
        case applicationId = "application_id", parentId = "parent_id"
        case lastPinTimestamp = "last_pin_timestamp"
    }
    
    public lazy var guild: Guild? = {
        guard let gId = guildId else { return nil }
        return client.state.guilds[gId]?.copyWith(self.client)
    }()

    public lazy var parent: Channel? = {
        guard let pId = parentId else { return nil }
        return client.state.channels[pId]?.copyWith(self.client)
    }()
    
    func copyWith(_ client: DiscordClient) -> Channel {
        let x = Channel(id: id, type: type, guildId: guildId, position: position, permissionOverwrites: permissionOverwrites, name: name, topic: topic, nsfw: nsfw, lastMessageId: lastMessageId, bitrate: bitrate, userLimit: userLimit, ratelimitPerUser: ratelimitPerUser, recipients: recipients, icon: icon, ownerId: ownerId, applicationId: applicationId, parentId: parentId, lastPinTimestamp: lastPinTimestamp)
        x.client = client
        return x
    }
    
    internal init(id: Snowflake, type: ChannelType, guildId: Snowflake?, position: Int?, permissionOverwrites: [PermissionOverwrite]?, name: String?, topic: String?, nsfw: Bool?, lastMessageId: Snowflake?, bitrate: Int?, userLimit: Int?, ratelimitPerUser: Int?, recipients: [User]?, icon: String?, ownerId: Snowflake?, applicationId: Snowflake?, parentId: Snowflake?, lastPinTimestamp: String?) {
        self.id = id
        self.type = type
        self.guildId = guildId
        self.position = position
        self.permissionOverwrites = permissionOverwrites
        self.name = name
        self.topic = topic
        self.nsfw = nsfw
        self.lastMessageId = lastMessageId
        self.bitrate = bitrate
        self.userLimit = userLimit
        self.ratelimitPerUser = ratelimitPerUser
        self.recipients = recipients
        self.icon = icon
        self.ownerId = ownerId
        self.applicationId = applicationId
        self.parentId = parentId
        self.lastPinTimestamp = lastPinTimestamp
    }
}

extension Channel: Channelable {
    public func send(_ msg: String) -> EventLoopFuture<Messageable> {
        self.send(msg, isTts: false).map { $0 as Messageable }
    }
}

extension Channel: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "\(self.name ?? "\(self.id)")"
    }
    
    public var debugDescription: String {
        return "<Channel \(self.id) (\(description))>"
    }
}

extension Channel: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return self.id
    }
}

extension Channel {
    public var mention: String {
        return "<#\(self.id)>"
    }
    
    public var isGuild: Bool {
        return [ChannelType.text, .voice, .category].contains(self.type)
    }
    
    public var isDm: Bool {
        return [ChannelType.dm, .groupDM].contains(self.type)
    }
    
    public var isNsfw: Bool {
        return self.type == .text && self.nsfw ?? false
    }
    
    public var isVoice: Bool {
        return self.type == .voice || self.isDm
    }
}

extension Channel {
    func get(message id: Snowflake) -> EventLoopFuture<Message> {
        return self.client.rest.execute(.ChannelMessagesGet(self, id)).map(setClient)
    }

    func send(_ msg: String, isTts: Bool = false, embed: Embed? = nil) -> EventLoopFuture<Message> {
        let body = MessageCreatePayload(content: msg, nonce: nil, isTts: isTts, embed: embed, allowedMentions: .init(parse: [], roles: [], users: []))

        return self.client.rest.execute(.ChannelMessagesCreate(self, body)).map(setClient)
    }

//    func getInvites() -> EventLoopFuture<[ChannelInvite]> {
//        return self.client.rest.execute(.ChannelInvitesGet(self))
//    }

//    func createInvite
    var pins: EventLoopFuture<[Message]> {
        return self.client.rest.execute(.ChannelPinsGet(self)).map { (msgs: [Message]) in msgs.map(self.setClient) }
    }

    func pin(message id: Snowflake) -> EventLoopFuture<Void> {
        self.client.rest.execute(.ChannelsPinsAdd(self, id)).map { _ in }
    }

    func unpin(message id: Snowflake) -> EventLoopFuture<Void> {
        self.client.rest.execute(.ChannelsPinsDelete(self, id)).map { _ in }
    }

//    var webhooks: EventLoopFuture<[Webhook]> {
//        return self.client.client.execute(.ChannelsWebhooksGet(self))
//    }
//
//    func createWebhook(_ payload: CreateWebhookPayload) throws -> EventLoopFuture<Webhook> {
//        return self.client.client.execute(.WebhookCreate(self), payload).map { $0 as Webhook }
//    }

    func send(_ message: MessageCreatePayload) throws -> EventLoopFuture<Message> {
        return self.client.rest.execute(.ChannelMessagesCreate(self, message)).map(setClient)
    }

    func startTyping() -> EventLoopFuture<Void> {
        self.client.rest.execute(.ChannelTyping(self)).map { _ in }
    }

    func deleteMessages(_ ids: Snowflake...) -> EventLoopFuture<Void> {
        guard !ids.isEmpty else { return self.client.eventLoop.makeSucceededFuture(()) }

        if ids.count == 1, let id = ids.first {
            return self.client.rest.execute(.ChannelMessagesDelete(self, id)).map { _ in }
        }

        let body = BulkDeleteMessagesPayload(messages: ids)

        return self.client.rest.execute(.ChannelMessagesDeleteBulk(self.id, body)).map { _ in }
    }

    func delete() -> EventLoopFuture<Channel> {
        guard self.isDm || self.guild?.permissions?.contains(.manageChannels) ?? false else {
            return self.client.eventLoop.makeFailedFuture(DiscordRestError.InvalidPermissions)
        }
        return self.client.rest.execute(.ChannelDelete(self.id)).map(setClient)
    }

    func close() -> EventLoopFuture<Channel> {
        guard self.isDm else {
            return self.client.eventLoop.makeFailedFuture(DiscordRestError.InvalidPermissions)
        }
        return self.delete()
    }

    func set(
        _ name: String? = nil,
        _ pos: Int? = nil,
        _ topic: String? = nil,
        _ nsfw: Bool? = nil,
        _ rateLimit: Int? = nil,
        _ bitrate: Int? = nil,
        _ userLimit: Int?,
        _ permOverwrites: [PermissionOverwrite]? = nil,
        _ parent: Snowflake? = nil) throws -> EventLoopFuture<Channel> {
        let body = ModifyChannelPayload(name: name, position: pos, topic: topic, isNsfw: nsfw, rateLimit: rateLimit, bitrate: bitrate, userLimit: userLimit, permissionOverwrites: permOverwrites, parentId: parent)
        return self.client.rest.execute(.ChannelModify(self, body)).map(setClient)
    }

    func createTextChannel(named name: String, at pos: Int? = nil, topic: String = "", rateLimitPerUser: Int? = nil, overwrites: [PermissionOverwrite]? = nil, isNsfw: Bool? = nil) -> EventLoopFuture<Channel> {
        guard let guild = self.guild else {
            return self.client.eventLoop.makeFailedFuture(DiscordRestError.NotAGuild)
        }
        return guild.createTextChannel(named: name, at: pos, parent: self, topic: topic, isNsfw: isNsfw, rateLimitPerUser: rateLimitPerUser, permissionOverwrites: overwrites, on: self.client)
    }

    func createVoiceChannel(named name: String, at pos: Int?, bitrate: Int? = nil, userLimit: Int? = nil, overwrites: [PermissionOverwrite]? = nil) -> EventLoopFuture<Channel> {
        guard let guild = self.guild else {
            return self.client.eventLoop.makeFailedFuture(DiscordRestError.NotAGuild)
        }
        return guild.createVoiceChannel(named: name, at: pos, parent: self, bitrate: bitrate, userLimit: userLimit, overwrites: overwrites, on: self.client)
    }
}

internal extension Channel {
    func setClient(_ t: Message) -> Message {
        t.client = self.client
        return t
    }
    
    func setClient(_ t: Channel) -> Channel {
        t.client = self.client
        return t
    }
}

public enum ChannelType: Int, Codable {
    case text = 0, dm = 1, voice = 2, groupDM = 3, category = 4, news = 5, store = 6
}
