// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "StepByStepTracking",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "StepByStepTracking",
            targets: ["StepByStepTracking"]
        ),
        .library(
            name: "StepByStepTrackingCore",
            targets: ["StepByStepTrackingCore"]
        ),
    ],
    targets: [
        .target(
            name: "StepByStepTrackingCore",
            path: "Sources",
            exclude: [], // exclude files if needed
            sources: nil, // all .swift files under Sources
            publicHeadersPath: nil
        ),
        .target(
            name: "StepByStepTracking",
            dependencies: [
                .target(name: "StepByStepTrackingCore")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
