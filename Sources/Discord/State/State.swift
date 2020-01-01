import NIOConcurrencyHelpers

public final class State {
    private let lock: Lock
    
    private var _channels: [Snowflake: Channel]
    private var _guilds: [Snowflake: Guild]
    
    private var _dms: [Snowflake: Channel]
    private var _users: [Snowflake: User]
    
    private var _me: User!
    
    internal init() {
        self.lock = Lock()
        self._channels = [:]
        self._guilds = [:]
        self._dms = [:]
        self._users = [:]
        self._me = nil
    }
}

public extension State {
    internal(set) var channels: [Snowflake: Channel] {
        get {
            self.lock.withLock { self._channels }
        }
        set {
            self.lock.withLockVoid { self._channels = newValue }
        }
    }
    
    internal(set) var guilds: [Snowflake: Guild] {
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
