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
    
    public init(title: String? = nil, type: EmbedType? = nil, description: String? = nil, url: String? = nil, timestamp: String? = nil, color: Int? = nil, footer: EmbedFooter? = nil, image: EmbedImage? = nil, thumbnail: EmbedThumbnail? = nil, video: EmbedVideo? = nil, provider: EmbedProvider? = nil, author: EmbedAuthor? = nil, fields: [EmbedField]? = nil) {
        self.title = title
        self.type = type
        self.description = description
        self.url = url
        self.timestamp = timestamp
        self.color = color
        self.footer = footer
        self.image = image
        self.thumbnail = thumbnail
        self.video = video
        self.provider = provider
        self.author = author
        self.fields = fields
    }
}

public enum EmbedType: String, Codable {
    case rich, image, video, gifv, article, link
}

public struct EmbedThumbnail: Codable {
    public init(url: String? = nil, proxy_url: String? = nil, height: Int? = nil, width: Int? = nil) {
        self.url = url
        self.proxy_url = proxy_url
        self.height = height
        self.width = width
    }
    
    public let url: String?
    public let proxy_url: String?
    public let height: Int?
    public let width: Int?
}

public struct EmbedVideo: Codable {
    public init(url: String? = nil, height: Int? = nil, width: Int? = nil) {
        self.url = url
        self.height = height
        self.width = width
    }
    
    public let url: String?
    public let height: Int?
    public let width: Int?
}

public struct EmbedImage: Codable {
    public init(url: String? = nil, proxy_url: String? = nil, height: Int? = nil, width: Int? = nil) {
        self.url = url
        self.proxy_url = proxy_url
        self.height = height
        self.width = width
    }
    
    public let url: String?
    public let proxy_url: String?
    public let height: Int?
    public let width: Int?
}

public struct EmbedProvider: Codable {
    public init(name: String? = nil, url: String? = nil) {
        self.name = name
        self.url = url
    }
    
    public let name: String?
    public let url: String?
}

public struct EmbedAuthor: Codable {
    public init(name: String? = nil, url: String? = nil, icon_url: String? = nil, proxy_icon_url: String? = nil) {
        self.name = name
        self.url = url
        self.icon_url = icon_url
        self.proxy_icon_url = proxy_icon_url
    }
    
    public let name: String?
    public let url: String?
    public let icon_url: String?
    public let proxy_icon_url: String?
}

public struct EmbedFooter: Codable {
    public init(text: String, icon_url: String? = nil, proxy_icon_url: String? = nil) {
        self.text = text
        self.icon_url = icon_url
        self.proxy_icon_url = proxy_icon_url
    }
    
    public let text: String
    public let icon_url: String?
    public let proxy_icon_url: String?
}

public struct EmbedField: Codable {
    public init(name: String, value: String, inline: Bool? = nil) {
        self.name = name
        self.value = value
        self.inline = inline
    }
    
    public let name: String
    public let value: String
    public let inline: Bool?
}
