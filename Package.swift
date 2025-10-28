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
            url: "https://github.com/SourcePointUSA/ios-cmp-app/releases/download/7.12.7-beta.6/SPMConsentViewController.xcframework.zip",
            checksum: "caae40d7bb31f04062eac6c81aa4f2e149f51d4e3a2a8d4d3e7e0e6d629f7df0"
        )
    ]
)
