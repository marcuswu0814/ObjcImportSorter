// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObjcImportSorter",
    dependencies: [
        .package(url: "https://github.com/marcuswu0814/SwiftCLIToolbox", .branch("master"))
    ],
    targets: [
        .target(
            name: "ObjcImportSorter",
            dependencies: ["ObjcImportSorterCore"]),
        .target(
            name: "ObjcImportSorterCore",
            dependencies: ["SwiftCLIToolbox"]),
        .testTarget(
            name: "ObjcImportSorterTest",
            dependencies: ["ObjcImportSorterCore"])
    ]
)
