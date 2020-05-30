// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CFF",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .library(
            name: "CFF",
            targets: ["CFF"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../IOUtils")
    ],
    targets: [
        .target(
            name: "CFF",
            dependencies: ["IOUtils"]),
        .testTarget(
            name: "CFFTests",
            dependencies: ["CFF"]),
    ]
)
