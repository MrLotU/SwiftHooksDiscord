enum OPCode: UInt8, Codable {
    case dispatch = 0
    case heartbeat = 1
    case identify = 2
    case statusUpdate = 3
    case voiceStateUpdate = 4
    case resume = 6
    case reconnect = 7
    case requestGuildMembers = 8
    case invalidSession = 9
    case hello = 10
    case heartbeatAck = 11
}

extension OPCode: CustomStringConvertible {
    var description: String {
        switch self {
        case .dispatch: return "dispatch"
        case .heartbeat: return "heartbeat"
        case .identify: return "identify"
        case .statusUpdate: return "statusUpdate"
        case .voiceStateUpdate: return "voiceStateUpdate"
        case .resume: return "resume"
        case .reconnect: return "reconnect"
        case .requestGuildMembers: return "requestGuildMembers"
        case .invalidSession: return "invalidSession"
        case .hello: return "hello"
        case .heartbeatAck: return "heartbeatAck"
        }
    }
}

/// Discorsd ErrorCodes
enum GatewayErrorCode: Int, Error {
    case unknown = 4000
    case unknownOpCode = 4001
    case decodeError = 4002
    case notAuthenticated = 4003
    case authenticationFailed = 4004
    case alreadyAuthenticated = 4005
    case invalidSequence = 4007
    case rateLimited = 4008
    case sessionTimeout = 4009
    case invalidShard = 4010
    case shardingRequired = 4011
}
