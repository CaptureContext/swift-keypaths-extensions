import Testing
@_spi(Internals) @testable import KeyPathMapper

@Suite("KeyPathMapperCollectionsTests")
struct KeyPathMapperCollectionsTests {
	@Test
	func unsafeIndex() {
		var array: [Int] = [0, 1, 2, 3]

		do {
			let element = array[mapPath: \.[unsafeIndex: 0]]
			#expect(type(of: element) == Int.self)
			#expect(element == 0)
		}

		do {
			array[mapPath: \.[unsafeIndex: 0]] = 1
			#expect(array == [1, 1, 2, 3])
		}
	}

	@Test
	func safeIndex() {
		var array: [Int] = [0, 1, 2, 3]
		
		do {
			let element = array[mapPath: \.[safeIndex: 0]]
			#expect(type(of: element) == Int?.self)
			#expect(element == 0)
		}

		do {
			array[mapPath: \.[safeIndex: 0]] = nil
			#expect(array == [0, 1, 2, 3])
		}

		do {
			array[mapPath: \.[safeIndex: -1]] = 1
			#expect(array == [0, 1, 2, 3])
		}

		do {
			array[mapPath: \.[safeIndex: 0]] = 1
			#expect(array == [1, 1, 2, 3])
		}
	}
}
