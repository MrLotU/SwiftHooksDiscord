public struct PartialUser: Codable {
    public let id: Snowflake
}

public enum UserStatus: String, Codable {
    case online, dnd, idle, invisible, offline
}

public struct User: DiscordGatewayType, DiscordHandled {
    public internal(set) var client: DiscordClient!
    
    public let id: Snowflake
    public let username: String
    public let discriminator: String
    public let avatar: String?
    public let isBot: Bool?
    public let isSystem: Bool?
    public let locale: String?
    public let mfaEnabled: Bool?
    public let isVerified: Bool?
    public let email: String?
    public let flags: Int?
    public let premiumType: PremiumType?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case discriminator
        case avatar
        case isBot = "bot"
        case isSystem = "system"
        case locale
        case mfaEnabled = "mfa_enabled"
        case isVerified = "verified"
        case email
        case flags
        case premiumType = "premium_type"
    }
}

extension User: Userable {
    public var identifier: String? {
        id.asString
    }
}

extension User: CommandArgumentConvertible {
    public static var canConsume: Bool {
        return true
    }
    
    public static func resolveArgument(_ argument: String, on event: CommandEvent) throws -> User {
//        if let user = event.message.mentions.first(where: { $0.mention == argument.replacingOccurrences(of: "!", with: "") }) {
//            return user
//        }
//        guard let snowflake = Snowflake(argument) else {
            throw CommandError.UnableToConvertArgument(argument, "\(self.self)")
//        }
//        guard let user = event.handler.state.users[snowflake] else {
//            throw CommandError.ArgumentNotFound(argument)
//        }
//        return user
    }
}

extension User: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return self.id
    }
}

extension User {
    public func getAvatarUrl(format: String = "webp", size: Int = 1024) -> String {
        guard let avatar = avatar else {
            return "https://cdn.discordapp.com/embed/avatars/\(Int(discriminator) ?? 0 % 5).png"
        }
        return "https://cdn.discordapp.com/avatars/\(id)/\(avatar).\(format)?size=\(size)"
    }
    
    public var avatarUrl: String {
        return getAvatarUrl()
    }
    
    public var mention: String {
        return "<@\(id)>"
    }
}

extension User: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "\(username)#\(discriminator)"
    }
    
    public var debugDescription: String {
        return "<User \(id) \(description)>"
    }
}
