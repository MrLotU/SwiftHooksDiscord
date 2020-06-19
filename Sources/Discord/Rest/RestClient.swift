import NIO
import Foundation

public enum DiscordRestError: Error {
    case InvalidPermissions
    case NotAGuild
    case MessageNeedsContent
    case UnbannableInstance
    case UnusableParent
    case InvalidUnicodeEmoji
    case TooManyRetries
}

/// Discord REST API Client
///
/// Executes API requests to the Discord REST API
///
///     client.execute(.ChannelMessagesCreate(channelId), payload)
public final class DiscordRESTClient {
    /// The worker the requests are executed on
    let eventLoop: EventLoop
    /// The authentication token
    let token: String
    /// Shared URLSession
    let session: URLSession
    
    let rateLimiter: RateLimiter
    
    /// Creates a new REST Client
    init(_ worker: EventLoopGroup, _ token: String) {
        self.eventLoop = worker.next()
        self.token = token
        self.session = URLSession(configuration: .default)
        self.rateLimiter = RateLimiter()
    }
    
    /// Creates a new REST Client
    init(_ eventLoop: EventLoop, _ token: String) {
        self.eventLoop = eventLoop
        self.token = token
        self.session = URLSession(configuration: .default)
        self.rateLimiter = RateLimiter()
    }
    
    /// The base auth headers for requests to the Discord API
    var headers: [String: String] {
        return ["Authorization": "Bot \(token)"]
    }
    
    public func execute<B, Q, R>(_ route: Route<B, Q, R>) -> EventLoopFuture<R> {
        let p = self.eventLoop.makePromise(of: R.self)
        if let interval = self.rateLimiter.check(route) {
            self.eventLoop.scheduleTask(in: .milliseconds(interval)) {
                self._execute(route, p)
            }
        } else {
            self._execute(route, p)
        }
        return p.futureResult
    }
    
    private func _execute<B, Q, R>(_ route: Route<B, Q, R>, _ p: EventLoopPromise<R>) {
        executeAndCascade(p) {
            let urlReq = try URLRequest(url: route.url, method: route.method, headers: self.headers, json: route.body)
            
            return self.session.json(urlReq, logger: self.rateLimiter.logger, on: self.eventLoop).map { (res, r: R) in
                self.rateLimiter.update(route, with: res)
                return r
            }
        }
    }
    
    public func execute<Q, R>(_ route: Route<Empty, Q, R>) -> EventLoopFuture<R> {
        let urlReq = URLRequest(route.url, method: route.method, headers: self.headers)
        let p = self.eventLoop.makePromise(of: R.self)
        
        if let interval = self.rateLimiter.check(route) {
            self.eventLoop.scheduleTask(in: .milliseconds(interval)) {
                self.session.json(urlReq, logger: self.rateLimiter.logger, on: self.eventLoop).map { (res, r: R) in
                    self.rateLimiter.update(route, with: res)
                    return r
                }.cascade(to: p)
            }
        } else {
            session.json(urlReq, logger: self.rateLimiter.logger, on: eventLoop).map { (res, r: R) in
                self.rateLimiter.update(route, with: res)
                return r
            }.cascade(to: p)
        }
        return p.futureResult
    }
}
