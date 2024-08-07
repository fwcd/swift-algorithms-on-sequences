// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlgorithmsOnSequences",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AlgorithmsOnSequences",
            targets: ["AlgorithmsOnSequences"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.2"),
        .package(url: "https://github.com/Kuniwak/MirrorDiffKit.git", from: "5.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AlgorithmsOnSequences",
            dependencies: []
        ),
        .executableTarget(
            name: "AlgorithmsOnSequencesBenchmarks",
            dependencies: [
                .target(name: "AlgorithmsOnSequences"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "AlgorithmsOnSequencesTests",
            dependencies: [
                .target(name: "AlgorithmsOnSequences"),
                .product(name: "MirrorDiffKit", package: "MirrorDiffKit"),
            ],
            resources: [
                .copy("Resources"),
            ]
        ),
    ]
)
