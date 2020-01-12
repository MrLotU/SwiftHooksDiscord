import NIO

public protocol DiscordClient {
    var client: DiscordRESTClient { get }
    var state: State { get }
    // TODO: Make this nicer. Ugly way like this. Probably want to pass it down with the event.
    var eventLoop: EventLoop { get }
}

extension DiscordHook: DiscordClient {
    public var eventLoop: EventLoop {
        return eventLoopGroup.next()
    }
}
