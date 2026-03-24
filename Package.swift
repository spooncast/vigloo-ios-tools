// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VIGTools",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LifeTracker", targets: ["LifeTracker"])
    ],
    targets: [
        .target(name: "LifeTracker")
    ]
)
