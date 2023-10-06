// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftAPIGate",
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
