// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "calday",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(name: "calday", path: "Sources"),
    ]
)
