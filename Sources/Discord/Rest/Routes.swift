import Foundation

enum HTTPMethod {
    case GET, POST, PUT, PATCH, DELETE
}

/// Holds all info required to execute a route on the Discord REST API
public struct Route {
    /// Method of the route
    let method: HTTPMethod
    /// Endpoint of the route
    let endpoint: String
    
    /// Discord API base URL
    private let baseURL = "https://discordapp.com/api/v7"
    
    /// URL to route to
    public var url: URL {
        return URL(string: baseURL + endpoint)!
    }
    
    /// Creates a new Route
    init(_ method: HTTPMethod, _ endpoint: String) {
        self.method = method
        self.endpoint = endpoint
    }
    
    // TODO: Query params, return and body types
}

// MARK: - Defaults

extension Route {
    // MARK: Gateway
    
    public static var GatewayGet: Route {
        return .init(.GET, "/gateway")
    }
    
    public static var GatewayBotGet: Route {
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
    
    public static func ChannelGet(_ id: Snowflakable) -> Route {
        return .init(.GET, ChannelBase(id))
    }
    
    public static func ChannelModify(_ id: Snowflakable) -> Route {
        return .init(.PATCH, ChannelBase(id))
    }
    
    public static func ChannelDelete(_ id: Snowflakable) -> Route {
        return .init(.DELETE, ChannelBase(id))
    }
    
    public static func ChannelTyping(_ id: Snowflakable) -> Route {
        return .init(.POST, ChannelBase(id) + "/typing")
    }
    
    private static func MessageBase(_ id: Snowflakable) -> String {
         return ChannelBase(id) + "/messages"
    }
    
    private static func MessageBase(_ chanId: Snowflakable, _ msgId: Snowflakable) -> String {
        return MessageBase(chanId) + "/" + msgId.asString
    }
    
    public static func ChannelMessagesList(_ id: Snowflakable) -> Route {
        return .init(.GET, MessageBase(id))
    }
    
    public static func ChannelMessagesGet(_ chanId: Snowflakable, _ msgId: Snowflakable) -> Route {
        return .init(.GET, MessageBase(chanId, msgId))
    }
    
    public static func ChannelMessagesCreate(_ chanId: Snowflakable) -> Route {
        return .init(.POST, MessageBase(chanId))
    }
    
    public static func ChannelMessagesModify(_ chanId: Snowflakable, _ msgId: Snowflakable) -> Route {
        return .init(.PATCH, MessageBase(chanId, msgId))
    }
    
    public static func ChannelMessagesDelete(_ chanId: Snowflakable, _ msgId: Snowflakable) -> Route {
        return .init(.DELETE, MessageBase(chanId, msgId))
    }
    
    public static func ChannelMessagesDeleteBulk(_ chanId: Snowflakable) -> Route {
        return .init(.POST, MessageBase(chanId) + "/bulk-delete")
    }
    
    private static func MessageReactionsBase(_ chanId: Snowflakable, _ msgId: Snowflakable, _ emoji: String) -> String {
        return MessageBase(chanId, msgId) + "/reactions/\(emoji)"
    }
    
    public static func ChannelMessagesReactionsGet(_ chanId: Snowflakable, _ msgId: Snowflakable, _ emoji: String) -> Route {
        return .init(.GET, MessageReactionsBase(chanId, msgId, emoji))
    }
    
    public static func ChannelMessagesReactionsCreate(_ chanId: Snowflakable, _ msgId: Snowflakable, _ emoji: String) -> Route {
        return .init(.PUT, MessageReactionsBase(chanId, msgId, emoji) + "/@me")
    }
    
    public static func ChannelMessagesReactionsDelete(_ chanId: Snowflakable, _ msgId: Snowflakable, _ emoji: String, _ userId: String = "@me") -> Route {
        return .init(.DELETE, MessageReactionsBase(chanId, msgId, emoji) + "/\(userId)")
    }
    
    public static func ChannelMessagesReactionsDelete(_ chanId: Snowflakable, _ msgId: Snowflakable) -> Route {
        return .init(.DELETE, MessageBase(chanId, msgId) + "/reactions")
    }
    
    private static func ChannelPermissionsBase(_ chanId: Snowflakable, _ permId: String) -> String {
        return ChannelBase(chanId) + "/permissions/\(permId)"
    }
    
    public static func ChannelPermissionsEdit(_ chanId: Snowflakable, _ permId: String) -> Route {
        return .init(.PUT, ChannelPermissionsBase(chanId, permId))
    }
    
    public static func ChannelPermissionsDelete(_ chanId: Snowflakable, _ permId: String) -> Route {
        return .init(.DELETE, ChannelPermissionsBase(chanId, permId))
    }
    
    private static func ChannelInvitesBase(_ chanId: Snowflakable) -> String {
        return ChannelBase(chanId) + "/invites"
    }
    
    public static func ChannelInvitesGet(_ chanId: Snowflakable) -> Route {
        return .init(.GET, ChannelInvitesBase(chanId))
    }
    
    public static func ChannelInvitesCreate(_ chanId: Snowflakable) -> Route {
        return .init(.POST, ChannelInvitesBase(chanId))
    }
    
    private static func ChannelPinsBase(_ chanId: Snowflakable) -> String {
        return ChannelBase(chanId) + "/pins"
    }
    
    public static func ChannelPinsGet(_ chanId: Snowflakable) -> Route {
        return .init(.GET, ChannelPinsBase(chanId))
    }
    
    public static func ChannelsPinsAdd(_ chanId: Snowflakable, _ msgId: Snowflakable) -> Route {
        return .init(.PUT, ChannelPinsBase(chanId) + "/\(msgId)")
    }
    
    public static func ChannelsPinsDelete(_ chanId: Snowflakable, _ msgId: Snowflakable) -> Route {
        return .init(.DELETE, ChannelPinsBase(chanId) + "/\(msgId)")
    }
    
    private static func ChannelsGroupDMBase(_ chanId: Snowflakable) -> String {
        return ChannelBase(chanId) + "/recipients"
    }
    
    public static func ChannelGroupDMRecipientsAdd(_ chanId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.PUT, ChannelsGroupDMBase(chanId) + "/\(userId)")
    }
    
