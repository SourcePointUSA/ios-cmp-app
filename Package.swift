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
            targets: ["ConsentViewControllerWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SourcePointUSA/mobile-core.git", branch: "add_spm_integration")
    ],
    targets: [
        .binaryTarget(
            name: "ConsentViewController",
            path: "./XCFramework/SPM/ConsentViewController.xcframework"
        ),
        .target(
            name: "ConsentViewControllerWrapper",
            dependencies: [
                "ConsentViewController",
                .product(name: "SPMobileCore", package: "SPMobileCore")
            ]
        )
    ]
)
