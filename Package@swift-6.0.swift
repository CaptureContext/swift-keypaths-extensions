// swift-tools-version: 6.0

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
			.upToNextMinor(from: "0.0.3")
		),
		.package(
			url: "https://github.com/capturecontext/swift-marker-protocols.git",
			.upToNextMajor(from: "1.5.3")
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
	],
	swiftLanguageModes: [.v6]
)