    public static func ChannelGroupDMRecipientsDelete(_ chanId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.DELETE, ChannelsGroupDMBase(chanId) + "/\(userId)")
    }
}

extension Route {
    // MARK: Voice
    
    public static var VoicRegionsGet: Route {
        return .init(.GET, "/voice/regions")
    }
}

extension Route {
    // MARK: Invite
    
    private static func InvitesBase(_ inviteCode: String) -> String {
        return "/invites/\(inviteCode)"
    }
    
    public static func InvitesGet(_ inviteCode: String) -> Route {
        return .init(.GET, InvitesBase(inviteCode))
    }
    
    public static func InvitesDelete(_ inviteCode: String) -> Route {
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
    
    public static var UserGetMe: Route {
        return .init(.GET, UserBaseMe)
    }
    
    public static func UserGet(_ userId: Snowflakable) -> Route{
        return .init(.GET, UserBase + "/" + userId.asString)
    }
    
    public static var ModifyUserMe: Route {
        return .init(.PATCH, UserBaseMe)
    }
    
    private static var UserGuildsBase: String {
        return UserBaseMe + "/guilds"
    }
    
    public static var UserGuildsMe: Route {
        return .init(.GET, UserGuildsBase)
    }
    
    public static func UserGuildLeave(_ guildId: Snowflakable) -> Route {
        return .init(.DELETE, UserGuildsBase + "/" + guildId.asString)
    }
    
    private static var UserDMsBase: String {
        return UserBaseMe + "/channels"
    }
    
    public static var UserDMsGet: Route {
        return .init(.GET, UserDMsBase)
    }
    
    public static var UserDMsCreate: Route {
        return .init(.POST, UserDMsBase)
    }
    
    public static var UserConnectionsGet: Route {
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
    
    public static func WebhookCreate(_ chanId: Snowflakable) -> Route {
        return .init(.POST, ChannelBase(chanId) + WebhookBase)
    }
    
    public static func ChannelsWebhooksGet(_ chanId: Snowflakable) -> Route {
        return .init(.GET, ChannelBase(chanId) + WebhookBase)
    }
    
    public static func GuildsWebhooksGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildBase(guildId) + WebhookBase)
    }
    
    public static func WebhooksGet(_ webhookId: Snowflakable) -> Route {
        return .init(.GET, WebhookBase(webhookId))
    }
    
    public static func WebhooksGet(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
        return .init(.GET, WebhookBase(webhookId, webhookToken))
    }
    
    public static func WebhooksModify(_ webhookId: Snowflakable) -> Route {
        return .init(.PATCH, WebhookBase(webhookId))
    }
    
    public static func WebhooksModify(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
        return .init(.PATCH, WebhookBase(webhookId, webhookToken))
    }
    
