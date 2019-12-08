// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftHooksDiscord",
    products: [
        .library(name: "Discord", targets: ["Discord"]),
    ],
    dependencies: [
        .package(path: "../SwiftHooks"),
        .package(url: "https://github.com/apple/swift-nio-zlib-support", from: "1.0.0"),
        .package(path: "../../websocket-kit")
    ],
    targets: [
        .target(
            name: "Discord",
            dependencies: ["SwiftHooks", "WebSocketKit"]),
        .testTarget(
            name: "DiscordTests",
            dependencies: ["Discord"]),
    ]
)
