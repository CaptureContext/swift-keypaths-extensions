import Foundation
import SwiftMarkerProtocols
import KeyPathMapping

//extension _AnyKeyPathProtocol {
//	@inlinable
//	public func _hashed<T>(
//		_ value: T
//	) -> Hashed<T> where Self: AnyObject {
//		let id = ObjectIdentifier(self)
//		return .init(value, by: .hashable(id))
//	}
//
//	@inlinable
//	public func _hashed<T>(
//		_ value: T
//	) -> Hashed<T> where Self: AnyObject, T: Hashable {
//		.init(value)
//	}
//}

extension _AnyKeyPathProtocol {
	@_spi(Internals)
	public static func unwrapped<Wrapped>(
		with defaultValue: @escaping @autoclosure () -> Wrapped,
		aggressive: Bool
	) -> WritableKeyPath<Wrapped?, Wrapped> {
		return \.[convert: .unwrapped(
			with: defaultValue(),
			aggressive: aggressive
		)]
	}
}
