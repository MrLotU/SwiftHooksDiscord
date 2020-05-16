import Foundation

public protocol QueryItemConvertible {
    func toQueryItems() -> [URLQueryItem]
}

public typealias BasicRoute<R: Decodable> = Route<Empty, Empty, R>
public typealias QueryRoute<Q: QueryItemConvertible, R: Decodable> = Route<Empty, Q, R>
public typealias BodyRoute<B: Encodable, R: Decodable> = Route<B, Empty, R>
public typealias EmptyRoute = Route<Empty, Empty, Empty>

/// Holds all info required to execute a route on the Discord REST API
public struct Route<B: Encodable, Q: QueryItemConvertible, R: Decodable> {
    /// Method of the route
    let method: HTTPMethod
    /// Endpoint of the route
    let endpoint: String
    
    /// Discord API base URL
    private let baseURL = "https://discord.com/api/v7"
    
    let body: B
    
    let query: Q
    
    /// URL to route to
    var url: URL {
        var comps = URLComponents(string: baseURL + (endpoint.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? endpoint))
        comps?.queryItems = query.toQueryItems().isEmpty ? nil : query.toQueryItems()
        return comps!.url!
    }
    
    /// Creates a new Route
    init(_ method: HTTPMethod, _ endpoint: String, _ b: B, _ q: Q) {
        self.method = method
        self.endpoint = endpoint
        self.body = b
        self.query = q
    }
}

extension Route where Q == Empty {
    init(_ method: HTTPMethod, _ endpoint: String, _ b: B) {
        self.method = method
        self.endpoint = endpoint
        self.body = b
        self.query = Empty()
    }
}

extension Route where B == Empty {
    init(_ method: HTTPMethod, _ endpoint: String, _ q: Q) {
        self.method = method
        self.endpoint = endpoint
        self.body = Empty()
        self.query = q
    }
}

extension Route where B == Empty, Q == Empty {
    init(_ method: HTTPMethod, _ endpoint: String) {
        self.method = method
        self.endpoint = endpoint
        self.body = Empty()
        self.query = Empty()
    }
}


// MARK: - Defaults

extension Route {
    // MARK: Gateway
    
    public static var GatewayGet: BasicRoute<GatewayResponse> {
        return .init(.GET, "/gateway")
    }
    
    public static var GatewayBotGet: BasicRoute<GatewayBotResponse> {
        return .init(.GET, "/gateway/bot")
    }
}

extension Route {
    // MARK: Chanels
    
    private static var ChannelBase: String {
        return "/channels"
    }
    
    private static func ChannelBase(_ id: Snowflakable) -> String {
        return ChannelBase + "/" + id.asString
    }
    
    public static func ChannelGet(_ id: Snowflakable) -> BasicRoute<Channel> {
        return .init(.GET, ChannelBase(id))
    }
    
    public static func ChannelModify(_ id: Snowflakable, _ body: ModifyChannelPayload) -> BodyRoute<ModifyChannelPayload, Channel> {
        return .init(.PATCH, ChannelBase(id), body)
    }
    
    public static func ChannelDelete(_ id: Snowflakable) -> BasicRoute<Channel> {
        return .init(.DELETE, ChannelBase(id))
    }
    
    public static func ChannelTyping(_ id: Snowflakable) -> EmptyRoute {
        return .init(.POST, ChannelBase(id) + "/typing")
    }
    
    private static func MessageBase(_ id: Snowflakable) -> String {
         return ChannelBase(id) + "/messages"
    }
    
    private static func MessageBase(_ chanId: Snowflakable, _ msgId: Snowflakable) -> String {
        return MessageBase(chanId) + "/" + msgId.asString
    }
    
    public static func ChannelMessagesList(_ id: Snowflakable, _ q: Todo) -> QueryRoute<Todo, [Message]> {
        return .init(.GET, MessageBase(id), q)
    }
    
    public static func ChannelMessagesGet(_ chanId: Snowflakable, _ msgId: Snowflakable) -> BasicRoute<Message> {
        return .init(.GET, MessageBase(chanId, msgId))
    }
    
