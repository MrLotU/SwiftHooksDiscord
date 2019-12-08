internal struct IdentifyPayload: Codable {
    public let token: String
    public let properties: Properties
    public let compress: Bool?
    public let large_treshold: Int?
    public let shard: [UInt8]?
    
    init(token: String, properties: Properties, compress: Bool? = nil, largeTreshold: Int? = nil, shard: [UInt8]? = nil) {
        self.token = token
        self.properties = properties
        self.compress = compress
        self.large_treshold = largeTreshold
        self.shard = shard
    }
    
    public struct Properties: Codable {
        public let os: String
        public let browser: String
        public let device: String
        
        init(os: String, browser: String, device: String) {
            self.os = os
            self.browser = browser
            self.device = device
        }
        
        enum CodingKeys: String, CodingKey {
            case os = "$os"
            case browser = "$browser"
            case device = "$device"
        }
    }
}

internal struct ResumePayload: Codable {
    public let token: String
    public let session_id: String
    public let seq: Int?
}

internal struct HeartbeatPayload: Codable {
    public let op: OPCode
    public let d: Int
}

internal struct RequestGuildMembersPayload: Codable {
    public let guild_id: [Snowflake]
    public let query: String
    public let limit: Int
}

//internal struct UpdateStatusPayload: Codable {
//    public let since: Int
//    public let game: Activity?
//    public let status: UserStatus
//    public let afk: Bool
//}
