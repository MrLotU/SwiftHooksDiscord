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

    var token: String
    let sharder: Sharder
    let lock: Lock
    
    public internal(set) var discordListeners: [DiscordEvent: [EventClosure]]
    
    public private(set) var hooks: SwiftHooks?
    
    public init(_ options: DiscordHookOptions) {
        self.token = options.token
        self.sharder = Sharder()
        self.lock = Lock()
        self.discordListeners = [:]
    }
    
    public func boot(on elg: EventLoopGroup, hooks: SwiftHooks? = nil) throws {
        SwiftHooks.logger.info("Booting \(self.self)")
        self.hooks = hooks
        try Discord.registerTestables(to: self)
        let amountOfShards: UInt8 = 1
        self.sharder.shardCount = amountOfShards
        for i in 0..<amountOfShards {
            self.sharder.spawn(i, on: "wss://gateway.discord.gg", withToken: token, on: elg, handledBy: self)
        }
    }
    
    public func shutdown() {
        self.sharder.disconnect()
        self.lock.withLockVoid {
            self.hooks = nil
            self.discordListeners = [:]
        }
    }
    
    public func listen<T, I>(for event: T, handler: @escaping EventHandler<I>) where T : _Event, I == T.ContentType {
        guard let event = event as? _DiscordEvent<DiscordEvent, I> else { return }
        self.lock.withLockVoid {
            var closures = self.discordListeners[event, default: []]
            closures.append { (data) in
                guard let object = I.init(data) else {
                    SwiftHooks.logger.debug("Unable to extract \(I.self) from data.")
                    return
                }
                try handler(object)
            }
            self.discordListeners[event] = closures
        }
    }
    
    public func dispatchEvent<E>(_ event: E, with raw: Data) where E: EventType {
        defer {
            self.hooks?.dispatchEvent(event, with: raw, from: self)
        }
        guard let event = event as? DiscordEvent else { return }
        self.lock.withLockVoid {
            let handlers = self.discordListeners[event]
            handlers?.forEach({ (handler) in
                do {
                    try handler(raw)
                } catch {
                    SwiftHooks.logger.error("\(error.localizedDescription)")
                }
            })
        }
    }
}

enum DiscordEventTranslator: EventTranslator {
    static func translate<E>(_ event: E) -> GlobalEvent? where E : EventType {
        guard let e = event as? DiscordEvent else { return nil }
        switch e {
        case ._messageCreate: return ._messageCreate
        default: return nil
        }
    }
    
    static func decodeConcreteType<T>(for event: GlobalEvent, with data: Data, as t: T.Type) -> T? {
        switch event {
        case ._messageCreate: return Message(data) as? T
        }
    }
}

public struct DiscordHookOptions: HookOptions {
    public typealias H = DiscordHook
    
    var token: String
    
    public init(token: String) {
        self.token = token
    }
}
