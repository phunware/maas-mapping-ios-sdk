// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PWMapKit",
    platforms: [
        .iOS("15.5")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PWMapKit",
            targets: ["PWMapKitTargets"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/phunware/maas-core-ios-sdk.git", from: "3.13.0"),
        .package(url: "https://github.com/phunware/maas-location-ios-sdk.git", from: "3.14.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        .binaryTarget(
            name: "PWMapKit",
            path: "FrameworksStaticLinks/PWMapKit.xcframework"
        ),
        .target(name: "PWMapKitTargets",
            dependencies:[
                .target(name: "PWMapKit"),
                .product(name: "PWLocation", package: "maas-location-ios-sdk", condition: nil),
                .product(name: "PWCore", package: "maas-core-ios-sdk", condition: nil),
                .product(name: "DeviceIdentity", package: "maas-core-ios-sdk", condition: nil)
            ],
            path: "PWMapKitTargets"
        )
    ]
)
