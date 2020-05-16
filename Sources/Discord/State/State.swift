import NIOConcurrencyHelpers

public final class State {
    private let lock: Lock
    
    private var _channels: [Channel]
    private var _guilds: [Guild]
    
    private var _dms: [Snowflake: Channel]
    private var _users: [Snowflake: User]
    
    private var _me: User!
    
    internal init() {
        self.lock = Lock()
        self._channels = []
        self._guilds = []
        self._dms = [:]
        self._users = [:]
        self._me = nil
    }
}

public extension State {
    internal(set) var channels: [Channel] {
        get {
            self.lock.withLock { self._channels }
        }
        set {
            self.lock.withLockVoid { self._channels = newValue }
        }
    }
    
    internal(set) var guilds: [Guild] {
        get {
            self.lock.withLock { self._guilds }
        }
        set {
            self.lock.withLockVoid { self._guilds = newValue }
        }
    }
    
    internal(set) var dms: [Snowflake: Channel] {
        get {
            self.lock.withLock { self._dms }
        }
        set {
            self.lock.withLockVoid { self._dms = newValue }
        }
    }
    
    internal(set) var users: [Snowflake: User] {
        get {
            self.lock.withLock { self._users }
        }
        set {
            self.lock.withLockVoid { self._users = newValue }
        }
    }
    
    internal(set) var me: User {
        get {
            self.lock.withLock { self._me }
        }
        set {
            self.lock.withLockVoid { self._me = newValue }
        }
    }
}

extension Array where Element: Snowflakable & DiscordHandled {
    subscript (flake: Snowflake) -> Element? {
        get {
            return self.first { $0.snowflakeDescription == flake }
        }
        set {
            defer {
                if var val = newValue {
                    val.client = nil
                    self.append(val)
                }
            }
            guard let index = self.firstIndex(where: { $0.snowflakeDescription == flake }) else { return }
            self.remove(at: index)
        }
    }
}
