// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "HiveEngine",
	products: [
		.library(name: "HiveEngine", targets: ["HiveEngine"]),
	],
	dependencies: [
		.package(url: "https://github.com/sharplet/Regex.git", from: "2.1.0"),
	],
	targets: [
		.target(name: "HiveEngine", dependencies: ["Regex"]),
		.testTarget(name: "HiveEngineTests", dependencies: ["HiveEngine"]),
	]
)
