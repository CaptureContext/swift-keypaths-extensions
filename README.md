# swift-keypaths-extensions

[![SwiftPM 6.0](https://img.shields.io/badge/swiftpm-6.0-ED523F.svg?style=flat)](https://swift.org/download/) ![Platforms](https://img.shields.io/badge/platforms-iOS_11_|_macOS_10.13_|_tvOS_11_|_watchOS_4_|_Catalyst_13-ED523F.svg?style=flat) [![@capture_context](https://img.shields.io/badge/contact-@capture__context-1DA1F2.svg?style=flat&logo=twitter)](https://twitter.com/capture_context) 

Extensions for Swift KeyPaths. Currently this package contains helpers for managing KeyPaths with Optional values, if you need keypaths for enums, take a look at [`pointfreeco/swift-case-paths`](https://github.com/pointfreeco/swift-case-paths)

## Table of contents

- [Motivation](#motivation)
- [The Problem](#the-problem)
- [The Solution](#the-solution)
- [Usage](#usage)
  - [KeyPathMapper](#keypathmapper)
  - [KeyPathsExtensions](#keypathsextensions)
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

### KeyPathMapper

This module provides a namespace for keypath mappings.

KeyPath mappings are especially useful for SwiftUI bindings, as they allow derived values to preserve identity and avoid `Binding.init(get:set:)`, while keeping type namespaces clean.

> [!NOTE]
>
> [**Why it's a bad idea to use Binding.init(get:set:)**](https://chris.eidhof.nl/post/binding-with-get-set)
>
> _Found the link in this telegram channel: https://t.me/contravariance_

There are some mappings available out-of-the box:

#### Common

```swift
// Makes value optional
// Useful for conversions from Binding<Value> to Binding<Value?>
\.optional

// wraps value in hashable container
// hashed by provided hashable value
// useful for restoring hashability
\.[hashedBy: <#AnyHashable#>]
```

#### Collection

```swift
// access element by index safely
// returns optional if element not found
\.[safeIndex: <#index#>] 

// access element by index directly
\.[unsafeIndex: <#index#>]
```

#### Optional

```swift
// \.[hashedBy:] overload that wraps 
// value in hashable container
// hashed by provided hashable value
// returns optional container
\.[hashedBy: <#AnyHashable#>]

// unwraps value with default value
// aggressive will proactively replace nil value on set
// but it's false by default and won't update value on set
// if it's nil
// Useful for conversions from Binding<Value?> to Binding<Value>
\.[unwrappedWith: <#defaultValue#>, aggressive: <#Bool#>]

// unwraps value with default value wrapped in ForceHashable container
// ForceHashable/ForceEquatable types are public and available
// through `import KeyPathsExtensionsUtils`
// Useful for conversions from Binding<Value?> to Binding<Value>
\.[unwrappedWith: <#ForceHashable<Value>#>, aggressive: <#Bool#>]
```

#### Application

Mappings can be applied to `KeyPathMappable` types, custom types must conform to `KeyPathMappable` protocol to enable mapping APIs. Helpers for some standard types are available out-of-the-box:

- `Optional`
- `Result`
- `Array`
- `Dictionary`
- `Set`
- `Equatable`

#### Custom mappings example

> [!NOTE]
>
> _`KeyPathMapper` is available through `KeyPathsExtensions` product as well as through `KeyPathMapper` which is a part of `KeyPathsExtensions`_

```swift
import KeyPathsMapper

// You can safely keep it public, there is much lower
// chance that some other lib or future Swift version
// will introduce such a thing on a custom type
extension KeyPathMapper where Value == Float {
	var double: KeyPathMapper<Double> {
		get { .init(.init(self.value)) }
		set { self.value = .init(newValue.value) }
	}
}

struct ExampleView: View {
	@State
  private var value: Float = 0
  
  var body: some View {
    // OtherView accepts Binding<Double>
    OtherView(value: $value[
      mapPath: \.double
    ])
  }
}

// Otherwise general approach will look like this
//
// extension Float {
//   private var double: Double {
//		 get { .init(self.value) }
//	   set { self.value = .init(newValue) }
//	 }
// }
```

However the proper generic way to declare such a conversion would be something like this:

```swift
import KeyPathsExtensions

// It's nice to extract such conversions into
// core modules so that feature modules
// can share the code
extension KeyPathMapper where Value: BinaryFloatingPoint {
  // Have to use value as type marker for Bindings
  // so that keyPath argument is Hashable
	subscript<T: BinaryFloatingPoint>(
		convertedTo type: T
	) -> KeyPathMapper<T> {
		get { self[convertedTo: T.self] }
		set { self[convertedTo: T.self] = newValue }
	}

  // Though you can also declare a proper
  // underlying implementation
	subscript<T: BinaryFloatingPoint>(
		convertedTo type: T.Type
	) -> KeyPathMapper<T> {
		get { .init(.init(self.value)) }
		set { self.value = .init(newValue.value) }
	}
}

// In feature module:
struct ExampleView: View {
	@State
  private var value: Float = 0
  
  var body: some View {
    // OtherView accepts Binding<Double>
    OtherView(value: $value[
      mapPath: \.[convertedTo: Double()]
    ])
  }
}
```

### KeyPathsExtensions

This product exports `KeyPathMapper` and also provides utilities for working with key paths as values, particularly around optionality and composition:
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

// ⚠️ Unwrapped paths should not be combined for reference types.
```

> [!WARNING]
>
> _`KeyPathsOptionalTests.ReferenceTypeInReferenceType.aggressivelyUnwrapped()` contains a note, mentioning that aggressive unwrapping is not guaranteed for nested reference types, at least when such unwrapped paths are combined with some other ones_

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
  .upToNextMinor(from: "0.1.0")
)
```

or via HTTPS

```swift
.package(
  url: "https://github.com:capturecontext/swift-keypaths-extensions.git", 
  .upToNextMinor("0.1.0")
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
