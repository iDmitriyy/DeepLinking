// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "deep-linking",
  products: [
    .library(name: "DeepLinking", targets: ["DeepLinking"]),
  ],
  targets: [
    .target(name: "DeepLinking"),
    .testTarget(name: "DeepLinkingTests", dependencies: ["DeepLinking"]),
  ]
)
