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
            url: "https://github.com/SourcePointUSA/ios-cmp-app/releases/download/7.12.7/SPMConsentViewController.xcframework.zip",
            checksum: "09429f25388a7cccd3098266e4d3d5a0d2d981cf9869336e5c1cc4378c490dfd"
        )
    ]
)
