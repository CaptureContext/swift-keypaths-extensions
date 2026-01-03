import Foundation

public protocol ForceHashableProtocol<Value>: ForceEquatableProtocol, Hashable {}

public struct ForceHashable<Value>: ForceHashableProtocol {
	@inlinable
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.equatable == rhs.equatable
	}

	@usableFromInline
	internal var equatable: ForceEquatable<Value>

	@usableFromInline
	internal let hash: (inout Hasher) -> Void

	@inlinable
	public var value: Value {
		_read { yield equatable.value }
		_modify { yield &equatable.value }
	}

	public init(
		value: Value,
		hash: @escaping (inout Hasher) -> Void
	) {
		self.equatable = .init(value)
		self.hash = hash
	}

	@inlinable
	public init(_ value: Value) where Value: Hashable {
		self.init(value, hashes: value)
	}

	@inlinable
	public init(
		_ value: Value,
		hashes: AnyHashable...
	) {
		self.init(
			value,
			hashes: hashes
		)
	}

	@inlinable
	public init(
		_ value: Value,
		hashes: [AnyHashable]
	) {
		self.init(
			value: value,
			hash: { hasher in
				hashes.forEach { hasher.combine($0) }
			}
		)
	}

	@inlinable
	public func hash(into hasher: inout Hasher) {
		self.hash(&hasher)
	}
}
