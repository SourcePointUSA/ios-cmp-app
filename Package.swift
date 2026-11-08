// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ConsentViewController",
    platforms: [
        .iOS("15.0"),
        .tvOS("15.0")
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
            url: "https://github.com/SourcePointUSA/ios-cmp-app/releases/download/7.12.11/SPMConsentViewController.xcframework.zip",
            checksum: "ebf52c109ad35ec7da8d348a07c948218992425c40640405e4e59631d5586991"
        )
    ]
)
