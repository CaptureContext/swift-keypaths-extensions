public protocol KeyPathMapperProtocol<Value> {
	associatedtype Value
	var value: Value { get set }
}

public struct KeyPathMapper<Value>: KeyPathMapperProtocol {
	public var value: Value

	@inlinable
	public init(_ value: Value) {
		self.value = value
	}

	@inlinable
	public subscript() -> Value {
		get { value }
		set { self.value = newValue }
	}

	@inlinable
	public mutating func callAsFunction(_ value: Value) {
		self.value = value
	}

	@inlinable
	public subscript<T>(
		map keyPath: KeyPath<Self, T>
	) -> T {
		get { self[keyPath: keyPath] }
	}

	@inlinable
	public subscript<T>(
		map keyPath: WritableKeyPath<Self, T>
	) -> T {
		get { self[keyPath: keyPath] }
		set { self[keyPath: keyPath] = newValue }
	}
}

extension KeyPathMapper: Sendable where Value: Sendable {}
extension KeyPathMapper: Equatable where Value: Equatable {}
extension KeyPathMapper: Hashable where Value: Hashable {}
