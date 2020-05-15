import NIO
import Foundation

extension DiscordHook {
    public func boot(hooks: SwiftHooks? = nil) throws {
        self.logger.info("Booting hook.")
        self.hooks = hooks
        self.register(StatePlugin())
        if let shardCount = self.options.sharding.totalShards, let shard = self.options.sharding.shardId {
            self.sharder.shardCount = shardCount
            self.sharder.spawn(shard, on: "wss://gateway.discord.gg", withToken: options.token, on: self.eventLoopGroup, handledBy: self)
        } else {
            let amountOfShards = 1
            self.sharder.shardCount = amountOfShards
            for i in 0..<amountOfShards {
                self.sharder.spawn(i, on: "wss://gateway.discord.gg", withToken: options.token, on: self.eventLoopGroup, handledBy: self)
            }
        }
    }
    
    public func shutdown() {
        self.sharder.disconnect()
        self.lock.withLockVoid {
            self.hooks = nil
            self.discordListeners = [:]
        }
    }
    
    public func listen<T, I, D>(for event: T, handler: @escaping EventHandler<D, I>) where T : _Event, I == T.ContentType, T.D == D {
        guard let event = event as? _DiscordEvent<I> else { return }
        self.lock.withLockVoid {
            var closures = self.discordListeners[event, default: []]
            closures.append { (data, el) in
                guard let object = I.create(from: data, on: self, on: el) else {
                    self.logger.debug("Unable to extract \(I.self) from data.")
                    return el.makeFailedFuture(SwiftHooksError.GenericTypeCreationFailure("\(I.self)"))
                }
                guard let d = D.init(self, eventLoop: el) else {
                    self.logger.debug("Unable to wrap \(I.self) in \(D.self) dispatch.")
                    return el.makeFailedFuture(SwiftHooksError.DispatchCreationError)
                }
                return handler(d, object)
            }
            self.discordListeners[event] = closures
        }
    }
    
    public func dispatchEvent<E>(_ event: E, with raw: Data, on eventLoop: EventLoop) -> EventLoopFuture<Void> where E: EventType {
        func unwrapAndFuture(_ x: Void = ()) -> EventLoopFuture<Void> {
            if let hooks = self.hooks {
                return hooks.dispatchEvent(event, with: raw, from: self, on: eventLoop)
            } else {
                return eventLoop.makeSucceededFuture(())
            }
        }
        guard let event = event as? DiscordEvent else { return unwrapAndFuture() }
        let futures = self.lock.withLock { () -> [EventLoopFuture<Void>] in
            let handlers = self.discordListeners[event] ?? []
            return handlers.map({ (handler) in
                return handler(raw, eventLoop)
            })
        }
        return EventLoopFuture.andAllSucceed(futures, on: eventLoop)
            .flatMap(unwrapAndFuture)
    }

    public func translate<E>(_ event: E) -> GlobalEvent? where E : EventType {
        guard let e = event as? DiscordEvent else { return nil }
        switch e {
        case ._messageCreate: return ._messageCreate
        default: return nil
        }
    }
    
    public func decodeConcreteType<T>(for event: GlobalEvent, with data: Data, as t: T.Type, on eventLoop: EventLoop) -> T? {
        switch event {
        case ._messageCreate: return Message.create(from: data, on: self, on: eventLoop) as? T
        }
    }
}

public struct DiscordHookOptions: HookOptions {
    public let token: String
    public let errorPrefix: String?
    public let highlightFormatting: String
    public let state: DiscordStateOptions
    public let sharding: DiscordShardingOptions
    public let maxReconnects: Int?
    
    public struct DiscordStateOptions {
        public let syncGuildmembers: Bool
        public let cacheMessages: Bool
        
        public init(syncGuildmembers: Bool = true, cacheMessages: Bool = true) {
            self.syncGuildmembers = syncGuildmembers
            self.cacheMessages = cacheMessages
        }
    }
    
    public struct DiscordShardingOptions {
        public let autoshard: Bool
        public let shardId: Int?
        public let totalShards: Int?
        
        public static let autosharding = DiscordShardingOptions(autoshard: true, shardId: nil, totalShards: nil)
        public static func manual(shardId: Int, totalShards: Int) -> DiscordShardingOptions {
            .init(autoshard: false, shardId: shardId, totalShards: totalShards)
        }
    }
    
    public init(token: String, errorPrefix: String? = nil, highlightFormatting: String = "`", state: DiscordHookOptions.DiscordStateOptions = .init(), sharding: DiscordHookOptions.DiscordShardingOptions = .autosharding, maxReconnects: Int? = nil) {
        self.token = token
        self.errorPrefix = errorPrefix
        self.highlightFormatting = highlightFormatting
        self.state = state
        self.sharding = sharding
        self.maxReconnects = maxReconnects
    }
}
