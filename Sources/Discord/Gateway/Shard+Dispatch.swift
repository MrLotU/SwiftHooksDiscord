import NIO
import Foundation

extension Shard {
    func handleDispatch(_ payload: GatewaySinData, _ data: Data, on eventLoop: EventLoop) {
        guard let event = payload.t else { return }

        self.hook.dispatchEvent(event, with: data, on: eventLoop).whenComplete { res in
            if case .failure(let e) = res {
                self.logger.error("Error handeling dispatch message \(e.localizedDescription)")
            }
        }
    }
}
