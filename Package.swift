// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "swift-rlp",
    dependencies: [
      .package(url: "https://github.com/lorentey/BigInt.git", from: "1.0.0")
    ]
)
