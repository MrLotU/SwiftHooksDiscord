import NIO
import Foundation

public enum DiscordRestError: Error {
    case InvalidPermissions
    case MessageNeedsContent
    case UnbannableInstance
    case UnusableParent
}

/// Discord REST API Client
///
/// Executes API requests to the Discord REST API
///
///     client.execute(.ChannelMessagesCreate(channelId), payload)
public final class DiscordRESTClient {
    /// The worker the requests are executed on
    let worker: EventLoopGroup
    /// The authentication token
    let token: String
    /// Shared URLSession
    let session: URLSession
    
    /// Creates a new REST Client
    init(_ worker: EventLoopGroup, _ token: String) {
        self.worker = worker
        self.token = token
        self.session = URLSession(configuration: .default)
    }
    
    private var eventLoop: EventLoop {
        return worker.next()
    }
    
    /// The base auth headers for requests to the Discord API
    var headers: [String: String] {
        return ["Authorization": "Bot \(token)"]
    }
    
    /// Executes a route without body
    ///
    ///     let data = client.execute(.GatewayBotGet)
    ///
    /// - parameters:
    ///     - route: Route to execute
    ///
    /// - returns: A future R
    public func execute<R>(_ route: Route) -> EventLoopFuture<R> where R: Decodable {
        let urlReq = URLRequest(route.url, method: route.method, headers: headers)
        
        return session.jsonBody(urlReq, type: R.self, on: eventLoop)
    }
    
    /// Executes a route with a body
    ///
    ///     let message = client.execute(.ChannelMessagesCreate(channelId), MessageCreatePayload(...))
    ///
    /// - parameters:
    ///     - route: Route to execute
    ///     - body: Body to send
    ///
    /// - returns: A future R
    public func execute<B, R>(_ route: Route, _ body: B) -> EventLoopFuture<R> where B: Encodable, R: Decodable {
        do {
            let urlReq = try URLRequest(url: route.url, method: route.method, headers: headers, json: body)
            
            return session.jsonBody(urlReq, type: R.self, on: eventLoop)
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    /// Executes a route without body and an empty response
    ///
    ///     client.execute(.UserGuildLeave(guildId))
    ///
    /// - parameters:
    ///     - route: Route to execute
    ///
    /// - returns: Discardable EventLoopFuture<Empty>
    @discardableResult
    public func execute(_ route: Route) -> EventLoopFuture<Empty> {
        let urlReq = URLRequest(route.url, method: route.method, headers: headers)
        
        return session.jsonBody(urlReq, type: Empty.self, on: eventLoop)
    }
    
    /// Executes a route with a body and an empty response
    ///
    ///     client.execute(.ChannelMessagesCreate(channelId), MessageCreatePayload(...))
    ///
    /// - parameters:
    ///     - route: Route to execute
    ///     - body: Body to send
    ///
    /// - returns: Discardable EventLoopFuture<Empty>
    @discardableResult
    public func execute<B>(_ route: Route, _ body: B) -> EventLoopFuture<Empty> where B: Encodable {
        do {
            let urlReq = try URLRequest(url: route.url, method: route.method, headers: headers, json: body)
            
            return session.jsonBody(urlReq, type: Empty.self, on: eventLoop)
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
}
