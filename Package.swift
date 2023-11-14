// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftAPIGate",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "SwiftAPIGate",
            targets: ["SwiftAPIGate"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftAPIGate"),
        .testTarget(
            name: "SwiftAPIGateTests",
            dependencies: ["SwiftAPIGate"]
        ),
    ]
)
