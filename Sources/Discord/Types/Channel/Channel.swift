import NIO
import Foundation

public struct Channel: DiscordGatewayType {
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
    public private(set) var recipients: [User]?
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
    
//    public var guild: Guild? {
//        guard let gId = guildId else { return nil }
//        return handler.state.guilds[gId]
//    }
//
//    public var parent: Channel? {
//        guard let pId = parentId else { return nil }
//        return handler.state.channels[pId]
//    }
}

extension Channel {
//    func get(message id: Snowflake) -> EventLoopFuture<Message> {
//        return self.handler.client.execute(Route.ChannelMessagesGet(self, id)).map { $0 as Message }
//    }
//
//    @discardableResult
//    func send(_ content: String, isTts: Bool = false, embed: Embed? = nil) -> EventLoopFuture<Message> {
//        let body = MessageCreatePayload(content: content, nonce: nil, isTts: isTts, embed: embed)
//
//        return self.handler.client.execute(.ChannelMessagesCreate(self), body).map { $0 as Message }
//    }
//
////    func getInvites(on client: DiscordRESTClient) -> EventLoopFuture<[ChannelInvite]> {
////
////    }
//
////    func createInvite
//    var pins: EventLoopFuture<[Message]> {
//        return self.handler.client.execute(.ChannelPinsGet(self)).map { $0 as [Message] }
//    }
//
//    func pin(message id: Snowflake) {
//        self.handler.client.execute(Route.ChannelsPinsAdd(self, id))
//    }
//
//    func unpin(message id: Snowflake) {
//        self.handler.client.execute(Route.ChannelsPinsDelete(self, id))
//    }
//
//    var webhooks: EventLoopFuture<[Webhook]> {
//        return self.handler.client.execute(.ChannelsWebhooksGet(self)).map { $0 as [Webhook] }
//    }
//
//    func createWebhook(_ payload: CreateWebhookPayload) throws -> EventLoopFuture<Webhook> {
//        return self.handler.client.execute(.WebhookCreate(self), payload).map { $0 as Webhook }
//    }
//
//    func send(_ message: MessageCreatePayload) throws -> EventLoopFuture<Message> {
//        return self.handler.client.execute(.ChannelMessagesCreate(self), message).map { $0 as Message }
//    }
//
//    func startTyping() {
//        self.handler.client.execute(.ChannelTyping(self))
//    }
//
//    func delete(messages ids: Snowflake...) throws {
//        guard !ids.isEmpty else { return }
//
//        if ids.count == 1, let id = ids.first {
//            self.handler.client.execute(.ChannelMessagesDelete(self, id))
//            return
//        }
//
//        let body = BulkDeleteMessagesPayload(messages: ids)
//
//        self.handler.client.execute(.ChannelMessagesDeleteBulk(self.id), body)
//    }
//
//    func delete() throws {
//        // TODO: Perm checks
//        guard self.isDm else { throw DiscordRestError.InvalidPermissions }
//        self.handler.client.execute(.ChannelDelete(self.id))
//    }
//
//    func close() throws {
//        guard self.isDm else { throw DiscordRestError.InvalidPermissions }
//        try self.delete()
//    }
//
//    func set(
//        _ name: String? = nil,
//        _ pos: Int? = nil,
//        _ topic: String? = nil,
//        _ nsfw: Bool? = nil,
//        _ rateLimit: Int? = nil,
//        _ bitrate: Int? = nil,
//        _ userLimit: Int?,
//        _ permOverwrites: [PermissionOverwrite]? = nil,
//        _ parent: Snowflake? = nil) throws -> EventLoopFuture<Channel> {
//        let body = ModifyChannelPayload(name: name, position: pos, topic: topic, isNsfw: nsfw, rateLimit: rateLimit, bitrate: bitrate, userLimit: userLimit, permissionOverwrites: permOverwrites, parentId: parent)
//        return self.handler.client.execute(.ChannelModify(self), body).map { $0 as Channel }
//    }
//
//    func createTextChannel(named name: String, topic: String = "", rateLimitPerUser: Int? = nil, position: Int? = nil, permissionOverwrites: [PermissionOverwrite]? = nil, isNsfw: Bool? = nil) throws -> EventLoopFuture<Channel> {
//        guard let guild = self.guild, self.type == .category else {
//            throw DiscordRestError.InvalidPermissions
//        }
//
//        throw DiscordError.CommandRedecleration
//    }
//
//    func createVoiceChannel(named name: String, topic: String = "", bitrate: Int? = nil, userLimit: Int? = nil, position: Int? = nil, overwrites: [PermissionOverwrite]? = nil) throws -> EventLoopFuture<Channel> {
//        guard let guild = self.guild, self.type == .category else {
//            throw DiscordRestError.InvalidPermissions
//        }
//
//        throw DiscordError.CommandRedecleration
//    }
}

public enum ChannelType: Int, Codable {
    case text = 0, dm = 1, voice = 2, groupDM = 3, category = 4, news = 5, store = 6
}
