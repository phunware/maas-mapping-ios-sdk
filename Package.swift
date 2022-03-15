// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "PWMapKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PWMapKit",
            targets: ["PWMapKitTargets"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name:"PWCore", url:"https://github.com/phunware/maas-core-ios-sdk.git", .exact("3.12.0")),
        .package(name:"PWLocation", url:"https://github.com/phunware/maas-location-ios-sdk.git", .exact("3.12.0-beta.4"))
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
                "PWLocation",
                .product(name: "PWCore", package: "PWCore", condition: nil),
                .product(name: "DeviceIdentity", package: "PWCore", condition: nil)
            ],
            path: "PWMapKitTargets"
        )
    ]
)
