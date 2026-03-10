# swift-keypaths-extensions

[![CI](https://github.com/CaptureContext/swift-keypaths-extensions/actions/workflows/ci.yml/badge.svg)](https://github.com/CaptureContext/swift-keypaths-extensions/actions/workflows/ci.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCaptureContext%2Fswift-keypaths-extensions%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/CaptureContext/swift-keypaths-extensions) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCaptureContext%2Fswift-keypaths-extensions%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/CaptureContext/swift-keypaths-extensions)

Extensions for Swift KeyPaths. Starting with `0.2.0`, `KeyPathMapper` has been extracted into the separate [`swift-keypath-mapping`](https://github.com/capturecontext/swift-keypath-mapping) package, while this package focuses on optionality, composition, and re-exporting mapping APIs through `KeyPathsExtensions`. If you need key paths for enums, take a look at [`pointfreeco/swift-case-paths`](https://github.com/pointfreeco/swift-case-paths)

## Table of contents

- [Motivation](#motivation)
- [The Problem](#the-problem)
- [Usage](#usage)
- [Installation](#installation)
- [License](#license)

## Motivation

Swift key paths are powerful, but their composability breaks down in two common scenarios:
- when values need to be *derived* while preserving identity (e.g. SwiftUI bindings),
- and when optionality prevents paths from being composed or written to.

This package provides focused utilities that address these limitations while staying within Swift’s type system.

## The Problem

#### 1. Derived bindings lose identity

> [!NOTE]
>
> [**Why it's a bad idea to use Binding.init(get:set:)**](https://chris.eidhof.nl/post/binding-with-get-set)
>
> _Link source: https://t.me/contravariance_

In SwiftUI, it’s common to derive a value from state:

```swift
struct Example: View {
  @State 
  private var value: Float = 0

  var body: some View {
    Slider(value: Binding(
      get: { Double(value) },
      set: { value = Float($0) }
    ))
  }
}
```

This works functionally, but it breaks SwiftUI’s diffing model.

Bindings created with `Binding(get:set:)` are opaque and not `Hashable`, which prevents SwiftUI from reliably detecting derived changes.

A common workaround is to define computed properties on types:

```swift
extension BinaryFloatingPoint {
  var double: Double {
    get { Double(self) }
    set { self = .init(newValue) }
  }
}
```

Such extensions lead to one of the following trade-offs:
- `private extension` makes such helpers non-reusable
- `public extension` causes namespace pollution for extended type

Swift has no built-in concept for expressing such transformations *outside* the type they operate on.


#### 2. Optional key paths cannot be composed freely

Swift supports optional chaining in key paths:

```swift
let kp: KeyPath<Root, Int?> = \Root.optionalProperty?.value
```

However, once optionality is involved, many useful operations become unavailable.

For example, combining key paths manually is not possible:

```swift
let kp1: KeyPath<Root, Property?> = \Root.optionalProperty
let kp2: KeyPath<Property, Int> = \Property.value

// ❌ Not available in Swift
let combined = kp1.appending(path: kp2)
```

Even though this assignment is valid at runtime:

```swift
root.optionalProperty?.value = 0
```

#### 3. Optionality breaks writability

Optional chaining also prevents writable key paths from being formed:

```swift
// ❌ Cannot convert KeyPath<Root, Int?> to WritableKeyPath<Root, Int?>
let kp: WritableKeyPath<Root, Int?> = \Root.optionalProperty?.value
```

As a result, APIs that rely on WritableKeyPath cannot be used, even when the underlying mutation is safe and well-defined.

There is no standard way to:

- lift a non-optional key path into an optional context,
- unwrap an optional key path with a default value,
- or restore writability across optional boundaries.

## Usage

This product re-exports `KeyPathMapping` and also provides utilities for working with key paths as values, particularly around optionality and composition:
- `withOptionalRoot()`

- `appending(path:)` for `Optional<Value>` paths

- `unwrapped(with:aggressive:)` for `Optional<Value>` paths

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
let kp_combined: KeyPath<Root, Int?> = kp_1.appending(path: kp_2)

// unwrapping is not available out-of-the-box
let kp_unwrapped: KeyPath<Root, Int> = kp_combined.unwrapped(with: 0)

// ⚠️ Unwrapped paths should be combined for reference types with caution
// Swift internals only allow non-aggressive unwrapping for reference types
```

> [!WARNING]
>
> _`KeyPathsOptionalTests.ReferenceTypeInReferenceType.aggressivelyUnwrapped()` contains a note, mentioning that aggressive unwrapping is not guaranteed for nested reference types, at least when such unwrapped paths are combined with some other ones_

> [!Note]
>
> Dynamic member lookup does not currently support sendable key paths and even breaks autocomplete.
>
> * [swiftlang/swift/issues/77035](https://github.com/swiftlang/swift/issues/77035)
>
> * [swiftlang/swift/issues/77105](https://github.com/swiftlang/swift/issues/77105)
>
> `KeyPathsExtensions` also provide "_Sendable"-prefixed keyPath aliases and `unsafeSendable()` methods

## Installation

### Basic

You can add `swift-keypaths-extensions` to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swift-keypaths-extensions"`](https://github.com/capturecontext/swift-keypaths-extensions) into the package repository URL text field
3. Choose products you need to link to your project.

### Recommended

If you use SwiftPM for your project structure, add `swift-keypaths-extensions` dependency to your package file:

```swift
.package(
  url: "https://github.com/capturecontext/swift-keypaths-extensions.git", 
  .upToNextMajor(from: "0.2.0")
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

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
