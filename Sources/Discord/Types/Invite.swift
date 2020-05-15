public struct Invite: Codable {
    public let code: String
    public let guild: Guild?
    public let channel: Channel
    public let inviter: User?
    public let targetUser: User?
    public let targetUserType: TargetUserType?
    public let approximatePresenceCount: Int?
    public let approximateMemberCount: Int?
    public let uses: Int?
    public let maxUses: Int?
    public let maxAge: Int?
    public let temporary: Bool?
    public let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case code, guild, channel, inviter
        case targetUser = "target_user", targetUserType = "target_user_type"
        case approximateMemberCount = "approximate_member_count"
        case approximatePresenceCount = "approximate_presence_count"
        case uses, maxUses = "max_uses", maxAge = "max_age"
        case temporary, createdAt = "created_at"
    }
}

public enum TargetUserType: Int, Codable {
    case stream = 1
}
