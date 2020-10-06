import NIO


public typealias Message = Discord.Message
public extension Discord {
    final class Message: DiscordGatewayType, DiscordHandled {
        public internal(set) var client: DiscordClient! {
            didSet {
                self.author?.client = client
                self.member?.user = self.author
                self.member?.client = client
                self.member?.guildId = self.guildId
                for u in self.mentions {
                    u.client = client
                }
            }
        }
        
        public let id: Snowflake
        public let channelId: Snowflake
        public let guildId: Snowflake?
        public let author: User?
        public let member: GuildMember?
        public let content: String
        public let timestamp: String
        public let editedAt: String?
        public let isTts: Bool
        public let mentionsEveryone: Bool
        public let mentions: [User]
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
        
        public lazy var channel: Channel = {
            return self.client.state.channels[channelId]!.copyWith(self.client)
        }()
        
        func copyWith(_ client: DiscordClient) -> Message {
            let x = Message(id: id, channelId: channelId, guildId: guildId, author: author, member: member, content: content, timestamp: timestamp, editedAt: editedAt, isTts: isTts, mentionsEveryone: mentionsEveryone, mentions: mentions, mentionRoles: mentionRoles, mentionChannels: mentionChannels, attachments: attachments, embeds: embeds, reactions: reactions, nonce: nonce, isPinned: isPinned, webhookId: webhookId, type: type, activity: activity, application: application, reference: reference, flags: flags)
            x.client = client
            return x
        }
        
        internal init(id: Snowflake, channelId: Snowflake, guildId: Snowflake?, author: Discord.User?, member: GuildMember?, content: String, timestamp: String, editedAt: String?, isTts: Bool, mentionsEveryone: Bool, mentions: [Discord.User], mentionRoles: [Snowflake], mentionChannels: [ChannelMention]?, attachments: [Attachment], embeds: [Embed], reactions: [Reaction]?, nonce: Snowflake?, isPinned: Bool, webhookId: Snowflake?, type: MessageType, activity: MessageActivity?, application: MessageApplication?, reference: MessageReference?, flags: MessageFlags?) {
            self.id = id
            self.channelId = channelId
            self.guildId = guildId
            self.author = author
            self.member = member
            self.content = content
            self.timestamp = timestamp
            self.editedAt = editedAt
            self.isTts = isTts
            self.mentionsEveryone = mentionsEveryone
            self.mentions = mentions
            self.mentionRoles = mentionRoles
            self.mentionChannels = mentionChannels
            self.attachments = attachments
            self.embeds = embeds
            self.reactions = reactions
            self.nonce = nonce
            self.isPinned = isPinned
            self.webhookId = webhookId
            self.type = type
            self.activity = activity
            self.application = application
            self.reference = reference
            self.flags = flags
        }
    }
}

public extension Messageable {
    var discord: Discord.Message? {
        self as? Discord.Message
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
    
    private func toGlobal(_ msg: Discord.Message) -> Messageable {
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
           self.reply("Invalid permissions!")
        case CommandError.UnableToConvertArgument(let arg, let type):
           self.reply("Error converting \(f+arg+f) to \(f+type+f)\nUsage: \(help)")
        default:
           self.reply("Something went wrong!\nUsage: \(help)")
       }
    }
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

    public var guild: Guild? {
        return self.channel.guild
    }

    public func pin() -> EventLoopFuture<Void> {
        self.channel.pin(message: self.id)
    }

    public func unpin() -> EventLoopFuture<Void> {
        self.channel.unpin(message: self.id)
    }

    public func reply(_ content: String, isTts: Bool = false, embed: Embed? = nil) -> EventLoopFuture<Message> {
        return self.channel.send(content, isTts: isTts, embed: embed).map(setClient)
    }

    public func edit(_ content: String, embed: Embed? = nil) -> EventLoopFuture<Message> {
        let body = MessageEditPayload(content: content, embed: embed, flags: nil)

        return self.client.rest.execute(.ChannelMessagesModify(self.channelId, self, body)).map(setClient)
    }

    public func delete() -> EventLoopFuture<Void> {
        return self.client.rest.execute(.ChannelMessagesDelete(self.channelId, self)).toVoidFuture()
    }

    public func addReaction(_ reaction: Emoji) -> EventLoopFuture<Void> {
        return self.addReaction(reaction.urlValue)
    }
    
    public func addReaction(_ reaction: String) -> EventLoopFuture<Void> {
        #if !os(Linux)
        guard reaction.isSingleEmoji || reaction.contains(":") else {
            return self.client.eventLoop.makeFailedFuture(DiscordRestError.InvalidUnicodeEmoji)
        }
        #endif
        return self.client.rest.execute(.ChannelMessagesReactionsCreate(self.channelId, self, reaction)).map { _ in }
    }

    public func removeReaction(_ reaction: Emoji, user: User? = nil) -> EventLoopFuture<Void> {
        self.client.rest.execute(
            .ChannelMessagesReactionsDelete(self.channelId, self, reaction.urlValue, user != nil ? "\(user!.id)" : "@me")
        ).map { _ in }
    }

    public func mentions(_ entity: Snowflakable) -> Bool {
        return self.mentions.sContains(entity) || self.mentionRoles.sContains(entity)
    }
}

internal extension Message {
    func setClient(_ msg: Message) -> Message {
        msg.client = self.client
        return msg
    }
}

public enum MessageType: Int, Codable {
    case `default` = 0, recipientAdd = 1, recipientRemove = 2, call = 3, channelNameChange = 4, channelIconChange = 5, channelPinnedMessage = 6
    case guildMemberJoin = 7, userPremiumGuildSubscription = 8, subscriptionTierOne = 9, subscriptionTierTwo = 10, subscriptionTierThree = 11
    case channelFollowAdd = 12, guildDiscoveryDisqualified = 14, guildDiscoveryRequalified = 15
}

#if !os(Linux)
extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }
}
#endif
