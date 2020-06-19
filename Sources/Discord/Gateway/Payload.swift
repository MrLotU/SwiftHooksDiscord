import Foundation
import protocol NIO.EventLoop

public protocol DiscordGatewayType: PayloadType, Encodable { }
protocol DiscordHandled {
    var client: DiscordClient! { get set }
    
    func copyWith(_ client: DiscordClient) -> Self
}
public extension DiscordGatewayType {
    static func create(from data: Data, on h: _Hook, on eventLoop: EventLoop) -> Self? {
        do {
            let i = try DiscordHook.decoder.decode(GatewayData<Self>.self, from: data)
            if var d = i.d as? DiscordHandled, let h = h as? DiscordHook {
                d.client = _DiscordClient(h, eventLoop: eventLoop)
                return d as? Self
            }
            return i.d
        } catch {
            SwiftHooks.logger.debug("Decoding error: \(error), \(error.localizedDescription)")
            return nil
        }
    }
}

struct GatewaySinData: Codable {
    let op: OPCode
    
    let s: Int?
    
    let t: DiscordEvent?
    
    func getData<T>(_ type: T.Type, from raw: Data) -> T? where T: Codable {
        do {
            let data = try SwiftHooks.decoder.decode(GatewayData<T>.self, from: raw)
            return data.d
        } catch {
            SwiftHooks.logger.error("\(error.localizedDescription)")
            return nil
        }
    }
}

struct GatewayData<T: Codable>: Codable {
    let d: T
}

struct GatewayPayload<T: Codable>: Codable {
    let d: T
    let op: OPCode
    let s: Int?
    let t: String?
}
