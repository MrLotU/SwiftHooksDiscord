import NIO
import Foundation

public enum DiscordRestError: Error {
    case InvalidPermissions
    case NotAGuild
    case MessageNeedsContent
    case UnbannableInstance
    case UnusableParent
    case InvalidUnicodeEmoji
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
    
    /// Creates a new REST Client
    init(_ worker: EventLoopGroup, _ token: String) {
        self.eventLoop = worker.next()
        self.token = token
        self.session = URLSession(configuration: .default)
    }
    
    /// Creates a new REST Client
    init(_ eventLoop: EventLoop, _ token: String) {
        self.eventLoop = eventLoop
        self.token = token
        self.session = URLSession(configuration: .default)
    }
    
    /// The base auth headers for requests to the Discord API
    var headers: [String: String] {
        return ["Authorization": "Bot \(token)"]
    }
    
    public func execute<B, Q, R>(_ route: Route<B, Q, R>) -> EventLoopFuture<R> {
        let p = self.eventLoop.makePromise(of: R.self)
        return executeAndCascade(p) {
            let urlReq = try URLRequest(url: route.url, method: route.method, headers: self.headers, json: route.body)
            
            return self.session.jsonBody(urlReq, on: self.eventLoop)
        }
    }
    
    public func execute<Q, R>(_ route: Route<Empty, Q, R>) -> EventLoopFuture<R> {
        let urlReq = URLRequest(route.url, method: route.method, headers: self.headers)
        
        return session.jsonBody(urlReq, on: eventLoop)
    }
}
