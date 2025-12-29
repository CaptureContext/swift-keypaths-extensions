extension _AppendKeyPath {
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
		appending(path: \.[_forceSet: aggressive, unwrappedWith: _ForceHashable(defaultValue, hash: self)])
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
	) -> WritableKeyPath<Root, Wrapped> where Self == WritableKeyPath<Root, Wrapped?> {
		appending(path: \.[_forceSet: aggressive, unwrappedWith: _ForceHashable(defaultValue, hash: self)])
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
	) -> ReferenceWritableKeyPath<Root, Wrapped> where Self == ReferenceWritableKeyPath<Root, Wrapped?> {
		appending(path: \.[_forceSet: aggressive, unwrappedWith: _ForceHashable(defaultValue, hash: self)])
	}
}

extension _AppendKeyPath {
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
	public func appending<Root, Value, AppendedValue>(
		_ keyPath: KeyPath<Value, AppendedValue>
	) -> KeyPath<Root, AppendedValue?> where Self: KeyPath<Root, Value?> {
		appending(path: keyPath._keyPathOfOptionalRoot)
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
	public func appending<Root, Value, AppendedValue>(
		_ keyPath: ReferenceWritableKeyPath<Value, AppendedValue>
	) -> ReferenceWritableKeyPath<Root, AppendedValue?> where Self == KeyPath<Root, Value?> {
		appending(path: keyPath._referenceWritableKeyPathOfOptionalRoot)
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
	public func appending<Root, Value, AppendedValue>(
		_ keyPath: WritableKeyPath<Value, AppendedValue>
	) -> WritableKeyPath<Root, AppendedValue?> where Self == WritableKeyPath<Root, Value?> {
		appending(path: keyPath._writableKeyPathOfOptionalRoot)
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
	public func appending<Root, Value, AppendedValue>(
		_ keyPath: ReferenceWritableKeyPath<Value, AppendedValue>
	) -> ReferenceWritableKeyPath<Root, AppendedValue?> where Self == WritableKeyPath<Root, Value?> {
		appending(path: keyPath._referenceWritableKeyPathOfOptionalRoot)
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
	public func appending<Root, Value, AppendedValue>(
		_ keyPath: WritableKeyPath<Value, AppendedValue>
	) -> ReferenceWritableKeyPath<Root, AppendedValue?> where Self == ReferenceWritableKeyPath<Root, Value?> {
		appending(path: keyPath._writableKeyPathOfOptionalRoot)
	}
}

extension KeyPath {
	@_spi(Internals)
	public var _keyPathOfOptionalRoot: KeyPath<Root?, Value?> {
		\Optional<Root>.self[_unwrappedKeyPath: self]
	}
}

extension WritableKeyPath {
	@_spi(Internals)
	public var _writableKeyPathOfOptionalRoot: WritableKeyPath<Root?, Value?> {
		\Optional<Root>.self[_unwrappedKeyPath: self]
	}
}

extension ReferenceWritableKeyPath {
	@_spi(Internals)
	public var _referenceWritableKeyPathOfOptionalRoot: ReferenceWritableKeyPath<Root?, Value?> {
		\Optional<Root>.self[_unwrappedKeyPath: self]
	}
}
