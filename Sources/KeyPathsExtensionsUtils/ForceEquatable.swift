import Foundation

public protocol ForceEquatableProtocol<Value>: Equatable {
	associatedtype Value
	var value: Value { get set }
}

public struct ForceEquatable<Value>: ForceEquatableProtocol {
	@inlinable
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.isEqual(lhs.value, rhs.value)
	}

	public var value: Value
	public let isEqual: (Value, Value) -> Bool

	public init(
		value: Value,
		isEqual: @escaping (Value, Value) -> Bool
	) {
		self.value = value
		self.isEqual = isEqual
	}

	public init(_ value: Value) where Value: Equatable {
		self.init(value: value, isEqual: ==)
	}

	public init(_ value: Value) {
		self.init(
			value: value,
			isEqual: { lhs, rhs in
				guard
					let lhs = lhs as? any Equatable,
					let rhs = rhs as? any Equatable
				else { return Self.dump(lhs) == Self.dump(rhs) }
				return lhs._checkIsEqual(to: rhs)
			}
		)
	}

	@usableFromInline
	internal static func dump(_ value: Value) -> String {
		var output = String()
		output.write(String(reflecting: Value.self))
		output.write(" :: ")
		Swift.dump(value, to: &output)
		return output
	}
}

extension Equatable {
	@usableFromInline
	internal func _checkIsEqual(to other: any Equatable) -> Bool {
		guard let value = other as? Self else { return false }
		return self == value
	}
}
