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
      targets: ["ConsentViewController"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "ConsentViewController",
      dependencies: [
        .target(name: "ConsentViewController-tvOS", condition: .when(platforms: [.tvOS]))
      ],
      path: "ConsentViewController",
      exclude: [
        "Assets/javascript/SPJSReceiver.spec.js",
        "Assets/javascript/jest.config.json",
        "Classes/Views/tvOS/NativePrivacyManager/xibs"
      ],
      resources: [
        .process("Assets/javascript/SPJSReceiver.js"),
        .process("Assets/images")
      ]
    ),
    .target(
      name: "ConsentViewController-tvOS",
      dependencies: [],
      path: "ConsentViewController/Classes/Views/tvOS/NativePrivacyManager/xibs",
      exclude: [],
      resources: [
        .process("./"),
      ]
    )
  ],
  swiftLanguageVersions: [.v5]
)
