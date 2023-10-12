// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ConsentViewController",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11)
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
            path: "./XCFramework/SPM/ConsentViewController.xcframework"
        )
    ]
)
