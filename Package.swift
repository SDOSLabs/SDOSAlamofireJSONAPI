// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SDOSAlamofireJSONAPI",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "SDOSAlamofireJSONAPI",
            targets: ["SDOSAlamofireJSONAPI"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDOSLabs/Japx.git", .upToNextMajor(from: "3.1.0")),
        .package(url: "https://github.com/SDOSLabs/SDOSAlamofire.git", .upToNextMajor(from: "2.0.0")),
        
    ],
    targets: [
        .target(
            name: "SDOSAlamofireJSONAPI",
            dependencies: [
                "SDOSAlamofire",
                .product(name: "JapxCodable", package: "Japx")
            ],
            path: "src/Classes/JSONAPI")
        
    ]
)
