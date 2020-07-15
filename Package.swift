// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CMPTracking",
    products: [
        .library(
            name: "CMPTracking",
            targets: ["ConsentViewController"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ConsentViewController",
            path: "ConsentViewController"
        )
    ]
)
