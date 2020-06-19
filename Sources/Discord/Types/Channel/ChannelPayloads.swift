import Foundation

public struct ModifyChannelPayload: Codable {
    public let name: String?
    public let position: Int?
    public let topic: String?
    public let isNsfw: Bool?
    public let rateLimit: Int?
    public let bitrate: Int?
    public let userLimit: Int?
    public let permissionOverwrites: [PermissionOverwrite]?
    public let parentId: Snowflake?
    
    enum CodingKeys: String, CodingKey {
        case name, position, topic, bitrate
        case isNsfw = "nsfw", rateLimit = "rate_limit_per_user", userLimit = "user_limit"
        case permissionOverwrites = "permission_overwrites", parentId = "parent_id"
    }
}

public struct ChannelMessagesGetQuery: QueryItemConvertible {
    public let around: Snowflake?
    public let before: Snowflake?
    public let after: Snowflake?
    public let limit: Int?
    
    public func toQueryItems() -> [URLQueryItem] {
        var arr = [
            URLQueryItem(name: "around", value: around?.asString),
            URLQueryItem(name: "before", value: before?.asString),
            URLQueryItem(name: "after", value: after?.asString)
        ]
        if let l = limit {
            arr.append(.init(name: "limit", value: "\(l)"))
        }
        return arr
    }
}

public struct MessageCreatePayload: Codable {
    public let content: String
    public let nonce: Snowflake?
    public let isTts: Bool?
    public let embed: Embed?
    public let allowedMentions: AllowedMentions
    
    enum CodingKeys: String, CodingKey {
        case content, nonce, embed
        case isTts = "tts", allowedMentions = "allowed_mentions"
    }
}

public struct MessageEditPayload: Codable {
    public let content: String?
    public let embed: Embed?
    public let flags: MessageFlags?
}

public struct BulkDeleteMessagesPayload: Codable {
    public let messages: [Snowflake]
}

public struct GetReactionsQuery: QueryItemConvertible {
    public let before: Snowflake?
    public let after: Snowflake?
    public let limit: Int?
    
    public func toQueryItems() -> [URLQueryItem] {
        var arr = [
            URLQueryItem(name: "before", value: before?.asString),
            URLQueryItem(name: "after", value: after?.asString)
        ]
        if let l = limit {
            arr.append(URLQueryItem(name: "limit", value: "\(l)"))
        }
        return arr
    }
}

public struct EditChannelPermissionsPayload: Codable {
    public let allow: Permissions
    public let deny: Permissions
    public let type: ChannelPermissionsType
    
    public enum ChannelPermissionsType: String, Codable {
        case member, role
    }
}

public struct CreateInvitePayload: Codable {
    public let maxAge: Int?
    public let maxUses: Int?
    public let isTemporary: Bool?
    public let isUnique: Bool?
    
    enum CodingKeys: String, CodingKey {
        case maxAge = "max_age", maxUses = "max_uses"
        case isTemporary = "temporary", isUnique = "unique"
    }
}

public struct GroupDMRecipientAddPayload: Codable {
    public let accessToken: String
    public let nick: String?
    
    enum CodingKeys: String, CodingKey {
        case nick, accessToken = "access_token"
    }
}
