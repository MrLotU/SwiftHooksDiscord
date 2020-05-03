import Logging
import NIO

extension DiscordHook {
    /// Current Gateway Version
    static let GatewayVersion: UInt8 = 6
    
    /// Gateway encoding
    static let GatewayEncoding: String = "json"
    
    /// Gateway compression
    static let GatewayCompression: String = "zlib-stream"
}

/// Sharder for autosharding
///
/// Discord allows for sharding.
/// This means you have multiple shards running and each of them
/// does a part of the processing.
///
/// The Sharder class automates the sharding
class Sharder {
    let logger: Logger
    /// Amount of shards we should spawn
    var shardCount: Int
    
    /// Cache of hosts the shard with the given ID was connected to
    var shardHosts: [Int: String]
    
    /// List of shards
    var shards: [Shard]
    
    /// Creates a new Sharder
    init() {
        self.logger = Logger(label: "SwiftHooksDiscord.Sharder")
        self.shardCount = 0
        self.shardHosts = [:]
        self.shards = []
    }
    
    /// Spawns a new shard with given info
    ///
    /// - parameters:
    ///     - id: ID of the shard to spawn
    ///     - host: Host to spawn the shard on. Will be extended with Discord specific data
    ///     - t: Token to authenticate the shard
    ///     - handler: DiscordHandler class handeling this sharder and it's shards
    func spawn(_ id: Int, on host: String, withToken t: String, on elg: EventLoopGroup, handledBy h: DiscordHook) {
        var host = "\(host)?v=\(DiscordHook.GatewayVersion)"
        
        host += "&encoding=\(DiscordHook.GatewayEncoding)"
        
        // check for encoding
        host += "&compress=\(DiscordHook.GatewayCompression)"
        
        shardHosts[id] = host
        
        self.logger.info("Spawning shard \(id) with connection to \(host)")
        
        let shard = Shard(id: id, hook: h, token: t, elg: elg)
        shard.connect(to: host)
        shards.append(shard)
    }
    
    /// Disconnects all shards
    func disconnect() {
        shards.forEach { $0.disconnect() }
    }
}
