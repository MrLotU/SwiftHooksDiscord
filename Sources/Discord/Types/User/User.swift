public struct PartialUser: Codable {
    public let id: Snowflake
}

public enum UserStatus: String, Codable {
    case online, dnd, idle, invisible, offline
}

public typealias User = Discord.User
public extension Discord {
    class User: DiscordGatewayType, DiscordHandled {
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
        public let publicFlags: UserFlags?
        
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
            case publicFlags = "public_flags"
        }
    }
}

public struct UserFlags: OptionSet, Codable {
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public let rawValue: Int
    
    public static let none = UserFlags([])
    public static let employee = UserFlags(rawValue: 1 << 0)
    public static let parter = UserFlags(rawValue: 1 << 1)
    public static let hypesquadEvents = UserFlags(rawValue: 1 << 2)
    public static let bugHunterLevelOne = UserFlags(rawValue: 1 << 3)
    public static let houseBravery = UserFlags(rawValue: 1 << 6)
    public static let houseBrilliance = UserFlags(rawValue: 1 << 7)
    public static let houseBalance = UserFlags(rawValue: 1 << 8)
    public static let earlySupporter = UserFlags(rawValue: 1 << 9)
    public static let teamUser = UserFlags(rawValue: 1 << 10)
    public static let system = UserFlags(rawValue: 1 << 12)
    public static let bugHunterLevelTwo = UserFlags(rawValue: 1 << 14)
    public static let verifiedBot = UserFlags(rawValue: 1 << 16)
    public static let verifiedBotDeveloper = UserFlags(rawValue: 1 << 17)
}

extension User: Userable {
    public var identifier: String? {
        id.asString
    }
}

extension User: CommandArgumentConvertible {
    public static func resolveArgument(_ argument: String, on event: CommandEvent) throws -> User {
        if let user = event.message.discord?.mentions.first(where: { $0.mention == argument.replacingOccurrences(of: "!", with: "") }) {
            return user
        }
        guard let snowflake = Snowflake(argument) else {
            throw CommandError.UnableToConvertArgument(argument, "\(self.self)")
        }
        guard let user = event.discord?.state.users[snowflake] else {
            throw CommandError.ArgumentNotFound(argument)
        }
        return user
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
