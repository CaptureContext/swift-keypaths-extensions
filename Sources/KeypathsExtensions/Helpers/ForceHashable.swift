import Foundation

@_spi(Internals)
public struct _ForceHashable<Value>: Hashable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.equatable == rhs.equatable
	}

	private let equatable: _ForceEquatable<Value>
	private let hash: (inout Hasher) -> Void

	public var value: Value { equatable.value }

	public init(
		value: Value,
		hash: @escaping (inout Hasher) -> Void
	) {
		self.equatable = .init(value)
		self.hash = hash
	}

	init<Hash: Hashable>(
		_ value: Value,
		hash: Hash
	) {
		self.init(
			value: value,
			hash: { $0.combine(hash) }
		)
	}

	public func hash(into hasher: inout Hasher) {
		self.hash(&hasher)
	}
}
