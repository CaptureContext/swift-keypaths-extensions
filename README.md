# swift-keypaths-extensions

[![SwiftPM 6.0](https://img.shields.io/badge/swiftpm-6.0-ED523F.svg?style=flat)](https://swift.org/download/) ![Platforms](https://img.shields.io/badge/platforms-iOS_11_|_macOS_10.13_|_tvOS_11_|_watchOS_4_|_Catalyst_13-ED523F.svg?style=flat) [![@capture_context](https://img.shields.io/badge/contact-@capture__context-1DA1F2.svg?style=flat&logo=twitter)](https://twitter.com/capture_context) 

Extensions for Swift KeyPaths. Currently this package contains helpers for managing KeyPaths with Optional values, if you need extensions for enums, take a look at [`pointfreeco/swift-case-paths`](https://github.com/pointfreeco/swift-case-paths)

## Usage

```swift
struct Root {
  struct Property {
    var intValue: Int = 0
  }
  
  var optionalProperty: Property?
  
  init(_ value: Int?) {
    self.optionalProperty = value.map(Property.init(intValue:))
  }
}
```

```swift
// available out-of-the-box, recommended way when available
let kp_expression: KeyPath<Root, Int?> = \Root.optionalProperty?.intValue
```

```swift
// if you have 2 arbitrary paths
// and kp_1.Value.Type doesn't match kp_2.Value.Type exactly
// (Optionality causes mismatch in that case)
let kp_1: KeyPath<Root, Property?> = \Root.optionalProperty
let kp_2: KeyPath<Property, Int> = \Property.intValue
  
// `kp_1.appending(path: kp_2)` is not available out-of-the-box
let kp_combined: KeyPath<Root, Int?> = kp_1.appending(kp_2)

// unwrapping is not available out-of-the-box
let kp_unwrapped: KeyPath<Root, Int> = kp_combined.unwrapped(with: 0)

// ⚠️ tho unwrapped paths shouldn't be combined for reference types
```

> [!NOTE]
>
> _Take a look at tests for more examples. Also keep your eye on doc comments for more info._

## Installation

### Basic

You can add KeypathsExtensions to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swift-keypaths-extensions"`](https://github.com/capturecontext/swift-keypaths-extensions) into the package repository URL text field
3. Choose products you need to link them to your project.

### Recommended

If you use SwiftPM for your project structure, add KeyPathsExtensions to your package file. 

```swift
.package(
  url: "git@github.com:capturecontext/swift-keypaths-extensions.git", 
  .upToNextMinor(from: "0.0.1")
)
```

or via HTTPS

```swift
.package(
  url: "https://github.com:capturecontext/swift-keypaths-extensions.git", 
  .upToNextMinor("0.0.1")
)
```

Do not forget about target dependencies:

```swift
.product(
  name: "KeyPathsExtensions", 
  package: "swift-keypaths-extensions"
)
```

## License

This library is released under the MIT license. See [LICENSE](./LICENSE) for details.
