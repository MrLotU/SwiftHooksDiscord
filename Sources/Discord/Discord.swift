import Logging
import NIO
import NIOConcurrencyHelpers
import Foundation

extension HookID {
    public static var discord: HookID {
        return .init(identifier: "discord")
    }
}


public final class DiscordHook: Hook {
    public typealias Options = DiscordHookOptions
    
    public let logger: Logger
    public static let id: HookID = .discord
    public let options: Options
    internal let sharder: Sharder
    internal let lock: Lock
    public let eventLoopGroup: EventLoopGroup
    public let rest: DiscordRESTClient
    public let state: State
    public internal(set) var discordListeners: [DiscordEvent: [EventClosure]]
    public internal(set) var hooks: SwiftHooks?
    
    static let decoder = JSONDecoder()
    static var decodingInfo: CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: "DiscordHook")!
    }
    
    public init(_ options: DiscordHookOptions, _ elg: EventLoopGroup) {
        self.logger = Logger(label: "SwiftHooksDiscord.DiscordHook")
        self.eventLoopGroup = elg
        self.options = options
        self.sharder = Sharder()
        self.lock = Lock()
        self.discordListeners = [:]
        self.rest = DiscordRESTClient(self.eventLoopGroup, self.options.token)
        self.state = State()
        
        DiscordHook.decoder.userInfo[DiscordHook.decodingInfo] = self
    }
}

