import Foundation
import WebSocketKit

extension Shard {
    func connect(to socketUrl: String) {
        guard let url = URL(string: socketUrl) else {
            return
        }
        self.socketUrl = socketUrl
        let socket = WebSocket.connect(to: url, configuration: .init(tlsConfiguration: .forClient(), maxFrameSize: 1 << 18), on: self.elg.next()) { [weak self] ws in
            guard let strongSelf = self else {
                return
            }

            // Order here is important. If we do not assign
            // strongSelf.socket
            // before adding the listeners, we might encounter crashes
            // or miss events

            strongSelf.socket = ws
            
            ws.onText { _, text in
                strongSelf.handle(text)
            }
            
            ws.onBinary { (_, buffer) in
                var b = buffer
                guard let data = b.readData(length: buffer.readableBytes) else { return }
                strongSelf.handle(data)
            }
            
            self?.logger.info("Gateway connected for shard \(strongSelf.id)")
        }
        
        DispatchQueue.main.async {
            do {
                try socket.wait()
                self.socket?.onClose.whenComplete { [weak self] res in
                    self?.logger.info("Gateway connection closed for shard \(self?.id ?? 0)")
                }
            } catch {
                // ERROR
            }
        }
    }
    
    func disconnect() {
        self.ackMissed = 0
        self.buffer = []
        self.heartbeatTask?.cancel()
        _ = socket?.close(code: .normalClosure)
        socket = nil
    }
}
