public protocol DiscordClient {
    var client: DiscordRESTClient { get }
}

extension DiscordHook: DiscordClient { }
