// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftHooksDiscord",
    products: [
        .library(name: "Discord", targets: ["Discord"]),
    ],
    dependencies: [
        .package(url: "../SwiftHooks", .branch("master")),
    ],
    targets: [
        .target(
            name: "Discord",
            dependencies: ["SwiftHooks"]),
        .testTarget(
            name: "DiscordTests",
            dependencies: ["Discord"]),
    ]
)
