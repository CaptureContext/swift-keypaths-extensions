// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "swift-keypaths-extensions",
	products: [
		.library(
			name: "KeyPathsExtensions",
			targets: ["KeyPathsExtensions"]
		)
	],
	dependencies: [
		.package(
			url: "https://github.com/capturecontext/swift-keypath-mapping.git",
			.upToNextMajor(from: "0.0.1")
		),
		.package(
			url: "https://github.com/capturecontext/swift-marker-protocols.git",
			.upToNextMajor(from: "1.5.1")
		),
	],
	targets: [
		.target(
			name: "KeyPathsExtensions",
			dependencies: [
				.product(
					name: "KeyPathMapping",
					package: "swift-keypath-mapping"
				),
				.product(
					name: "SwiftMarkerProtocols",
					package: "swift-marker-protocols"
				),
			]
		),
		.testTarget(
			name: "KeyPathsExtensionsTests",
			dependencies: ["KeyPathsExtensions"]
		)
	]
)
