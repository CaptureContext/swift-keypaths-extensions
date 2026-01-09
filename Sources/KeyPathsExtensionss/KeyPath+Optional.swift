import Foundation
import SwiftMarkerProtocols
@_spi(Internals) import KeyPathMapper
@_spi(Internals) import Hashed

extension _AnyKeyPathProtocol {
	/// Unwraps keyPath with provided default value
	///
	/// - Parameters:
	///   - defaultValue:
	///     Default value that is used when the Value of the initial keyPath was nil
	///   - aggressive:
	///     Flag that indicates policy for setters. Default value of this argument is `false`.
	///
	///     Attempting to set new value **will** assign default value by initial keyPath
	///     if the value was `nil` if this argument is `true`, and **will not** assign default
	///     value if this argument is `false`
	///
	/// - Returns: `KeyPath<Root, Optional<Value>>`
	public func unwrapped<Root, Wrapped>(
		with defaultValue: Wrapped,
		aggressive: Bool = false
	) -> KeyPath<Root, Wrapped> where Self: KeyPath<Root, Wrapped?> {
		appending(path: self.unwrapPath(with: defaultValue, aggressive: aggressive))
	}

	/// Unwraps keyPath with provided default value
	///
	/// - Warning: Appending writable KeyPaths to the result of this function
	///   will break unwrapping for `nil` values. Seems like keyPath internals
	///   simply won't call derived setters if the value by the parent keyPath is `nil`
	///
	/// - Parameters:
	///   - defaultValue:
	///     Default value that is used when the Value of the initial keyPath was nil
	///   - aggressive:
	///     Flag that indicates policy for setters. Default value of this argument is `false`.
	///
	///     Attempting to set new value **will** assign default value by initial keyPath
	///     if the value was `nil` if this argument is `true`, and **will not** assign default
	///     value if this argument is `false`
	///
	/// - Returns: `WritableKeyPath<Root, Optional<Value>>`
	public func unwrapped<Root, Wrapped>(
		with defaultValue: Wrapped,
		aggressive: Bool = false
	) -> WritableKeyPath<Root, Wrapped>
	where Self == WritableKeyPath<Root, Wrapped?> {
		appending(path: self.unwrapPath(with: defaultValue, aggressive: aggressive))
	}

	/// Unwraps keyPath with provided default value
	///
	/// - Warning: Appending writable KeyPaths to the result of this function
	///   will break unwrapping for `nil` values. Seems like keyPath internals
	///   simply won't call derived setters if the value by the parent keyPath is `nil`
	///
	/// - Parameters:
	///   - defaultValue:
	///     Default value that is used when the Value of the initial keyPath was nil
	///   - aggressive:
	///     Flag that indicates policy for setters. Default value of this argument is `false`.
	///
	///     Attempting to set new value **will** assign default value by initial keyPath
	///     if the value was `nil` if this argument is `true`, and **will not** assign default
	///     value if this argument is `false`
	///
	/// - Returns: `ReferenceWritableKeyPath<Root, Optional<Value>>`
	public func unwrapped<Root, Wrapped>(
		with defaultValue: Wrapped,
		aggressive: Bool = false
	) -> ReferenceWritableKeyPath<Root, Wrapped>
	where Self == ReferenceWritableKeyPath<Root, Wrapped?> {
		appending(path: self.unwrapPath(with: defaultValue, aggressive: aggressive))
	}
}

