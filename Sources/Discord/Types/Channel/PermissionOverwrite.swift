public struct PermissionOverwrite: Codable {
    public let id: Snowflake
    public let type: PermissionOverwriteType
    public let allow: Permissions
    public let deny: Permissions
}

extension PermissionOverwrite: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return id
    }
}

public enum PermissionOverwriteType: String, Codable {
    case role, member
}