    public static func ChannelMessagesCreate(_ chanId: Snowflakable, _ b: MessageCreatePayload) -> BodyRoute<MessageCreatePayload, Message> {
        return .init(.POST, MessageBase(chanId), b)
    }
    
    public static func ChannelMessagesModify(_ chanId: Snowflakable, _ msgId: Snowflakable, _ b: MessageEditPayload) -> BodyRoute<MessageEditPayload, Message> {
        return .init(.PATCH, MessageBase(chanId, msgId), b)
    }
    
    public static func ChannelMessagesDelete(_ chanId: Snowflakable, _ msgId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, MessageBase(chanId, msgId))
    }
    
    public static func ChannelMessagesDeleteBulk(_ chanId: Snowflakable, _ b: BulkDeleteMessagesPayload) -> BodyRoute<BulkDeleteMessagesPayload, Empty> {
        return .init(.POST, MessageBase(chanId) + "/bulk-delete", b)
    }
    
    private static func MessageReactionsBase(_ chanId: Snowflakable, _ msgId: Snowflakable, _ emoji: String) -> String {
        return MessageBase(chanId, msgId) + "/reactions/\(emoji)"
    }
    
    public static func ChannelMessagesReactionsGet(_ chanId: Snowflakable, _ msgId: Snowflakable, _ emoji: String, _ q: Todo) -> QueryRoute<Todo, [User]> {
        return .init(.GET, MessageReactionsBase(chanId, msgId, emoji), q)
    }
    
    public static func ChannelMessagesReactionsCreate(_ chanId: Snowflakable, _ msgId: Snowflakable, _ emoji: String) -> EmptyRoute {
        return .init(.PUT, MessageReactionsBase(chanId, msgId, emoji) + "/@me")
    }
    
    public static func ChannelMessagesReactionsDelete(_ chanId: Snowflakable, _ msgId: Snowflakable, _ emoji: String, _ userId: String = "@me") -> EmptyRoute {
        return .init(.DELETE, MessageReactionsBase(chanId, msgId, emoji) + "/\(userId)")
    }
    
    public static func ChannelMessagesReactionsDelete(_ chanId: Snowflakable, _ msgId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, MessageBase(chanId, msgId) + "/reactions")
    }
    
    private static func ChannelPermissionsBase(_ chanId: Snowflakable, _ permId: String) -> String {
        return ChannelBase(chanId) + "/permissions/\(permId)"
    }
    
    public static func ChannelPermissionsEdit(_ chanId: Snowflakable, _ permId: String, _ b: EditChannelPermissionsPayload) -> BodyRoute<EditChannelPermissionsPayload, Empty> {
        return .init(.PUT, ChannelPermissionsBase(chanId, permId), b)
    }
    
    public static func ChannelPermissionsDelete(_ chanId: Snowflakable, _ permId: String) -> EmptyRoute {
        return .init(.DELETE, ChannelPermissionsBase(chanId, permId))
    }
    
    private static func ChannelInvitesBase(_ chanId: Snowflakable) -> String {
        return ChannelBase(chanId) + "/invites"
    }
    
    public static func ChannelInvitesGet(_ chanId: Snowflakable) -> BasicRoute<[Invite]> {
        return .init(.GET, ChannelInvitesBase(chanId))
    }
    
    public static func ChannelInvitesCreate(_ chanId: Snowflakable, _ b: CreateInvitePayload) -> BodyRoute<CreateInvitePayload, Invite> {
        return .init(.POST, ChannelInvitesBase(chanId), b)
    }
    
    private static func ChannelPinsBase(_ chanId: Snowflakable) -> String {
        return ChannelBase(chanId) + "/pins"
    }
    
    public static func ChannelPinsGet(_ chanId: Snowflakable) -> BasicRoute<[Message]> {
        return .init(.GET, ChannelPinsBase(chanId))
    }
    
    public static func ChannelsPinsAdd(_ chanId: Snowflakable, _ msgId: Snowflakable) -> EmptyRoute {
        return .init(.PUT, ChannelPinsBase(chanId) + "/\(msgId)")
    }
    
    public static func ChannelsPinsDelete(_ chanId: Snowflakable, _ msgId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, ChannelPinsBase(chanId) + "/\(msgId)")
    }
    
    private static func ChannelsGroupDMBase(_ chanId: Snowflakable) -> String {
        return ChannelBase(chanId) + "/recipients"
    }
    
    public static func ChannelGroupDMRecipientsAdd(_ chanId: Snowflakable, _ userId: Snowflakable, _ b: GroupDMRecipientAddPayload) -> BodyRoute<GroupDMRecipientAddPayload, Empty> {
        return .init(.PUT, ChannelsGroupDMBase(chanId) + "/\(userId)", b)
    }
    
    public static func ChannelGroupDMRecipientsDelete(_ chanId: Snowflakable, _ userId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, ChannelsGroupDMBase(chanId) + "/\(userId)")
    }
}

