// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "swift-rlp",
    dependencies: [
      .Package(url: "https://github.com/lorentey/BigInt.git", majorVersion: 2, minor: 1)
    ]
)
