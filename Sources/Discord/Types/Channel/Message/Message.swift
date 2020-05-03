import NIO

public struct Message: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient! {
        didSet {
            self.author?.client = client
            self.member?.client = client
            var newMentions = [User]()
            for var u in self.mentions {
                u.client = client
                newMentions.append(u)
            }
            self.mentions = newMentions
        }
    }
    
    public let id: Snowflake
    public let channelId: Snowflake
    public let guildId: Snowflake?
    public private(set) var author: User?
    public internal(set) var member: GuildMember?
    public let content: String
    public let timestamp: String
    public let editedAt: String?
    public let isTts: Bool
    public let mentionsEveryone: Bool
    public private(set) var mentions: [User]
    public let mentionRoles: [Snowflake]
    public let mentionChannels: [ChannelMention]?
    public let attachments: [Attachment]
    public let embeds: [Embed]
    public let reactions: [Reaction]?
    public let nonce: Snowflake?
    public let isPinned: Bool
    public let webhookId: Snowflake?
    public let type: MessageType
    public let activity: MessageActivity?
    public let application: MessageApplication?
    public let reference: MessageReference?
    public let flags: MessageFlags?
    
    enum CodingKeys: String, CodingKey {
        case id, author, content, member, timestamp, mentions, attachments, embeds, reactions, nonce, type, activity, application
        case reference, flags
        case channelId = "channel_id"
        case guildId = "guild_id"
        case editedAt = "edited_timestamp"
        case isTts = "tts"
        case mentionsEveryone = "mention_everyone"
        case mentionRoles = "mention_roles"
        case mentionChannels = "mention_channels"
        case isPinned = "pinned"
        case webhookId = "webhook_id"
    }
}

public extension Messageable {
    var discord: Message? {
        self as? Message
    }
}

extension Message: Messageable {
    public var gChannel: Channelable {
        self.channel
    }
    
    private struct Webhook: Userable {
        var identifier: String? {
            "webhook"
        }
        
        var mention: String {
            "Unmentionable webhook"
        }
    }
    
    private func toGlobal(_ msg: Self) -> Messageable {
        return msg as Messageable
    }
    
    @discardableResult
    public func reply(_ content: String) -> EventLoopFuture<Messageable> {
        self.reply(content).map(toGlobal)
    }
    
    @discardableResult
    public func edit(_ content: String) -> EventLoopFuture<Messageable> {
        self.edit(content).map(toGlobal)
    }
    
    public var gAuthor: Userable {
        return self.author ?? Webhook()
    }
    
    public func error(_ error: Error, on command: _ExecutableCommand) {
        let f = self.client.options.highlightFormatting
        let help = f + command.help + f
        switch error {
        case CommandError.ArgumentNotFound(let arg):
            self.reply("Missing argument: \(f+arg+f)\nUsage: \(help)")
        case CommandError.InvalidPermissions:
           self.reply("Invalid permissions!\nUsage: \(help)")
        case CommandError.UnableToConvertArgument(let arg, let type):
           self.reply("Error converting \(f+arg+f) to \(f+type+f)\nUsage: \(help)")
        default:
           self.reply("Something went wrong!\nUsage: \(help)")
       }
    }

    public func delete() { }
}

extension Message: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return self.id
    }
}

extension Message {
    public var isNotMeOrBot: Bool {
        guard let author = self.author else { return false }
        return !(author.id == client.state.me.id) && !(author.isBot ?? false)
    }

    public var channel: Channel {
        return self.client.state.channels[channelId]!
    }

    public var guild: Guild? {
        return self.channel.guild
    }

    public func pin() {
        self.channel.pin(message: self.id)
    }

    public func unpin() {
        self.channel.unpin(message: self.id)
    }

    @discardableResult
    public func reply(_ content: String, isTts: Bool = false, embed: Embed? = nil) -> EventLoopFuture<Message> {
        return self.channel.send(content, isTts: isTts, embed: embed).map { (msg: Message) in
            var m = msg
            m.client = self.client
            return m
        }
    }

    public func edit(_ content: String, embed: Embed? = nil) -> EventLoopFuture<Message> {
        let body = MessageEditPayload(content: content, embed: embed)

        return self.client.client.execute(.ChannelMessagesModify(self.channelId, self), body).map { (msg: Message) in
            var m = msg
            m.client = self.client
            return m
        }
    }

    public func delete() -> EventLoopFuture<Message> {
        return self.client.client.execute(.ChannelMessagesDelete(self.channelId, self)).map { $0 as Message }
    }

    func add(reaction: Emoji) {
        self.client.client.execute(.ChannelMessagesReactionsCreate(self.channelId, self, reaction.description))
    }

    func remove(reaction: Emoji, user: User? = nil) {
        let user = user != nil ? "\(user!.id)" : "@me"

        self.client.client.execute(.ChannelMessagesReactionsDelete(self.channelId, self, reaction.description, user))
    }

    func mentions(_ entity: Snowflakable) -> Bool {
        return self.mentions.sContains(entity) || self.mentionRoles.sContains(entity)
    }
}

public enum MessageType: Int, Codable {
    case text = 0, recipientAdd = 1, recipientRemove = 2, call = 3, channelNameChange = 4, channelIconChange = 5, channelPinnedMessage = 6, guildMemberJoin = 7, userPremiumGuildSubscription = 8, subscriptionTierOne, subscriptionTierTwo, subscriptionTierThree, channelFollowAdd
}
