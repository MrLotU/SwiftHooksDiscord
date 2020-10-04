import Foundation

public struct Snowflake {
    public static let epoch = Date(timeIntervalSince1970: 1420070400)
    
    public let rawValue: UInt64
    
    public var increment: UInt16 {
        return UInt16(rawValue & 0xFFF)
    }
    
    public var processId: UInt8 {
        return UInt8((rawValue & 0x1F000) >> 12)
    }
    
    public var workerId: UInt8 {
        return UInt8((rawValue & 0x3E0000) >> 17)
    }
    
    public var timestamp: Date {
        return Date(
            timeInterval: Double(
                (rawValue >> 22) / 1000
            ),
            since: Snowflake.epoch
        )
    }
    
    public init() {
        var rawValue: UInt64 = 0
        
        // Setup timestamp (42 bits)
        let now = Date()
        let difference = UInt64(now.timeIntervalSince(Snowflake.epoch) * 1000)
        rawValue |= difference << 22
        
        // Setup worker id (5 bits)
        rawValue |= 16 << 17
        
        // Setup process id (6 bits)
        rawValue |= 1 << 12
        
        // Setup incremented id (11 bits)
        rawValue += 128
        
        self.rawValue = rawValue
    }
    
    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}

extension Snowflake: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Int64(rawValue))
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self) {
            self.init(str)!
            return
        }
        let int = try container.decode(Int64.self)
        self.init(rawValue: UInt64(int))
    }
}

extension Snowflake: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self.init(value)!
    }
}

extension Snowflake: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = UInt64

    public init(integerLiteral value: UInt64) {
        self.rawValue = value
    }
}

extension Snowflake: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let value = UInt64(description) else {
            return nil
        }
        self.rawValue = value
    }
}

extension Snowflake: CustomStringConvertible {
    public var description: String {
        return rawValue.description
    }
}

extension Snowflake: RawRepresentable, Equatable {
    public typealias RawValue = UInt64
}

extension Snowflake: Comparable {

    public static func <(lhs: Snowflake, rhs: Snowflake) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Snowflake: Hashable {

    public var hashValue: Int {
        return rawValue.hashValue
    }
}

extension Snowflake: CommandArgumentConvertible {
    public static func resolveArgument(_ argument: String, on event: _EventType) throws -> Snowflake {
        if let flake = Snowflake(argument) {
            return flake
        }
        throw CommandError.UnableToConvertArgument(argument, "\(self.self)")
    }
}

extension Snowflake: Snowflakable {
    public var snowflakeDescription: Snowflake {
        return self
    }
}
