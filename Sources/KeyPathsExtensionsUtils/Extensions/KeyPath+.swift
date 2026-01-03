import Foundation
import SwiftMarkerProtocols

extension _AnyKeyPathProtocol {
	@inlinable
	public func forceHashable<T>(
		_ value: T
	) -> ForceHashable<T> where Self: AnyObject {
		.init(value, hashes: self)
	}

	@inlinable
	public func forceHashable<T>(
		_ value: T
	) -> ForceHashable<T> where Self: AnyObject, T: Hashable {
		.init(value)
	}
}
