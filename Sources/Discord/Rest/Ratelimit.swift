import Foundation
import NIOConcurrencyHelpers
import Logging

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func == (_ lhs: AnyRoute, _ rhs: AnyRoute) -> Bool {
    return lhs.bucket == rhs.bucket
}

struct RouteState {
    let route: String
    var resetTime: Date
    var remaining: TimeInterval
    
    init(_ r: String, _ response: HTTPURLResponse) {
        self.route = r
        if let _remaining = response.allHeaderFields["x-ratelimit-remaining"] as? String,
            let _resetTime = response.allHeaderFields["x-ratelimit-reset"] as? String,
            let remaining = Double(_remaining),
            let resetTime = Double(_resetTime)
        {
            self.resetTime = .init(timeIntervalSince1970: resetTime)
            self.remaining = remaining
        } else {
            self.resetTime = .init()
            self.remaining = 0
        }
        

    }
    
    func willRatelimitNext() -> Bool {
        return remaining < 1 && resetTime.timeIntervalSinceNow >= 0
    }
}


class RateLimiter {
    var states: [String: RouteState]
    let lock: Lock
    let logger: Logger
    
    init() {
        self.states = [:]
        self.lock = Lock()
        self.logger = Logger(label: "SwiftHooksDiscord.RateLimiter")
    }
    
    func update(_ route: AnyRoute, with response: HTTPURLResponse) {
        let bucket = response.allHeaderFields.keys.contains("x-ratelimit-global") ? "global" : route.bucket
        lock.withLockVoid {
            self.states[bucket] = .init(bucket, response)
        }
    }
    
    func check(_ route: AnyRoute) -> Int64? {
        return self.lock.withLock {
            let global = self.states["global"]
            if let state = self.states[route.bucket], (state.willRatelimitNext() || global?.willRatelimitNext() ?? false) {
                let limit = Int64(max(state.resetTime.timeIntervalSinceNow, (global?.resetTime.timeIntervalSinceNow ?? 0)) * 1000)
                self.logger.trace("Ratelimiting request for \(limit)ms.")
                return limit
            }
            return nil
        }
    }
}