extension Route {
    // MARK: Voice
    
    public static var VoicRegionsGet: BasicRoute<[VoiceRegion]> {
        return .init(.GET, "/voice/regions")
    }
}

extension Route {
    // MARK: Invite
    
    private static func InvitesBase(_ inviteCode: String) -> String {
        return "/invites/\(inviteCode)"
    }
    
    public static func InvitesGet(_ inviteCode: String) -> BasicRoute<Invite> {
        return .init(.GET, InvitesBase(inviteCode))
    }
    
    public static func InvitesDelete(_ inviteCode: String) -> BasicRoute<Invite> {
        return .init(.DELETE, InvitesBase(inviteCode))
    }
}

extension Route {
    // MARK: Users
    
    private static var UserBase: String {
        return "/users"
    }
    
    private static var UserBaseMe: String {
        return "/users/@me"
    }
    
    public static var UserGetMe: BasicRoute<User> {
        return .init(.GET, UserBaseMe)
    }
    
    public static func UserGet(_ userId: Snowflakable) -> BasicRoute<User> {
        return .init(.GET, UserBase + "/" + userId.asString)
    }
    
    public static func ModifyUserMe(_ b: ModifyUserPayload) -> BodyRoute<ModifyUserPayload, User> {
        return .init(.PATCH, UserBaseMe, b)
    }
    
    private static var UserGuildsBase: String {
        return UserBaseMe + "/guilds"
    }
    
    public static func UserGuildsMe(_ q: Todo) -> QueryRoute<Todo, [Guild]> {
        return .init(.GET, UserGuildsBase, q)
    }
    
    public static func UserGuildLeave(_ guildId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, UserGuildsBase + "/" + guildId.asString)
    }
    
    private static var UserDMsBase: String {
        return UserBaseMe + "/channels"
    }
    
    public static var UserDMsGet: BasicRoute<[Channel]> {
        return .init(.GET, UserDMsBase)
    }
    
    public static func UserDMsCreate(_ b: CreateDMPayload) -> BodyRoute<CreateDMPayload, Channel> {
        return .init(.POST, UserDMsBase, b)
    }
    
    public static var UserConnectionsGet: BasicRoute<[UserConnection]> {
        return .init(.GET, UserBaseMe + "/connections")
    }
}

extension Route {
    // MARK: Webhooks
    
    private static var WebhookBase: String {
        return "/webhooks"
    }
    
    private static func WebhookBase(_ webhookID: Snowflakable) -> String {
        return WebhookBase + "/" + webhookID.asString
    }
    
