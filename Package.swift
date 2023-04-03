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
      targets: ["ConsentViewController-shared"]),
    .library(
      name: "ConsentViewController-tvOS",
      targets: ["ConsentViewController-tvOS"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "ConsentViewController-shared",
      dependencies: [],
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
      dependencies: [
        .target(name: "ConsentViewController-shared")
      ],
      path: "ConsentViewController/Classes/Views/tvOS/NativePrivacyManager/xibs",
      exclude: [],
      resources: []
    )
  ],
  swiftLanguageVersions: [.v5]
)
