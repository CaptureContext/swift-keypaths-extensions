import Foundation
import Hashed
import SwiftMarkerProtocols

extension KeyPathMapper {
	@inlinable
	public var optional: KeyPathMapper<Value?> {
		get { .init(value) }
		set { newValue.value.map { self.value = $0 } }
	}
}

extension KeyPathMapper where Value: _OptionalProtocol {
	public subscript(
		unwrappedWith defaultValue: Value.Wrapped,
		aggressive aggressive: Bool = false
	) -> KeyPathMapper<Value.Wrapped> {
		get { .init(self.value._optional ?? defaultValue) }
		set {
			if aggressive || self.value._optional != nil {
				self.value._optional = newValue.value
			}
		}
	}

	@inlinable
	public subscript<T>(
		unwrappedWith defaultValue: Hashed<T>,
		aggressive aggressive: Bool = false
	) -> KeyPathMapper<T> where Value == Optional<T> {
		get { self[unwrappedWith: defaultValue.wrappedValue] }
		set { self[unwrappedWith: defaultValue.wrappedValue, aggressive: aggressive] = newValue }
	}
}
