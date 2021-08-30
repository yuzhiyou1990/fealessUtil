// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FearlessUtils",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FearlessUtils",
            targets: ["FearlessUtils"]),
    ],
    dependencies: [
        .package(name: "BigInt", url: "https://github.com/attaswift/BigInt.git", from: "5.2.1"),
        .package(name: "TweetNacl", url: "https://github.com/bitmark-inc/tweetnacl-swiftwrap", from: "1.0.2"),
        .package(name: "xxHash-Swift", url: "https://github.com/daisuke-t-jp/xxHash-Swift", from: "1.1.0"),
        .package(name: "SS58Factory", url: "https://github.com/lishuailibertine/SS58Factory", from: "0.0.8"),
        .package(name: "scrypt", url: "https://github.com/v57/scrypt.c", from: "0.1.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FearlessUtils",
            dependencies: ["BigInt","TweetNacl","xxHash-Swift","SS58Factory","scrypt"]),
        .testTarget(
            name: "fealessUtilTests",
            dependencies: ["FearlessUtils"]),
    ]
)