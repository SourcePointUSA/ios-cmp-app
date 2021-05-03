// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "ConsentViewController",
  platforms: [
    .iOS(.v10)
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
        "Assets/javascript/GDPRJSReceiver.spec.js",
        "Assets/javascript/jest.config.json",
      ],
      resources: [
        .copy("Assets/javascript/GDPRJSReceiver.js")
      ]
    )
  ],
  swiftLanguageVersions: [.v5]
)