    private static func WebhookBase(_ webhookId: Snowflakable, _ webhookToken: String) -> String {
        return WebhookBase(webhookId) + "/\(webhookToken)"
    }
    
//    public static func WebhookCreate(_ chanId: Snowflakable) -> Route {
//        return .init(.POST, ChannelBase(chanId) + WebhookBase)
//    }
//
//    public static func ChannelsWebhooksGet(_ chanId: Snowflakable) -> Route {
//        return .init(.GET, ChannelBase(chanId) + WebhookBase)
//    }
//
//    public static func GuildsWebhooksGet(_ guildId: Snowflakable) -> Route {
//        return .init(.GET, GuildBase(guildId) + WebhookBase)
//    }
//
//    public static func WebhooksGet(_ webhookId: Snowflakable) -> Route {
//        return .init(.GET, WebhookBase(webhookId))
//    }
//
//    public static func WebhooksGet(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
//        return .init(.GET, WebhookBase(webhookId, webhookToken))
//    }
//
//    public static func WebhooksModify(_ webhookId: Snowflakable) -> Route {
//        return .init(.PATCH, WebhookBase(webhookId))
//    }
//
//    public static func WebhooksModify(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
//        return .init(.PATCH, WebhookBase(webhookId, webhookToken))
//    }
//
//    public static func WebhooksDelete(_ webhookId: Snowflakable) -> Route {
//        return .init(.DELETE, WebhookBase(webhookId))
//    }
//
//    public static func WebhooksDelete(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
//        return .init(.DELETE, WebhookBase(webhookId, webhookToken))
//    }
//
//    public static func WebhooksExecute(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
//        return .init(.POST, WebhookBase(webhookId, webhookToken))
//    }
//
//    public static func WebhooksExecuteSlack(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
//        return .init(.POST, WebhookBase(webhookId, webhookToken) + "/slack")
//    }
//
//    public static func WebhooksExecuteGitHub(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
//        return .init(.POST, WebhookBase(webhookId, webhookToken) + "/github")
//    }
}

extension Route {
    // MARK: Guilds
    
    private static var GuildBase: String {
        return "/guilds"
    }
    
    private static func GuildBase(_ guildId: Snowflakable) -> String {
        return GuildBase + "/" + guildId.asString
    }
    
//    public static var GuildCreate: Route {
//        return .init(.POST, GuildBase)
//    }
    
    public static func GuildGet(_ guildId: Snowflakable, _ q: Todo) -> QueryRoute<Todo, Guild> {
        return .init(.GET, GuildBase(guildId), q)
    }
    
    public static func GuildPreviewGet(_ guildId: Snowflakable) -> BasicRoute<GuildPreview> {
        return .init(.GET, GuildBase(guildId))
    }
    
    public static func GuildModify(_ guildId: Snowflakable, _ b: ModifyGuildPayload) -> BodyRoute<ModifyGuildPayload, Guild> {
        return .init(.PATCH, GuildBase(guildId), b)
    }
    
