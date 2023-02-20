// swift-tools-version:5.7
import PackageDescription

let package = Package(name: "ShLocalPostgres",
  platforms: [.macOS(.v12)],
  products: [
    .library(name: "ShLocalPostgres", targets: ["ShLocalPostgres"]),

  ],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/Sh", from: "1.2.0"),
  ],
  targets: [
    .target(
      name: "ShLocalPostgres",
      dependencies: ["Sh"]),
    .testTarget(
      name: "ShLocalPostgresTests",
      dependencies: ["ShLocalPostgres"]),
  ]
)
