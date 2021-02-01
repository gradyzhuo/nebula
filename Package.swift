// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nebula",
    platforms: [
        .macOS("10.13")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Nebula",
            targets: ["Nebula"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.24.0"),
        .package(name:"SwiftProtobuf", url: "https://github.com/apple/swift-protobuf.git", from: "1.14.0"),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.4.0"),
        .package(url: "https://github.com/wickwirew/Runtime.git", from: "2.2.2"),
        .package(url: "https://github.com/pvieito/PythonKit.git", .branch("master")),
        .package(url: "https://github.com/apple/swift-nio-extras.git", from: "1.4.0")
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Nebula",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "SwiftProtobuf", package: "SwiftProtobuf"),
                .product(name: "AnyCodable", package: "AnyCodable"),
                .product(name: "Runtime", package: "Runtime"),
                .product(name: "NIOExtras", package: "swift-nio-extras")
            ]),
        .testTarget(
            name: "NebulaTests",
            dependencies: ["Nebula"]),
        .target(
            name: "GalaxyServer",
            dependencies: ["Nebula"],
            path: "Sources/Demo/Server/Galaxy"),
        .target(
            name: "AmasServer",
            dependencies: ["Nebula"],
            path: "Sources/Demo/Server/Amas"),
        .target(
            name: "StellaireServer",
            dependencies: ["Nebula"],
            path: "Sources/Demo/Server/Stellar"),
        .target(
            name: "Servers",
            dependencies: ["Nebula"],
            path: "Sources/Demo/Server/Combine"),
        .target(
            name: "AmasClient",
            dependencies: ["Nebula"],
            path: "Sources/Demo/Client/Amas"),
        .target(
            name: "GalaxyClient",
            dependencies: ["Nebula"],
            path: "Sources/Demo/Client/Galaxy"),
        .target(
            name: "StellaireClient",
            dependencies: ["Nebula"],
            path: "Sources/Demo/Client/Stellar"),
        .target(
            name: "PlanetClient",
            dependencies: ["Nebula"],
            path: "Sources/Demo/Planet"),
        .target(
            name: "Playground",
            dependencies: ["AnyCodable", "Nebula", "Runtime"],
            path: "Sources/Playground"),
    ]
)

