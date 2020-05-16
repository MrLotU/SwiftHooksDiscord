import NIO

public protocol DiscordClient {
    var rest: DiscordRESTClient { get }
    var state: State { get }
    var options: DiscordHookOptions { get }
    var eventLoop: EventLoop { get }
}

struct _DiscordClient: DiscordClient {
    var state: State {
        h.state
    }
    var options: DiscordHookOptions {
        h.options
    }
    let rest: DiscordRESTClient
    let eventLoop: EventLoop
    
    private let h: DiscordHook
    
    internal init(_ h: DiscordHook, eventLoop: EventLoop) {
        self.h = h
        self.rest = .init(eventLoop, h.options.token)
        self.eventLoop = eventLoop
    }
}
