import Foundation
import KeyPathsExtensionsUtils

extension Optional: KeyPathMappable {}

extension KeyPathMapper {
	@inlinable
	public var optional: KeyPathMapper<Value?> {
		get { .init(value) }
		set { newValue.value.map { self.value = $0 } }
	}

	@inlinable
	public subscript<T>(
		unwrappedWith defaultValue: T,
		aggressive aggressive: Bool = false,
	) -> KeyPathMapper<T> where Value == Optional<T> {
		get { .init(self.value ?? defaultValue) }
		set {
			if aggressive { self.value = newValue.value }
			else if self.value != nil { self.value = newValue.value }
		}
	}

	@inlinable
	public subscript<T>(
		unwrappedWith defaultValue: ForceHashable<T>,
		aggressive aggressive: Bool = false,
	) -> KeyPathMapper<T> where Value == Optional<T> {
		get { self[unwrappedWith: defaultValue.value] }
		set { self[unwrappedWith: defaultValue.value, aggressive: aggressive] = newValue }
	}
}
