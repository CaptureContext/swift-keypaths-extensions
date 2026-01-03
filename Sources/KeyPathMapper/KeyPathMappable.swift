public protocol KeyPathMappable {}

extension KeyPathMappable {
	@inlinable
	public var _map: KeyPathMapper<Self> {
		get { .init(self) }
		set { self = newValue.value }
	}

	@inlinable
	public subscript<T>(
		map keyPath: WritableKeyPath<KeyPathMapper<Self>, KeyPathMapper<T>>
	) -> T {
		get { _map[keyPath: keyPath].value }
		set { _map[keyPath: keyPath].value = newValue }
	}
}

extension Hashable {
	@inlinable
	public var _map: KeyPathMapper<Self> {
		get { .init(self) }
		set { self = newValue.value }
	}

	@inlinable
	public subscript<T>(
		map keyPath: WritableKeyPath<KeyPathMapper<Self>, KeyPathMapper<T>>
	) -> T {
		get { _map[keyPath: keyPath].value }
		set { _map[keyPath: keyPath].value = newValue }
	}
}
