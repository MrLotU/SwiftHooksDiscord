//
//  File.swift
//  
//
//  Created by Jari (LotU) on 01/12/2019.
//

public struct GatewayBotResponse: Codable {
    public let url: String
    public let shards: Int
    public let sessionStartLimit: SessionStartLimit
    
    enum CodingKeys: String, CodingKey {
        case url, shards
        case sessionStartLimit = "session_start_limit"
    }
    
    public struct SessionStartLimit: Codable {
        public let total: Int
        public let remaining: Int
        public let reset_after: Int
    }
}
