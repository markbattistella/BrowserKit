// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "BrowserKit",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .macCatalyst(.v15),
    .visionOS(.v1),
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
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    )
  ],
  swiftLanguageModes: [.v6]
)
