// swift-tools-version: 5.10

import PackageDescription

let package = Package(
	name: "swift-keypaths-extensions",
	products: [
		.library(
			name: "KeyPathsExtensions",
			targets: ["KeyPathsExtensions"]
		),
	],
	targets: [
		.target(
			name: "KeyPathsExtensions"
		),
		.testTarget(
			name: "KeyPathsExtensionsTests",
			dependencies: ["KeyPathsExtensions"]
		),
	]
)
