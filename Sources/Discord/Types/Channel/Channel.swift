import NIO
import Foundation

public class Channel: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient! {
        didSet {
            for user in self.recipients ?? [] {
                user.client = client
            }
        }
    }
    public let id: Snowflake
    public let type: ChannelType
    public let guildId: Snowflake?
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
    
    public var guild: Guild? {
        guard let gId = guildId else { return nil }
        return client.state.guilds[gId]
    }

    public var parent: Channel? {
        guard let pId = parentId else { return nil }
        return client.state.channels[pId]
    }
}

extension Channel {
    func get(message id: Snowflake) -> EventLoopFuture<Message> {
        return self.client.rest.execute(Route.ChannelMessagesGet(self, id)).map { $0 as Message }
    }

    @discardableResult
    func send(_ msg: String, isTts: Bool = false, embed: Embed? = nil) -> EventLoopFuture<Message> {
        let body = MessageCreatePayload(content: msg, nonce: nil, isTts: isTts, embed: embed, allowedMentions: .init(parse: [], roles: [], users: []))

        return self.client.rest.execute(.ChannelMessagesCreate(self), body).map { $0 as Message }
    }

//    func getInvites(on client: DiscordRESTClient) -> EventLoopFuture<[ChannelInvite]> {
//
//    }

//    func createInvite
    var pins: EventLoopFuture<[Message]> {
        return self.client.rest.execute(.ChannelPinsGet(self)).map { $0 as [Message] }
    }

    func pin(message id: Snowflake) {
        self.client.rest.execute(Route.ChannelsPinsAdd(self, id))
    }

    func unpin(message id: Snowflake) {
        self.client.rest.execute(Route.ChannelsPinsDelete(self, id))
    }

//    var webhooks: EventLoopFuture<[Webhook]> {
//        return self.client.client.execute(.ChannelsWebhooksGet(self))
//    }
//
//    func createWebhook(_ payload: CreateWebhookPayload) throws -> EventLoopFuture<Webhook> {
//        return self.client.client.execute(.WebhookCreate(self), payload).map { $0 as Webhook }
//    }

    func send(_ message: MessageCreatePayload) throws -> EventLoopFuture<Message> {
        return self.client.rest.execute(.ChannelMessagesCreate(self), message).map { $0 as Message }
    }

    func startTyping() {
        self.client.rest.execute(.ChannelTyping(self))
    }

    func delete(messages ids: Snowflake...) throws {
        guard !ids.isEmpty else { return }

        if ids.count == 1, let id = ids.first {
            self.client.rest.execute(.ChannelMessagesDelete(self, id))
            return
        }

        let body = BulkDeleteMessagesPayload(messages: ids)

        self.client.rest.execute(.ChannelMessagesDeleteBulk(self.id), body)
    }

    func delete() throws {
        guard self.isDm || self.guild?.permissions?.contains(.manageChannels) ?? false else { throw DiscordRestError.InvalidPermissions }
        self.client.rest.execute(.ChannelDelete(self.id))
    }

    func close() throws {
        guard self.isDm else { throw DiscordRestError.InvalidPermissions }
        try self.delete()
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
        return self.client.rest.execute(.ChannelModify(self), body).map { $0 as Channel }
    }

    func createTextChannel(named name: String, at pos: Int? = nil, topic: String = "", rateLimitPerUser: Int? = nil, overwrites: [PermissionOverwrite]? = nil, isNsfw: Bool? = nil) throws -> EventLoopFuture<Channel> {
        guard let guild = self.guild else {
            throw DiscordRestError.NotAGuild
        }
        return try guild.createTextChannel(named: name, at: pos, parent: self, topic: topic, isNsfw: isNsfw, rateLimitPerUser: rateLimitPerUser, permissionOverwrites: overwrites)
    }

    func createVoiceChannel(named name: String, at pos: Int?, bitrate: Int? = nil, userLimit: Int? = nil, overwrites: [PermissionOverwrite]? = nil) throws -> EventLoopFuture<Channel> {
        guard let guild = self.guild else {
            throw DiscordRestError.NotAGuild
        }
        return try guild.createVoiceChannel(named: name, at: pos, parent: self, bitrate: bitrate, userLimit: userLimit, overwrites: overwrites)
    }
}

public enum ChannelType: Int, Codable {
    case text = 0, dm = 1, voice = 2, groupDM = 3, category = 4, news = 5, store = 6
}
