import Foundation

@_spi(Internals)
public struct _ForceEquatable<Value>: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		guard
			let lhsValue = lhs.value as? any Equatable,
			let rhsValue = rhs.value as? any Equatable
		else { return lhs.dump() == rhs.dump() }
		return lhsValue._checkIsEqual(to: rhsValue)
	}

	public let value: Value

	public init(_ value: Value) {
		self.value = value
	}

	private func dump() -> String {
		var output = String()
		output.write(String(reflecting: Value.self))
		output.write(" :: ")
		Swift.dump(value, to: &output)
		return output
	}
}

extension Equatable {
	@_spi(Internals)
	public func _checkIsEqual(to other: any Equatable) -> Bool {
		guard let value = other as? Self else { return false }
		return self == value
	}
}
