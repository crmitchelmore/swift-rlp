// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "swift-rlp",
    products: [
        .library(name: "swift-rlp", targets: ["swift-rlp"])
    ],
    dependencies: [
      	.package(url: "https://github.com/crmitchelmore/BigInt.git", from: "3.0.0"),
    ],
   	targets: [
    	.target(name: "swift-rlp", dependencies: ["BigInt"], path: "Sources"),
  	]
)