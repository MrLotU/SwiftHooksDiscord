import Foundation
import WebSocketKit

extension Shard {
    func connect(to socketUrl: String) {
        guard let url = URL(string: socketUrl) else {
            self.logger.error("Invalid socket URL")
            return
        }
        self.socketUrl = socketUrl
        let socket = WebSocket.connect(to: url, configuration: .init(tlsConfiguration: .forClient(), maxFrameSize: 1 << 18), on: self.elg) { [weak self] ws in
            guard let strongSelf = self else {
                return
            }

            strongSelf.socket = ws
            
            ws.onText { _ws, text in
                strongSelf.handle(text, on: _ws.eventLoop)
            }
            
            ws.onBinary { (_ws, buffer) in
                var b = buffer
                guard let data = b.readData(length: buffer.readableBytes) else { return }
                strongSelf.handle(data, on: _ws.eventLoop)
            }
            
            self?.logger.info("Gateway connected")
        }
        
        DispatchQueue.main.async {
            do {
                try socket.wait()
                self.socket?.onClose.whenComplete { [weak self] res in
                    self?.logger.info("Gateway connection closed")
                }
            } catch {
                self.logger.error("Unexpected gateway error \(error)")
            }
        }
    }
    
    func disconnect() {
        self.logger.info("Gateway disconnecting.")
        self.ackMissed = 0
        self.buffer = []
        self.heartbeatTask?.cancel()
        _ = socket?.close(code: .normalClosure)
        socket = nil
    }
}
