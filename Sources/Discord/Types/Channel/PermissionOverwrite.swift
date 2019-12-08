public struct PermissionOverwrite: Codable {
    public let id: Snowflake
    public let type: PermissionOverwriteType
    public let allow: Int
    public let deny: Int
}

extension PermissionOverwrite: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return id
    }
}

public enum PermissionOverwriteType: String, Codable {
    case role, member
}
