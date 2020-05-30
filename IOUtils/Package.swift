// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IOUtils",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .library(
            name: "IOUtils",
            targets: ["IOUtils"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "IOUtils",
            dependencies: []),
        .testTarget(
            name: "IOUtilsTests",
            dependencies: ["IOUtils"]),
    ]
)
