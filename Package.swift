// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObjcImportSorter",
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMajor(from: "0.0.0")),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/kylef/Commander", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "ObjcImportSorter",
            dependencies: ["ObjcImportSorterCore"]),
        .target(
            name: "ObjcImportSorterCore",
            dependencies: ["Rainbow", "Commander", "PathKit"]),
        .testTarget(
            name: "ObjcImportSorterTest",
            dependencies: ["ObjcImportSorterCore"])
    ]
)
