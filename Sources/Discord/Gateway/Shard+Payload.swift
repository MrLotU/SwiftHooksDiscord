import Foundation
import protocol NIO.EventLoop
import class Metrics.Counter

extension Shard {
    func handle(_ payload: GatewaySinData, _ data: Data, on eventLoop: EventLoop) {
        Counter(label: "discord_event_recieved", dimensions: [("op", payload.op.description)]).increment()
        switch payload.op {
        case .dispatch:
            lastSequence = payload.s
            
            handleDispatch(payload, data, on: eventLoop)
            
        case .heartbeat:
            ackMissed -= 1
            
        case .invalidSession:
            if let canResume = payload.getData(Bool.self, from: data) {
                sessionId = canResume ? sessionId : nil
                reconnect()
            }
            
        case .hello:
            guard let payload = payload.getData(GatewayHello.self, from: data) else {
                self.logger.error("Couldn't handle HELLO. Shutting down.")
                disconnect()
                return
            }
            let interval = Int64(payload.heartbeatInterval)
            self.logger.debug("Starting hearbeater. Interval: \(interval)ms")
            heartbeatTask = self.socket?.eventLoop.scheduleRepeatedTask(initialDelay: .milliseconds(interval), delay: .milliseconds(interval)) { [weak self] (task) in
                guard let strongSelf = self else { return }
                guard !(strongSelf.socket?.isClosed ?? true) else {
                    strongSelf.logger.warning("Hearbeating from closed shard")
                    return
                }
                guard strongSelf.ackMissed < 2 else {
                    strongSelf.logger.error("Did not get HEARTBEAT_ACK. Reconnecting...")
                    strongSelf.reconnect()
                    return
                }
                strongSelf.ackMissed += 1
                strongSelf.heartbeat()
            }

            guard isReconnecting, let sessionId = sessionId, let seq = lastSequence else {
                identify()
                return
            }

            let d = ResumePayload(token: token, session_id: sessionId, seq: seq)

            let resPayload = GatewayPayload(d: d, op: .resume, s: nil, t: nil)
            send(resPayload)
            
        case .reconnect:
            sessionId = nil
            reconnect()
            
        case .heartbeatAck:
            ackMissed -= 1
            
        default:
            self.logger.warning("Unhandled discord event: \(payload.op)")
        }
    }
}
