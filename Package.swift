// swift-tools-version:5.8
import PackageDescription

let package = Package(name: "ShLocalPostgres",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "ShLocalPostgres", targets: ["ShLocalPostgres"]),

  ],
  dependencies: [
    .package(url: "https://github.com/DanielSincere/Sh", from: "1.3.0"),
  ],
  targets: [
    .target(
      name: "ShLocalPostgres",
      dependencies: ["Sh"]),
  ]
)
