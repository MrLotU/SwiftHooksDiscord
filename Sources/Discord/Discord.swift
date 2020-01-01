import NIO
import NIOConcurrencyHelpers
import Foundation

extension HookID {
    static var discord: HookID {
        return .init(identifier: "discord")
    }
}

public typealias Discord = DiscordEvent

public final class DiscordHook: Hook {
    public typealias Options = DiscordHookOptions
    
    public static let id: HookID = .discord
    public let translator: EventTranslator.Type = DiscordEventTranslator.self
    internal let token: String
    internal let sharder: Sharder
    internal let lock: Lock
    public let eventLoopGroup: EventLoopGroup
    public let client: DiscordRESTClient
    public let state: State
    public internal(set) var discordListeners: [DiscordEvent: [EventClosure]]
    public internal(set) var hooks: SwiftHooks?
    
    static let decoder = JSONDecoder()
    static var decodingInfo: CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: "handler")!
    }
    
    public init(_ options: DiscordHookOptions, _ elg: EventLoopGroup) {
        self.eventLoopGroup = elg
        self.token = options.token
        self.sharder = Sharder()
        self.lock = Lock()
        self.discordListeners = [:]
        self.client = DiscordRESTClient(self.eventLoopGroup, self.token)
        self.state = State()
        
        DiscordHook.decoder.userInfo[DiscordHook.decodingInfo] = self
    }
}

