// swift-tools-version:5.7
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
      targets: ["ConsentViewController"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "ConsentViewController",
      dependencies: [],
      path: "ConsentViewController",
      exclude: [
        "Assets/javascript/SPJSReceiver.spec.js",
        "Assets/javascript/jest.config.json"
      ],
      resources: [
        .process("Assets/javascript/SPJSReceiver.js"),
        .process("Assets/images")
      ]
    )
  ],
  swiftLanguageVersions: [.v5]
)