extension _AnyKeyPathProtocol {
	/// Appends unwrapped KeyPath to a keyPath to optional Value
	///
	/// This method is useful when working with generic KeyPath types,
	/// keyPaths expressions on the other hand support this out-of-the-box with `?`
	/// operator.
	///
	/// Example:
	/// ```swift
	/// // available out-of-the-box
	/// // recommended way when available
	/// let kp_expression: KeyPath<Root, Int?> = \Root.optionalProperty?.intValue
	///
	/// // but if you have 2 arbitrary paths
	/// let kp_1: KeyPath<Root, Property?> // e.g. = \Root.optionalProperty
	/// let kp_2: KeyPath<Property, Int> // e.g. = \Property.intValue
	///
	/// // `kp_1.appending(path: kp_2)` is not available out-of-the-box
	/// let kp_combined: KeyPath<Root, Int?> = kp_1.appending(kp_2)
	/// ```
	///
	/// - Parameters:
	///   - keyPath: Appended `KeyPath`
	///
	/// - Returns: `KeyPath<Value, LocalValue?>`
	@inlinable
	public func appending<Root, Value, AppendedValue>(
		path keyPath: KeyPath<Value, AppendedValue>
	) -> KeyPath<Root, AppendedValue?>
	where Self: KeyPath<Root, Value?> {
		appending(path: keyPath.withOptionalRoot())
	}

	/// Appends unwrapped KeyPath to a keyPath to optional Value
	///
	/// This method is useful when working with generic KeyPath types,
	/// keyPaths expressions on the other hand support this out-of-the-box with `?`
	/// operator.
	///
	/// Example:
	/// ```swift
	/// // available out-of-the-box
	/// // recommended way when available
	/// let kp_expression: KeyPath<Root, Int?> = \Root.optionalProperty?.intValue
	///
	/// // but if you have 2 arbitrary paths
	/// let kp_1: KeyPath<Root, Property?> // e.g. = \Root.optionalProperty
	/// let kp_2: KeyPath<Property, Int> // e.g. = \Property.intValue
	///
	/// // `kp_1.appending(path: kp_2)` is not available out-of-the-box
	/// let kp_combined: KeyPath<Root, Int?> = kp_1.appending(kp_2)
	/// ```
	///
	/// - Parameters:
	///   - keyPath: Appended `ReferenceWritableKeyPath`
	///
	/// - Returns: `ReferenceWritableKeyPath<Value, LocalValue?>`
	@inlinable
	public func appending<Root, Value, AppendedValue>(
		path keyPath: ReferenceWritableKeyPath<Value, AppendedValue>
	) -> ReferenceWritableKeyPath<Root, AppendedValue?>
	where Self == KeyPath<Root, Value?> {
		appending(path: keyPath.withOptionalRoot())
	}

	/// Appends unwrapped KeyPath to a keyPath to optional Value
	///
	/// This method is useful when working with generic KeyPath types,
	/// keyPaths expressions on the other hand support this out-of-the-box with `?`
	/// operator.
	///
	/// Example:
	/// ```swift
	/// // available out-of-the-box
	/// // recommended way when available
	/// let kp_expression: KeyPath<Root, Int?> = \Root.optionalProperty?.intValue
	///
	/// // but if you have 2 arbitrary paths
	/// let kp_1: KeyPath<Root, Property?> // e.g. = \Root.optionalProperty
	/// let kp_2: KeyPath<Property, Int> // e.g. = \Property.intValue
	///
	/// // `kp_1.appending(path: kp_2)` is not available out-of-the-box
	/// let kp_combined: KeyPath<Root, Int?> = kp_1.appending(kp_2)
	/// ```
	///
	/// - Parameters:
	///   - keyPath: Appended `WritableKeyPath`
	///
	/// - Returns: `WritableKeyPath<Value, LocalValue?>`
	@inlinable
	public func appending<Root, Value, AppendedValue>(
		path keyPath: WritableKeyPath<Value, AppendedValue>
	) -> WritableKeyPath<Root, AppendedValue?>
	where Self == WritableKeyPath<Root, Value?> {
		appending(path: keyPath.withOptionalRoot())
	}

