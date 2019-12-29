import NIO
import Foundation

/// Custom URLSession errors
enum URLSessionFutureError: Error {
    case networkError(Error)
    case invalidResponse
}

/// HTTP Methods
enum HTTPMethod: String {
    case GET, POST, PATCH, DELETE, PUT, HEAD
}

extension URLSession {
    /// Get raw data from given URLRequest
    ///
    /// - parameters:
    ///     - request: URLRequest to execute
    ///     - eventLoop: EventLoop to execute on
    ///
    /// - returns: A future HTTPURLResponse and the Data
    func data(
        _ request: URLRequest,
        on eventLoop: EventLoop) -> EventLoopFuture<(HTTPURLResponse, Data)>
    {
        let promise = eventLoop.makePromise(of: (HTTPURLResponse, Data).self)
        
        let task = self.dataTask(with: request) { data, response, error in
            if let error = error {
                promise.fail(URLSessionFutureError.networkError(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                promise.fail(URLSessionFutureError.invalidResponse)
                return
            }
            promise.succeed((response, data ?? Data()))
        }
        
        task.resume()
        return promise.futureResult
    }
    
    /// Get a decodable from given URLRequest
    ///
    /// - parameters:
    ///     - request: URLRequest to execute
    ///     - type: Type to decode to
    ///     - decoder: Decoder to decode data with
    ///     - eventLoop: EventLoop to execute on
    ///
    /// - returns: A future HTTPURLResponse and the Decoded object
    func json<T: Decodable>(
        _ request: URLRequest,
        type: T.Type = T.self,
        decoder: JSONDecoder = JSONDecoder(),
        on eventLoop: EventLoop) -> EventLoopFuture<(HTTPURLResponse, T)>
    {
        return data(request, on: eventLoop)
            .flatMapThrowing { ($0.0, try decoder.decode(type, from: $0.1)) }
    }
    
    /// Get a decodable from given URLRequest
    ///
    /// - parameters:
    ///     - request: URLRequest to execute
    ///     - type: Type to decode to
    ///     - decoder: Decoder to decode data with
    ///     - eventLoop: EventLoop to execute on
    ///
    /// - returns: A future Decoded object
    func jsonBody<T: Decodable>(
        _ request: URLRequest,
        type: T.Type = T.self,
        decoder: JSONDecoder = JSONDecoder(),
        on eventLoop: EventLoop) -> EventLoopFuture<T>
    {
        return json(request, type: type, decoder: decoder, on: eventLoop)
            .map { $0.1 }
    }
}

extension URLRequest {
    /// Create a new URLRequest with a body
    init<T: Encodable>(
        url: URL,
        method: HTTPMethod = .POST,
        headers: [String: String] = [:],
        json body: T,
        encoder: JSONEncoder = JSONEncoder()) throws
    {
        self.init(url: url)
        
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers.forEach { header, value in
            setValue(value, forHTTPHeaderField: header)
        }
        
        httpMethod = method.rawValue
        httpBody = try encoder.encode(body)
    }
    
    /// Create a new URLRequest with URL and Method
    init(_ url: URL, method: HTTPMethod = .GET, headers: [String: String] = [:]) {
        self.init(url: url)
        
        headers.forEach { (header, value) in
            setValue(value, forHTTPHeaderField: header)
        }
        
        httpMethod = method.rawValue
    }
}
