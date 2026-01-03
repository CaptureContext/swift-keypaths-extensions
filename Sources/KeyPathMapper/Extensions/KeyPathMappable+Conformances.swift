import Foundation

extension Optional: KeyPathMappable {
	public subscript<T>(
		mapPath keyPath: MappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
	}

	public subscript<T>(
		mapPath keyPath: WritableMappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
		set { __map[keyPath: keyPath].value = newValue }
	}
}

extension Result: KeyPathMappable {
	public subscript<T>(
		mapPath keyPath: MappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
	}

	public subscript<T>(
		mapPath keyPath: WritableMappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
		set { __map[keyPath: keyPath].value = newValue }
	}
}

extension Array: KeyPathMappable {
	public subscript<T>(
		mapPath keyPath: MappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
	}

	public subscript<T>(
		mapPath keyPath: WritableMappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
		set { __map[keyPath: keyPath].value = newValue }
	}
}

extension Dictionary: KeyPathMappable {
	public subscript<T>(
		mapPath keyPath: MappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
	}

	public subscript<T>(
		mapPath keyPath: WritableMappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
		set { __map[keyPath: keyPath].value = newValue }
	}
}

extension Set: KeyPathMappable {
	public subscript<T>(
		mapPath keyPath: MappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
	}

	public subscript<T>(
		mapPath keyPath: WritableMappingKeyPath<Self, T>
	) -> T {
		get { __map[keyPath: keyPath].value }
		set { __map[keyPath: keyPath].value = newValue }
	}
}

extension Equatable {
	@_spi(Internals)
	public var __map_equatable: KeyPathMapper<Self> {
		get { .init(self) }
		set { self = newValue.value }
	}

	@_disfavoredOverload
	public subscript<T>(
		mapPath keyPath: MappingKeyPath<Self, T>
	) -> T {
		get { __map_equatable[keyPath: keyPath].value }
	}

	@_disfavoredOverload
	public subscript<T>(
		mapPath keyPath: WritableMappingKeyPath<Self, T>
	) -> T {
		get { __map_equatable[keyPath: keyPath].value }
		set { __map_equatable[keyPath: keyPath].value = newValue }
	}
}