	/// Appends unwrapped KeyPath to a keyPath to optional Value
	///
	/// This method is useful when working with generic KeyPath types,
	/// keyPaths expressions on the other hand support this out-of-the-box with `?`
	/// operator.
	///
	/// Example:
	/// ```swift
	/// // available out-of-the-box
	/// // recommended way when available
	/// let kp_expression: KeyPath<Root, Int?> = \Root.optionalProperty?.intValue
	///
	/// // but if you have 2 arbitrary paths
	/// let kp_1: KeyPath<Root, Property?> // e.g. = \Root.optionalProperty
	/// let kp_2: KeyPath<Property, Int> // e.g. = \Property.intValue
	///
	/// // `kp_1.appending(path: kp_2)` is not available out-of-the-box
	/// let kp_combined: KeyPath<Root, Int?> = kp_1.appending(kp_2)
	/// ```
	///
	/// - Parameters:
	///   - keyPath: Appended `WritableKeyPath`
	///
	/// - Returns: `ReferenceWritableKeyPath<Value, LocalValue?>`
	@inlinable
	public func appending<Root, Value, AppendedValue>(
		path keyPath: ReferenceWritableKeyPath<Value, AppendedValue>
	) -> ReferenceWritableKeyPath<Root, AppendedValue?>
	where Self == WritableKeyPath<Root, Value?> {
		appending(path: keyPath.withOptionalRoot())
	}

	/// Appends unwrapped KeyPath to a keyPath to optional Value
	///
	/// This method is useful when working with generic KeyPath types,
	/// keyPaths expressions on the other hand support this out-of-the-box with `?`
	/// operator.
	///
	/// Example:
	/// ```swift
	/// // available out-of-the-box
	/// // recommended way when available
	/// let kp_expression: KeyPath<Root, Int?> = \Root.optionalProperty?.intValue
	///
	/// // but if you have 2 arbitrary paths
	/// let kp_1: KeyPath<Root, Property?> // e.g. = \Root.optionalProperty
	/// let kp_2: KeyPath<Property, Int> // e.g. = \Property.intValue
	///
	/// // `kp_1.appending(path: kp_2)` is not available out-of-the-box
	/// let kp_combined: KeyPath<Root, Int?> = kp_1.appending(kp_2)
	/// ```
	///
	/// - Parameters:
	///   - keyPath: Appended `WritableKeyPath`
	///
	/// - Returns: `ReferenceWritableKeyPath<Value, LocalValue?>`
	@inlinable
	public func appending<Root, Value, AppendedValue>(
		path keyPath: WritableKeyPath<Value, AppendedValue>
	) -> ReferenceWritableKeyPath<Root, AppendedValue?>
	where Self == ReferenceWritableKeyPath<Root, Value?> {
		appending(path: keyPath.withOptionalRoot())
	}

	public func withOptionalRoot<Root, Value>() -> KeyPath<Root?, Value?>
	where Self: KeyPath<Root, Value> { \Optional<Root>.self[_unwrappedKeyPath: self] }

	public func withOptionalRoot<Root, Value>() -> WritableKeyPath<Root?, Value?>
	where Self == WritableKeyPath<Root, Value> { \Optional<Root>.self[_unwrappedKeyPath: self] }

	public func withOptionalRoot<Root, Value>() -> ReferenceWritableKeyPath<Root?, Value?>
	where Self == ReferenceWritableKeyPath<Root, Value> { \Optional<Root>.self[_unwrappedKeyPath: self] }
}

extension Optional {
	@_spi(Internals)
	public subscript<Value>(
		_unwrappedKeyPath keyPath: KeyPath<Wrapped, Value>
	) -> Value? {
		get { self?[keyPath: keyPath] }
	}

	@_spi(Internals)
	public subscript<Value>(
		_unwrappedKeyPath keyPath: WritableKeyPath<Wrapped, Value>
	) -> Value? {
		get { self?[keyPath: keyPath] }
		set {
			guard let newValue else { return }
			self?[keyPath: keyPath] = newValue
		}
	}

	@_spi(Internals)
	public subscript<Value>(
		_unwrappedKeyPath keyPath: ReferenceWritableKeyPath<Wrapped, Value>
	) -> Value? {
		get { self?[keyPath: keyPath] }
		nonmutating set {
			guard let newValue else { return }
			self?[keyPath: keyPath] = newValue
		}
	}
}

