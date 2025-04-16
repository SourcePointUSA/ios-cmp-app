// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "ConsentViewController",
  platforms: [
    .iOS(.v10),
    .tvOS(.v10)
  ],
  products: [
    .library(name: "ConsentViewController", targets: ["ConsentViewController"]),
  ],
  dependencies: [
    .package(url: "https://github.com/SourcePointUSA/mobile-core.git", branch: "add_spm_integration"),
    .package(url: "https://github.com/johnxnguyen/Down.git", .exact("0.11.0")),
  ],
  targets: [
    .target(
      name: "ConsentViewController",
      dependencies: [
        "ConsentViewControllerCore",
        .target(name: "ConsentViewControllerTvOS", condition: .when(platforms: [.tvOS])),
      ],
      path: "Wrapper"
    ),
    .target(
      name: "ConsentViewControllerCore",
      dependencies: [
        .product(name: "SPMobileCore", package: "mobile-core"),
        .product(name: "Down", package: "down", condition: .when(platforms: [.tvOS])),
      ],
      path: "ConsentViewController",
      exclude: [
        "Assets/javascript/SPJSReceiver.spec.js",
        "Assets/javascript/jest.config.json",
        "Classes/Views/tvOS/tvOSTarget"
      ],
      resources: [
        .process("Assets/javascript/SPJSReceiver.js"),
        .process("Assets/images")
      ]
    ),
    .target(
      name: "ConsentViewControllerTvOS",
      dependencies: ["ConsentViewControllerCore"],
      path: "ConsentViewController/Classes/Views/tvOS/tvOSTarget",
      resources: [.process("Xibs")]
    )
  ],
)
