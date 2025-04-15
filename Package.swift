// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "deep-linking",
  products: [
    .library(name: "DeepLinking", targets: ["DeepLinking"]),
  ],
  dependencies: [
    .package(url: "https://github.com/iDmitriyy/SwiftyKit.git", branch: "main")
  ],
  targets: [
    .target(name: "DeepLinking", dependencies: [.product(name: "SwiftyKit", package: "SwiftyKit")]),
    .testTarget(name: "DeepLinkingTests", dependencies: ["DeepLinking"]),
  ]
)

for target: PackageDescription.Target in package.targets {
  {
    var settings: [PackageDescription.SwiftSetting] = $0 ?? []
    settings.append(.enableUpcomingFeature("InternalImportsByDefault"))
    $0 = settings
  }(&target.swiftSettings)
}
