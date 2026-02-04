import SwiftMarkerProtocols
import Hashed

extension KeyPathMapper {
	public subscript(
		hashedBy hash: AnyHashable
	) -> KeyPathMapper<Hashed<Value>> {
		get { .init(.init(value, by: .uncheckedSendable(hash))) }
		set { self.value = newValue.value.wrappedValue }
	}
}

extension KeyPathMapper where Value: _OptionalProtocol {
	public subscript(
		hashedBy hash: AnyHashable
	) -> KeyPathMapper<Hashed<Value.Wrapped>?> {
		get { .init(value._optional.map { .init($0, by: .uncheckedSendable(hash)) }) }
		set { self.value._optional = newValue.value?.wrappedValue }
	}
}
