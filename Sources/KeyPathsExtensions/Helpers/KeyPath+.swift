import Foundation
import SwiftMarkerProtocols
import Hashed

extension _AnyKeyPathProtocol {
	@inlinable
	public func _hashed<T>(
		_ value: T
	) -> Hashed<T> where Self: AnyObject {
		.init(value, by: .uncheckedSendable(self))
	}

	@inlinable
	public func _hashed<T>(
		_ value: T
	) -> Hashed<T> where Self: AnyObject, T: Hashable {
		.init(value)
	}
}

extension _AnyKeyPathProtocol {
	@_spi(Internals)
	public func unwrapPath<Wrapped>(
		with defaultValue: Wrapped,
		aggressive: Bool
	) -> WritableKeyPath<Wrapped?, Wrapped> {
		return \.[
			mapPath: \.[
				hashedBy: AnyHashable(self)
			][
				unwrappedWith: _hashed(defaultValue),
				aggressive: aggressive
			]
		].wrappedValue
	}
}

extension Optional {
	subscript(
		uww defaultValue: Hashed<Wrapped>,
		aggressive aggressive: Bool
	) -> Wrapped {
		get { self ?? defaultValue.wrappedValue }
		set {
			if aggressive || self != nil {
				self = newValue
			}
		}
	}
}
