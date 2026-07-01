// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ReorderableDemo",
    platforms: [
        .iOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(name: "ReorderableDemo", targets: ["ReorderableDemo"])
    ],
    targets: [
        .target(
            name: "ReorderableDemo",
            path: "Sources/ReorderableDemo"
        ),
        .testTarget(
            name: "ReorderableDemoTests",
            dependencies: ["ReorderableDemo"],
            path: "Tests/ReorderableDemoTests"
        )
    ]
)