    public static func GuildDelete(_ guildId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, GuildBase(guildId))
    }
    
    public static func GuildChannelsGet(_ guildId: Snowflakable) -> BasicRoute<[Channel]> {
        return .init(.GET, GuildBase(guildId) + ChannelBase)
    }
    
    public static func GuildChannelsCreate(_ guildId: Snowflakable, _ b: CreatChannelPayload) -> BodyRoute<CreatChannelPayload, Channel> {
        return .init(.POST, GuildBase(guildId) + ChannelBase, b)
    }
    
    public static func GuildChannelsModifyPosition(_ guildId: Snowflakable, _ b: ModifyChannelPositionPayload) -> BodyRoute<ModifyChannelPositionPayload, Empty> {
        return .init(.PATCH, GuildBase(guildId) + ChannelBase, b)
    }
    
    private static func GuildMembersBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/members"
    }
    
    private static func GuildMembersBase(_ guildId: Snowflakable, _ userId: Snowflakable) -> String {
        return GuildMembersBase(guildId) + "/" + userId.asString
    }
    
    public static func GuildMembersGet(_ guildId: Snowflakable, _ userId: Snowflakable) -> BasicRoute<GuildMember> {
        return .init(.GET, GuildMembersBase(guildId, userId))
    }
    
    public static func GuildMembersList(_ guildId: Snowflakable) -> BasicRoute<[GuildMember]> {
        return .init(.GET, GuildMembersBase(guildId))
    }
    
    public static func GuildMembersAdd(_ guildId: Snowflakable, _ userId: Snowflakable, _ b: AddGuildMemberPayload) -> BodyRoute<AddGuildMemberPayload, GuildMember?> {
        return .init(.PUT, GuildMembersBase(guildId, userId), b)
    }
    
    public static func GuildMembersModify(_ guildId: Snowflakable, _ userId: Snowflakable, _ b: ModifyGuildMemberPayload) -> BodyRoute<ModifyGuildMemberPayload, Empty> {
        return .init(.PATCH, GuildMembersBase(guildId, userId), b)
    }
    
    public static func GuildMembersRemove(_ guildId: Snowflakable, _ userId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, GuildMembersBase(guildId, userId))
    }
    
    public static func GuildMembersModifyNickMe(_ guildId: Snowflakable, _ b: ModifyNickMePayload) -> BodyRoute<ModifyNickMePayload, Empty> {
        return .init(.PATCH, GuildMembersBase(guildId) + "/@me/nick", b)
    }
    
    private static func GuildMembersRolesBase(_ guildId: Snowflakable, _ userId: Snowflakable, _ roleId: Snowflakable) -> String {
        return GuildMembersBase(guildId, userId) + "/roles/" + roleId.asString
    }
    
    public static func GuildMembersRoleAdd(_ guildId: Snowflakable, _ userId: Snowflakable, _ roleId: Snowflakable) -> EmptyRoute {
        return .init(.PUT, GuildMembersRolesBase(guildId, userId, roleId))
    }
    
    public static func GuildMembersRoleRemove(_ guildId: Snowflakable, _ userId: Snowflakable, _ roleId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, GuildMembersRolesBase(guildId, userId, roleId))
    }
    
    private static func GuildBansBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/bans"
    }
    
    private static func GuildBansBase(_ guildId: Snowflakable, _ userId: Snowflakable) -> String {
        return GuildBansBase(guildId) + "/\(userId)"
    }
    
    public static func GuildBansList(_ guildId: Snowflakable) -> BasicRoute<[GuildBan]> {
        return .init(.GET, GuildBansBase(guildId))
    }
    
    public static func GuildBansGet(_ guildId: Snowflakable, _ userId: Snowflakable) -> BasicRoute<GuildBan> {
        return .init(.GET, GuildBansBase(guildId, userId))
    }
    
    public static func GuildBansCreate(_ guildId: Snowflakable, _ userId: Snowflakable, _ q: Todo) -> QueryRoute<Todo, Empty> {
        return .init(.PUT, GuildBansBase(guildId, userId), q)
    }
    
    public static func GuildBansRemove(_ guildId: Snowflakable, _ userId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, GuildBansBase(guildId, userId))
    }
    
    private static func GuildRolesBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/roles"
    }
    
    private static func GuildRolesBase(_ guildId: Snowflakable, _ roleId: Snowflakable) -> String {
        return GuildRolesBase(guildId) + "/" + roleId.asString
    }
    
    public static func GuildRolesGet(_ guildId: Snowflakable) -> BasicRoute<[GuildRole]> {
        return .init(.GET, GuildRolesBase(guildId))
    }
    
    public static func GuildRolesCreate(_ guildId: Snowflakable, _ b: GuildRoleCreatePayload) -> BodyRoute<GuildRoleCreatePayload, GuildRole> {
        return .init(.POST, GuildRolesBase(guildId), b)
    }
    
    public static func GuildRolesPositionModify(_ guildId: Snowflakable, _ b: ModifyRolePositionPayload) -> BodyRoute<ModifyRolePositionPayload, [GuildRole]> {
        return .init(.PATCH, GuildRolesBase(guildId), b)
    }
    
    public static func GuildRolesModify(_ guildId: Snowflakable, _ roleId: Snowflakable, _ b: ModifyRolePayload) -> BodyRoute<ModifyRolePayload, GuildRole> {
        return .init(.PATCH, GuildRolesBase(guildId, roleId), b)
    }
    
    public static func GuildRolesDelete(_ guildId: Snowflakable, _ roleId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, GuildRolesBase(guildId, roleId))
    }
    
    private static func GuildPruneBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/prune"
    }
    
    public static func GuildPruneCount(_ guildId: Snowflakable, _ q: Todo) -> QueryRoute<Todo, GuildPruneResult> {
        return .init(.GET, GuildPruneBase(guildId), q)
    }
    
    public static func GuildPruneStart(_ guildId: Snowflakable, _ q: Todo) -> QueryRoute<Todo, GuildPruneResult> {
        return .init(.POST, GuildPruneBase(guildId), q)
    }
    
    public static func GuildVoiceRegionsGet(_ guildId: Snowflakable) -> BasicRoute<[VoiceRegion]> {
        return .init(.GET, GuildBase(guildId) + "/regions")
    }
    
    public static func GuildInvitesGet(_ guildId: Snowflakable) -> BasicRoute<Invite> {
        return .init(.GET, GuildBase(guildId) + "/invites")
    }
    
    private static func GuildIntegrationsBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/integrations"
    }
    
    private static func GuildIntegrationsBase(_ guildId: Snowflakable, _ integrationId: Snowflakable) -> String {
        return GuildIntegrationsBase(guildId) + "/" + integrationId.asString
    }
    
    public static func GuildIntegrationsGet(_ guildId: Snowflakable) -> BasicRoute<[GuildIntegration]> {
        return .init(.GET, GuildIntegrationsBase(guildId))
    }
    
    public static func GuildIntegrationsCreate(_ guildId: Snowflakable, _ b: GuildIntegrationCreatePayload) -> BodyRoute<GuildIntegrationCreatePayload, Empty> {
        return .init(.POST, GuildIntegrationsBase(guildId), b)
    }
    
    public static func GuildIntegrationsModify(_ guildId: Snowflakable, _ integrationId: Snowflakable, _ b: ModifyGuildIntegrationPayload) -> BodyRoute<ModifyGuildIntegrationPayload, Empty> {
        return .init(.PATCH, GuildIntegrationsBase(guildId, integrationId), b)
    }
    
    public static func GuildIntegrationsDelete(_ guildId: Snowflakable, _ integrationId: Snowflakable) -> EmptyRoute {
        return .init(.DELETE, GuildIntegrationsBase(guildId, integrationId))
    }
    
    public static func GuildIntegrationsSync(_ guildId: Snowflakable, _ integrationId: Snowflakable) -> EmptyRoute {
        return .init(.POST, GuildIntegrationsBase(guildId, integrationId) + "/sync")
    }
    
    private static func GuildWidgetBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/widget"
    }
    
    public static func GuildWidgetGet(_ guildId: Snowflakable) -> BasicRoute<GuildWidget> {
        return .init(.GET, GuildWidgetBase(guildId))
    }
        
    public static func GuildWidgetModify(_ guildId: Snowflakable, _ b: GuildWidget) -> BodyRoute<GuildWidget, GuildWidget> {
        return .init(.PATCH, GuildWidgetBase(guildId), b)
    }
    
    public static func GuildVanityUrlGet(_ guildId: Snowflakable) -> BasicRoute<Invite> {
        return .init(.GET, GuildBase(guildId) + "/vanity-url")
    }
    
