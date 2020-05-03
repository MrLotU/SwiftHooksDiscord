// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftHooksDiscord",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "Discord", targets: ["Discord"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MrLotU/SwiftHooks.git", .branch("master")),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.11.1"),
        .package(url: "https://github.com/apple/swift-nio-zlib-support.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "Discord",
            dependencies: ["SwiftHooks", "WebSocketKit", "NIO", "Logging"]),
        .testTarget(
            name: "DiscordTests",
            dependencies: ["Discord"]),
    ]
)
