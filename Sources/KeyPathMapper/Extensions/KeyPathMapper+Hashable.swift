@_spi(Internals) import SwiftMarkerProtocols
import KeyPathsExtensionsUtils

extension KeyPathMapper {
	public subscript(
		forceHashableWith hashes: [AnyHashable]
	) -> KeyPathMapper<ForceHashable<Value>> {
		get { .init(.init(value, hashes: hashes)) }
	}
}

extension KeyPathMapper where Value: _OptionalProtocol {
	public subscript(
		forceHashableWith hashes: [AnyHashable]
	) -> KeyPathMapper<ForceHashable<Value.Wrapped>?> {
		get { .init(value.__marker_value.map { .init($0, hashes: hashes) }) }
		set { self.value.__marker_value = newValue.value?.value }
	}
}
