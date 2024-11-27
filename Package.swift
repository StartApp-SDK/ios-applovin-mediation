// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StartioApplovinMediation",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "StartioApplovinMediation",
            targets: ["StartioApplovinMediation"])
    ],
    dependencies: [
        .appLovin,
        .startApp
    ],
    targets: [
        .target(
            name: "StartioApplovinMediation",
            dependencies: [
                .StartApp,
                .AppLovinSDK,
            ],
            path: "StartioApplovinMediation",
            publicHeadersPath: ""
        )
    ]
)

extension Package.Dependency {
    static let appLovin: Package.Dependency = .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git", Version(12,0,0)..<Version(14,0,0))
    static let startApp: Package.Dependency = .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage.git", from: Version(4,10,5))
}

extension Target.Dependency {
    static let AppLovinSDK: Target.Dependency = .product(name: "AppLovinSDK", package: "AppLovin-MAX-Swift-Package")
    static let StartApp: Target.Dependency = .product(name: "StartApp", package: "StartAppSDK-SwiftPackage")
}
