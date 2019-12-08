import Foundation

public protocol DiscordGatewayType: PayloadType, Encodable { }
public extension DiscordGatewayType {
    init?(_ data: Data) {
        do {
            let i = try SwiftHooks.decoder.decode(GatewayData<Self>.self, from: data)
            self = i.d
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
