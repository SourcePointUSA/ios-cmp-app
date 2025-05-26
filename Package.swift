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
            targets: ["ConsentViewController", "SPMobileCore"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "SPMobileCore",
            path: "./Example/Pods/SPMobileCore/SPMobileCore.xcframework"
        ),
        .binaryTarget(
            name: "ConsentViewController",
            path: "./XCFramework/SPM/ConsentViewController.xcframework"
        )
    ]
)
