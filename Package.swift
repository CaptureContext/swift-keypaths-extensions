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
		),
		.library(
			name: "KeyPathsExtensionsUtils",
			targets: ["KeyPathsExtensionsUtils"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/capturecontext/swift-marker-protocols.git",
			.upToNextMajor(from: "1.1.0")
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
				.target(name: "KeyPathsExtensionsUtils"),
			]
		),
		.target(
			name: "KeyPathsExtensionsUtils",
			dependencies: [
				.product(
					name: "SwiftMarkerProtocols",
					package: "swift-marker-protocols"
				),
			]
		),
		.testTarget(
			name: "KeyPathsExtensionsTests",
			dependencies: ["KeyPathsExtensions"]
		),
	]
)
