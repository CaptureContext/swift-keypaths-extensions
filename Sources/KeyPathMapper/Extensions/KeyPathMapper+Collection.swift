import Foundation

extension KeyPathMapper where Value: Collection {
	@inlinable
	public subscript(unsafeIndex index: Value.Index) -> KeyPathMapper<Value.Element> {
		get { .init(self.value[index]) }
	}

	@inlinable
	public subscript(safeIndex index: Value.Index) -> KeyPathMapper<Value.Element?> {
		get {
			guard self.value.indices.contains(index)
			else { return .init(nil) }

			return .init(self.value[index])
		}
	}
}

extension KeyPathMapper where Value: MutableCollection {
	@inlinable
	public subscript(unsafeIndex index: Value.Index) -> KeyPathMapper<Value.Element> {
		get { .init(self.value[index]) }
		set { self.value[index] = newValue.value }
	}

	@inlinable
	public subscript(safeIndex index: Value.Index) -> KeyPathMapper<Value.Element?> {
		get {
			guard self.value.indices.contains(index)
			else { return .init(nil) }

			return .init(self.value[index])
		}
		set {
			guard
				let value = newValue.value,
				self.value.indices.contains(index)
			else { return }

			self.value[index] = value
		}
	}
}
