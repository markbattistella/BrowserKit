// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "BrowserKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .macCatalyst(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "BrowserKit",
            targets: ["BrowserKit"]
        )
    ],
    targets: [
        .target(
            name: "BrowserKit",
            dependencies: [],
            exclude: [],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
)
