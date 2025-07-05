// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UMLSClientModel",
  platforms: [.iOS(.v13), .macOS(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to
    // other packages.
    .library(
      name: "UMLSClientModel",
      targets: ["UMLSClientModel"]),
    .library(name: "Random", targets: ["Random"]),
    .library(name: "VaporSupport", targets: ["VaporSupport"]),
  ],
  dependencies: [
    .package(url: "https://github.com/karwa/swift-url", .upToNextMinor(from: "0.4.0")),
    .package(url: "https://github.com/vapor/vapor.git", from: "4.110.1"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "UMLSClientModel", dependencies: [.product(name: "WebURL", package: "swift-url")]),
    .target(
      name: "Random",
      dependencies: [.product(name: "WebURL", package: "swift-url"), "UMLSClientModel"]),
    .target(
      name: "VaporSupport",
      dependencies: [.product(name: "Vapor", package: "vapor"), "UMLSClientModel"]),
    .testTarget(
      name: "UMLSClientModelTests",
      dependencies: [
        "UMLSClientModel", "Random", "VaporSupport", .product(name: "WebURL", package: "swift-url"),
      ]
    ),
  ]
)
