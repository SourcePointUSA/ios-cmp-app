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
            url: "https://github.com/SourcePointUSA/ios-cmp-app/releases/download/7.12.7-rc.2/SPMConsentViewController.xcframework.zip",
            checksum: "3cc0a0192dd177d79c2efdee41853ae1d2132025c8c057848e4c334815e8a859"
        )
    ]
)
