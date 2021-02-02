// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "Network", targets: ["Network"]),
        .library(name: "ReactiveNetwork", targets: ["ReactiveNetwork"]),
        .library(name: "RxNetwork", targets: ["RxNetwork"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0")),
        .package(url: "https://github.com/iWECon/Lookup", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: [
                "Lookup", "Moya"
            ]
        ),
        .target(name: "ReactiveNetwork", dependencies: ["Network", "Moya", .product(name: "ReactiveMoya", package: "Moya")]),
        .target(name: "RxNetwork", dependencies: ["Network", "Moya", .product(name: "RxMoya", package: "Moya")]),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network", "Moya", "ReactiveNetwork"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
