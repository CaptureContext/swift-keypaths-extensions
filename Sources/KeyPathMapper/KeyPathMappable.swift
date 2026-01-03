public protocol KeyPathMappable {
	subscript<T>(
		mapPath keyPath: MappingKeyPath<Self, T>
	) -> T { get }

	subscript<T>(
		mapPath keyPath: WritableMappingKeyPath<Self, T>
	) -> T { get set }
}

public typealias MappingKeyPath<A, B> = KeyPath<KeyPathMapper<A>, KeyPathMapper<B>>
public typealias WritableMappingKeyPath<A, B> = WritableKeyPath<KeyPathMapper<A>, KeyPathMapper<B>>

extension KeyPathMappable {
	@_spi(Internals)
	public var __map: KeyPathMapper<Self> {
		get { .init(self) }
		set { self = newValue.value }
	}

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