    public static func WebhooksDelete(_ webhookId: Snowflakable) -> Route {
        return .init(.DELETE, WebhookBase(webhookId))
    }
    
    public static func WebhooksDelete(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
        return .init(.DELETE, WebhookBase(webhookId, webhookToken))
    }
    
    public static func WebhooksExecute(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
        return .init(.POST, WebhookBase(webhookId, webhookToken))
    }
    
    public static func WebhooksExecuteSlack(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
        return .init(.POST, WebhookBase(webhookId, webhookToken) + "/slack")
    }
    
    public static func WebhooksExecuteGitHub(_ webhookId: Snowflakable, _ webhookToken: String) -> Route {
        return .init(.POST, WebhookBase(webhookId, webhookToken) + "/github")
    }
}

extension Route {
    // MARK: Guilds
    
    private static var GuildBase: String {
        return "/guilds"
    }
    
    private static func GuildBase(_ guildId: Snowflakable) -> String {
        return GuildBase + "/" + guildId.asString
    }
    
    public static var GuildCreate: Route {
        return .init(.POST, GuildBase)
    }
    
    public static func GuildGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildBase(guildId))
    }
    
    public static func GuildModify(_ guildId: Snowflakable) -> Route {
        return .init(.PATCH, GuildBase(guildId))
    }
    
    public static func GuildDelete(_ guildId: Snowflakable) -> Route {
        return .init(.DELETE, GuildBase(guildId))
    }
    
    public static func GuildChannelsGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildBase(guildId) + ChannelBase)
    }
    
    public static func GuildChannelsCreate(_ guildId: Snowflakable) -> Route {
        return .init(.POST, GuildBase(guildId) + ChannelBase)
    }
    
    public static func GuildChannelsModifyPosition(_ guildId: Snowflakable) -> Route {
        return .init(.PATCH, GuildBase(guildId) + ChannelBase)
    }
    
    private static func GuildMembersBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/members"
    }
    
    private static func GuildMembersBase(_ guildId: Snowflakable, _ userId: Snowflakable) -> String {
        return GuildMembersBase(guildId) + "/" + userId.asString
    }
    
    public static func GuildMembersGet(_ guildId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.GET, GuildMembersBase(guildId, userId))
    }
    
    public static func GuildMembersList(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildMembersBase(guildId))
    }
    
    public static func GuildMembersAdd(_ guildId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.PUT, GuildMembersBase(guildId, userId))
    }
    
    public static func GuildMembersModify(_ guildId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.PATCH, GuildMembersBase(guildId, userId))
    }
    
    public static func GuildMembersRemove(_ guildId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.DELETE, GuildMembersBase(guildId, userId))
    }
    
    public static func GuildMembersModifyNickMe(_ guildId: Snowflakable) -> Route {
        return .init(.PATCH, GuildMembersBase(guildId) + "/@me/nick")
    }
    
    private static func GuildMembersRolesBase(_ guildId: Snowflakable, _ userId: Snowflakable, _ roleId: Snowflakable) -> String {
        return GuildMembersBase(guildId, userId) + "/roles/" + roleId.asString
    }
    
    public static func GuildMembersRoleAdd(_ guildId: Snowflakable, _ userId: Snowflakable, _ roleId: Snowflakable) -> Route {
        return .init(.PUT, GuildMembersRolesBase(guildId, userId, roleId))
    }
    
    public static func GuildMembersRoleRemove(_ guildId: Snowflakable, _ userId: Snowflakable, _ roleId: Snowflakable) -> Route {
        return .init(.DELETE, GuildMembersRolesBase(guildId, userId, roleId))
    }
    
    public static func GuildMembresRemove(_ guildId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.DELETE, GuildMembersBase(guildId, userId))
    }
    
    private static func GuildBansBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/bans"
    }
    
    private static func GuildBansBase(_ guildId: Snowflakable, _ userId: Snowflakable) -> String {
        return GuildBansBase(guildId) + "/\(userId)"
    }
    
    public static func GuildBansList(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildBansBase(guildId))
    }
    
    public static func GuildBansGet(_ guildId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.GET, GuildBansBase(guildId, userId))
    }
    
    public static func GuildBansCreate(_ guildId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.PUT, GuildBansBase(guildId, userId))
    }
    
    public static func GuildBansRemove(_ guildId: Snowflakable, _ userId: Snowflakable) -> Route {
        return .init(.DELETE, GuildBansBase(guildId, userId))
    }
    
    private static func GuildRolesBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/roles"
    }
    
    private static func GuildRolesBase(_ guildId: Snowflakable, _ roleId: Snowflakable) -> String {
        return GuildRolesBase(guildId) + "/" + roleId.asString
    }
    
    public static func GuildRolesGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildRolesBase(guildId))
    }
    
    public static func GuildRolesCreate(_ guildId: Snowflakable) -> Route {
        return .init(.POST, GuildRolesBase(guildId))
    }
    
    public static func GuildRolesPositionModify(_ guildId: Snowflakable) -> Route {
        return .init(.PATCH, GuildRolesBase(guildId))
    }
    
    public static func GuildRolesModify(_ guildId: Snowflakable, _ roleId: Snowflakable) -> Route {
        return .init(.PATCH, GuildRolesBase(guildId, roleId))
    }
    
    public static func GuildRolesDelete(_ guildId: Snowflakable, _ roleId: Snowflakable) -> Route {
        return .init(.DELETE, GuildRolesBase(guildId, roleId))
    }
    
    private static func GuildPruneBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/prune"
    }
    
    public static func GuildPruneCount(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildPruneBase(guildId))
    }
    
    public static func GuildPruneStart(_ guildId: Snowflakable) -> Route {
        return .init(.POST, GuildPruneBase(guildId))
    }
    
    public static func GuildVoiceRegionsGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildBase(guildId) + "/regions")
    }
    
    public static func GuildInvitesGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildBase(guildId) + "/invites")
    }
    
    private static func GuildIntegrationsBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/integrations"
    }
    
    private static func GuildIntegrationsBase(_ guildId: Snowflakable, _ integrationId: Snowflakable) -> String {
        return GuildIntegrationsBase(guildId) + "/" + integrationId.asString
    }
    
    public static func GuildIntegrationsGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildIntegrationsBase(guildId))
    }
    
    public static func GuildIntegrationsCreate(_ guildId: Snowflakable) -> Route {
        return .init(.POST, GuildIntegrationsBase(guildId))
    }
    
    public static func GuildIntegrationsModify(_ guildId: Snowflakable, _ integrationId: Snowflakable) -> Route {
        return .init(.PATCH, GuildIntegrationsBase(guildId, integrationId))
    }
    
    public static func GuildIntegrationsDelete(_ guildId: Snowflakable, _ integrationId: Snowflakable) -> Route {
        return .init(.DELETE, GuildIntegrationsBase(guildId, integrationId))
    }
    
    public static func GuildIntegrationsSync(_ guildId: Snowflakable, _ integrationId: Snowflakable) -> Route {
        return .init(.POST, GuildIntegrationsBase(guildId, integrationId) + "/sync")
    }
    
    private static func GuildEmbedBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/embed"
    }
    
    public static func GuildEmbedGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildEmbedBase(guildId))
    }
    
    public static func GuildEmbedModify(_ guildId: Snowflakable) -> Route {
        return .init(.PATCH, GuildEmbedBase(guildId))
    }
    
    public static func GuildVanityUrlGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildBase(guildId) + "/vanity-url")
    }
    
    public static func GuildAuditLogGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildBase(guildId) + "/audit-logs")
    }
    
    private static func GuildEmojisBase(_ guildId: Snowflakable) -> String {
        return GuildBase(guildId) + "/emojis"
    }
    
    private static func GuildEmojisbase(_ guildId: Snowflakable, _ emojiId: String) -> String {
        return GuildEmojisBase(guildId) + "/\(emojiId)"
    }
    
    public static func GuildEmojisGet(_ guildId: Snowflakable) -> Route {
        return .init(.GET, GuildEmojisBase(guildId))
    }
    
    public static func GuildEmojisCreate(_ guildId: Snowflakable) -> Route {
        return .init(.POST, GuildEmojisBase(guildId))
    }
    
    public static func GuildEmojisGet(_ guildId: Snowflakable, emojiId: String) -> Route {
        return .init(.GET, GuildEmojisbase(guildId, emojiId))
    }
    
    public static func GuildEmojisModify(_ guildId: Snowflakable, emojiId: String) -> Route {
        return .init(.PATCH, GuildEmojisbase(guildId, emojiId))
    }
    
    public static func GuildEmojisDelete(_ guildId: Snowflakable, emojiId: String) -> Route {
        return .init(.DELETE, GuildEmojisbase(guildId, emojiId))
    }
}
