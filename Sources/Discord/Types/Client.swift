public protocol DiscordClient {
    var client: DiscordRESTClient { get }
    var state: State { get }
}

extension DiscordHook: DiscordClient { }
