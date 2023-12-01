// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "HandyRouter",
  platforms: [
    .iOS(.v13), .macOS(.v12)
  ],
  products: [
    .library(name: "HandyRouter", targets: ["HandyRouter"]),
  ],
  targets: [
    .target(name: "HandyRouter"),
    .testTarget(name: "HandyRouterTests", dependencies: ["HandyRouter"])
  ]
)
