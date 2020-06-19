import Foundation
import Logging
import NIO
import WebSocketKit
import zlib

fileprivate let ZlibSuffix: Bytes = [0x0, 0x0, 0xFF, 0xFF]

/// A shard is a single connection to the Discord Gateway
///
/// A bot can have multiple shards to spread the load
final class Shard {
    var logger: Logger
    var ackMissed: Int {
        didSet {
            if ackMissed > 1 {
                self.logger.trace("Currently missed \(ackMissed) acks.")
            }
        }
    }
    var buffer: Bytes
    let id: Int
    var isBufferComplete: Bool {
        guard buffer.count >= 4 else {
            return false
        }
        return buffer.suffix(4).elementsEqual(ZlibSuffix)
    }
    var isReconnecting = false
    var lastSequence: Int?
    var sessionId: String?
    var heartbeatTask: RepeatedTask?
    var socket: WebSocket?
    let hook: DiscordHook
    let elg: EventLoopGroup
    let token: String
    var socketUrl: String?
    var stream = z_stream()
    
    init(id: Int, hook: DiscordHook, token: String, elg: EventLoopGroup) {
        self.id = id
        self.hook = hook
        self.elg = elg
        self.token = token
        self.buffer = Bytes()
        self.ackMissed = 0
        self.logger = Logger(label: "SwiftHooksDiscord.Shard")
        logger[metadataKey: "shard-id"] = "\(self.id)"
        
        stream.avail_in = 0
        stream.next_in = nil
        stream.total_out = 0
        stream.zalloc = nil
        stream.zfree = nil
        
        inflateInit2_(&stream, MAX_WBITS, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size))
    }
    
    deinit {
        inflateEnd(&stream)
        self.heartbeatTask?.cancel()
    }
    
    func handle(_ data: Data, on eventLoop: EventLoop) {
        buffer.append(contentsOf: data)
        
        guard isBufferComplete else {
            return
        }
        
        let deflated = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: buffer.count)
        
        _ = deflated.initialize(from: buffer)
        
        defer {
            deflated.deallocate()
        }
        
        stream.next_in = deflated.baseAddress
        stream.avail_in = UInt32(deflated.count)
        
        var inflated = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: deflated.count * 2)
        
        defer {
            inflated.deallocate()
        }
        
        stream.total_out = 0
        
        var status: Int32 = 0
                
        while true {
            stream.next_out = inflated.baseAddress?.advanced(by: Int(stream.total_out))
            stream.avail_out = UInt32(inflated.count) - UInt32(stream.total_out)
            
            status = inflate(&stream, Z_SYNC_FLUSH)
            
            if status == Z_BUF_ERROR && stream.avail_in == 0 {
                inflated.realloc(size: inflated.count + min(inflated.count * 2, maxBuff))
                continue
            } else if status != Z_OK {
                break
            }
        }
        
        let result = String(bytesNoCopy: inflated.baseAddress!, length: Int(stream.total_out), encoding: .utf8, freeWhenDone: false)
        
        guard let text = result else {
            return
        }
        if !text.isEmpty {
            buffer.removeAll()
        }
        handle(text, on: eventLoop)
    }
        
    func handle(_ text: String, on eventLoop: EventLoop) {
        guard let data = text.data(using: .utf8) else { return }
        do {
            let payload = try SwiftHooks.decoder.decode(GatewaySinData.self, from: data)
            handle(payload, data, on: eventLoop)
        } catch {
            self.logger.error("Error handeling payload. \(error.localizedDescription). \(text)")
        }
    }
    
    func heartbeat() {
        let heartbeat = GatewayPayload(d: lastSequence, op: .heartbeat, s: nil, t: nil)
        self.logger.trace("Heartbeating")
        send(heartbeat)
    }
        
    func identify() {
        #if os(macOS)
        let os = "macOS"
        #elseif os(Linux)
        let os = "Linux"
        #endif
        let d = IdentifyPayload(
            token: self.token,
            properties: .init(os: os, browser: "SwiftHooks", device: "SwiftHooks"),
            shard: [id, hook.sharder.shardCount]
        )
        let payload = GatewayPayload(d: d, op: .identify, s: nil, t: nil)
        self.send(payload)
    }
    
    func send<T: Codable>(_ payload: GatewayPayload<T>) {
        do {
            let data = try SwiftHooks.encoder.encode(payload)
            socket?.send(raw: data, opcode: .binary)
        } catch {
            self.logger.error("Error sending data: \(error.localizedDescription)")
        }
    }
    
    func reconnect() {
        if let socket = socket, !socket.isClosed {
            disconnect()
        }
        
        guard let host = self.socketUrl else { return }
        
        if sessionId != nil { isReconnecting = true }
        self.connect(to: host)
    }
}
