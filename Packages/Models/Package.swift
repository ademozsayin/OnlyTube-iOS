// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Models",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Models",
            targets: ["Models"]
        ),
    ],
    targets: [
        .target(
            name: "Models",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: ["Models"]
        ),
    ]
)
