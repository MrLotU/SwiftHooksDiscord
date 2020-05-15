public struct Embed: Codable {
    public let title: String?
    public let type: EmbedType?
    public let description: String?
    public let url: String?
    public let timestamp: String?
    public let color: Int?
    public let footer: EmbedFooter?
    public let image: EmbedImage?
    public let thumbnail: EmbedThumbnail?
    public let video: EmbedVideo?
    public let provider: EmbedProvider?
    public let author: EmbedAuthor?
    public let fields: [EmbedField]?
}

public enum EmbedType: String, Codable {
    case rich, image, video, gifv, article, link
}

public struct EmbedThumbnail: Codable {
    public let url: String?
    public let proxy_url: String?
    public let height: Int?
    public let width: Int?
}

public struct EmbedVideo: Codable {
    public let url: String?
    public let height: Int?
    public let width: Int?
}

public struct EmbedImage: Codable {
    public let url: String?
    public let proxy_url: String?
    public let height: Int?
    public let width: Int?
}

public struct EmbedProvider: Codable {
    public let name: String?
    public let url: String?
}

public struct EmbedAuthor: Codable {
    public let name: String?
    public let url: String?
    public let icon_url: String?
    public let proxy_icon_url: String?
}

public struct EmbedFooter: Codable {
    public let text: String
    public let icon_url: String?
    public let proxy_icon_url: String?
}

public struct EmbedField: Codable {
    public let name: String
    public let value: String
    public let inline: Bool?
}
