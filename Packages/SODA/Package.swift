// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SODA",
	platforms: [.iOS(.v15), .tvOS(.v15), .macOS(.v12), .watchOS(.v8), .macCatalyst(.v15)],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "SODA",
			targets: ["SODA"]
		),
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/wmalloc/WebService.git", .upToNextMajor(from: "0.5.0")),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "SODA",
			dependencies: ["WebService",
			               .product(name: "WebServiceConcurrency", package: "WebService"),
			               .product(name: "WebServiceCombine", package: "WebService")]
		),
		.testTarget(
			name: "SODATests",
			dependencies: ["SODA", "WebService",
			               .product(name: "WebServiceConcurrency", package: "WebService"),
			               .product(name: "WebServiceCombine", package: "WebService"),
			               .product(name: "WebServiceURLMock", package: "WebService")],
			resources: [.copy("TestData")]
		),
	]
)
