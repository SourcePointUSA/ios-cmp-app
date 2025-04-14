// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "ConsentViewController",
  platforms: [
    .iOS(.v10),
    .tvOS(.v10)
  ],
  products: [
    .library(name: "ConsentViewController", targets: ["ConsentViewController"]),
    .library(name: "ConsentViewControllerTvOS", targets: ["ConsentViewControllerTvOS"]),
  ],
  dependencies: [
    .package(url: "https://github.com/SourcePointUSA/mobile-core.git", branch: "add_spm_integration")
  ],
  targets: [
    .target(
      name: "ConsentViewController",
      dependencies: [
        .product(name: "SPMobileCore", package: "mobile-core")
      ],
      path: "ConsentViewController",
      exclude: [
        "Assets/javascript/SPJSReceiver.spec.js",
        "Assets/javascript/jest.config.json",
        "Classes/Views/tvOS"
      ],
      resources: [
        .process("Assets/javascript/SPJSReceiver.js"),
        .process("Assets/images")
      ]
    ),
    .target(
      name: "ConsentViewControllerTvOS",
      dependencies: ["ConsentViewControllerShared"],
      path: "ConsentViewController/Classes/Views/tvOS"
    )
  ],
)