//    public static func GuildAuditLogGet(_ guildId: Snowflakable) -> QueryRoute<Todo, AuditLog> {
//        return .init(.GET, GuildBase(guildId) + "/audit-logs")
//    }
    
    private static func GuildEmojisBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/emojis"
    }
    
    private static func GuildEmojisbase(_ guildId: Snowflakable, _ emojiId: String) -> String {
        return GuildEmojisBase(guildId) + "/\(emojiId)"
    }
    
    public static func GuildEmojisGet(_ guildId: Snowflakable) -> BasicRoute<[Emoji]> {
        return .init(.GET, GuildEmojisBase(guildId))
    }
    
    public static func GuildEmojisCreate(_ guildId: Snowflakable, _ b: CreateEmojiPayload) -> BodyRoute<CreateEmojiPayload, Emoji> {
        return .init(.POST, GuildEmojisBase(guildId), b)
    }
    
    public static func GuildEmojisGet(_ guildId: Snowflakable, emojiId: String) -> BasicRoute<Emoji> {
        return .init(.GET, GuildEmojisbase(guildId, emojiId))
    }
    
    public static func GuildEmojisModify(_ guildId: Snowflakable, emojiId: String, _ b: ModifyEmojiPayload) -> BodyRoute<ModifyEmojiPayload, Emoji> {
        return .init(.PATCH, GuildEmojisbase(guildId, emojiId), b)
    }
    
    public static func GuildEmojisDelete(_ guildId: Snowflakable, emojiId: String) -> EmptyRoute {
        return .init(.DELETE, GuildEmojisbase(guildId, emojiId))
    }
}
