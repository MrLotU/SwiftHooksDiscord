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

public struct MessageCreatePayload: Codable {
    public let content: String
    public let nonce: Snowflake?
    public let isTts: Bool?
    public let embed: Embed?
    
    enum CodingKeys: String, CodingKey {
        case content, nonce, embed
        case isTts = "tts"
    }
}

public struct MessageEditPayload: Codable {
    public let content: String?
    public let embed: Embed?
}

public struct BulkDeleteMessagesPayload: Codable {
    public let messages: [Snowflake]
}

public struct EditChannelPermissionsPayload: Codable {
    public let allow: Int
    public let deny: Int
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
