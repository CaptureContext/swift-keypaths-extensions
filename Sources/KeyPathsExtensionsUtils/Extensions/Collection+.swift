//import Foundation
//
//extension Collection {
//	@inlinable
//	public subscript(unsafeIndex index: ForceHashable<Index>) -> Element {
//		get { self[value] }
//	}
//
//	@inlinable
//	public subscript(safeIndex index: ForceHashable<Index>) -> Element? {
//		get {
//			guard indices.contains(index.value) else { return nil }
//			return self[index.value]
//		}
//	}
//}
//
//extension MutableCollection {
//	@inlinable
//	public subscript(unsafeIndex index: ForceHashable<Index>) -> Element {
//		get { self[index.value] }
//		set { self[index.value] = newValue }
//	}
//
//	@inlinable
//	public subscript(safeIndex index: ForceHashable<Index>) -> Element? {
//		get {
//			guard indices.contains(index.value) else { return nil }
//			return self[index.value]
//		}
//		set {
//			guard let newValue, indices.contains(index.value) else { return }
//			self[index.value] = newValue
//		}
//	}
//}
