// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ConsentViewController",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10)
    ],
    products: [
        .library(
            name: "ConsentViewController",
            targets: ["ConsentViewController"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "ConsentViewController",
            // path: "./build/SPMConsentViewController.xcframework" <-- use for local development
            url: "https://github.com/SourcePointUSA/ios-cmp-app/releases/download/7.12.10/SPMConsentViewController.xcframework.zip",
            checksum: "14f8cc2e129022591ffbb17808649c40eb3e8359d2d75fb46c53f8715d5980a9"
        )
    ]
)
