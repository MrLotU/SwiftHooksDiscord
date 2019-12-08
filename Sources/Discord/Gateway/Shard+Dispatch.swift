import Foundation

extension Shard {
    func handleDispatch(_ payload: GatewaySinData, _ data: Data) {
        guard let event = payload.t else { return }
        
        self.hook.dispatchEvent(event, with: data)
    }
}
