// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftHooksDiscord",
    platforms: [
       .macOS(.v10_14)
    ],
    products: [
        .library(name: "Discord", targets: ["Discord"]),
    ],
    dependencies: [
        .package(path: "../SwiftHooks"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.11.1"),
        .package(url: "https://github.com/apple/swift-nio-zlib-support.git", from: "1.0.0"),
        .package(path: "../../websocket-kit")
    ],
    targets: [
        .target(
            name: "Discord",
            dependencies: ["SwiftHooks", "WebSocketKit", "NIO"]),
        .testTarget(
            name: "DiscordTests",
            dependencies: ["Discord"]),
    ]
)
