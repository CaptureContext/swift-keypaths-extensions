// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "swift-keypaths-extensions",
	products: [
		.library(
			name: "KeyPathsExtensions",
			targets: ["KeyPathsExtensions"]
		),
		.library(
			name: "KeyPathMapper",
			targets: ["KeyPathMapper"]
		)
	],
	dependencies: [
		.package(
			url: "https://github.com/capturecontext/swift-hashed.git",
			.upToNextMajor(from: "0.0.1")
		),
		.package(
			url: "https://github.com/capturecontext/swift-marker-protocols.git",
			.upToNextMajor(from: "1.2.0")
		),
	],
	targets: [
		.target(
			name: "KeyPathsExtensions",
			dependencies: [
				.target(name: "KeyPathMapper"),
			]
		),
		.target(
			name: "KeyPathMapper",
			dependencies: [
				.product(
					name: "SwiftMarkerProtocols",
					package: "swift-marker-protocols"
				),
				.product(
					name: "Hashed",
					package: "swift-hashed"
				),
			]
		),
		.testTarget(
			name: "KeyPathMapperTests",
			dependencies: ["KeyPathMapper"]
		),
		.testTarget(
			name: "KeyPathsExtensionsTests",
			dependencies: ["KeyPathsExtensions"]
		)
	],
	swiftLanguageModes: [.v6]
)
