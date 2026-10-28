// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "VaultHarness",
    targets: [
        .target(name: "FinancistCore"),
        .testTarget(name: "FinancistCoreTests", dependencies: ["FinancistCore"]),
    ]
)
