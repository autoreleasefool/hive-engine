// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "HiveEngine",
	products: [
		.library(name: "HiveEngine", targets: ["HiveEngine"]),
	],
	dependencies: [],
	targets: [
		.target(name: "HiveEngine", dependencies: []),
		.testTarget(name: "HiveEngineTests", dependencies: ["HiveEngine"]),
	]
)
