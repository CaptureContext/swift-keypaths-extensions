import Testing
@_spi(Internals) @testable import KeyPathMapper

@Suite("KeyPathMapperOptionalTests")
struct KeyPathMapperOptionalTests {
	@Test
	func testOptional() {
		let sut: KeyPathMapper<Int> = .init(0)

		#expect(type(of: sut.optional) == KeyPathMapper<Int?>.self)
		#expect(sut.value == sut.optional.value)
	}

	@Test
	func testUnwrapping() {
		do { // non-aggessive
			var sut: KeyPathMapper<Int?> = .init(nil)

			// getter gets unwrapped
			#expect(sut[unwrappedWith: 0, aggressive: false].value == 0)

			// won't update nil value
			sut[unwrappedWith: 0, aggressive: false].value += 1
			#expect(sut.value == nil)

			// won't update nil value
			sut[unwrappedWith: 0, aggressive: false].value = 1
			#expect(sut.value == nil)
		}

		do { // aggessive
			var sut: KeyPathMapper<Int?> = .init(nil)

			// getter gets unwrapped
			#expect(sut[unwrappedWith: 0, aggressive: true].value == 0)

			// will update nil value
			sut[unwrappedWith: 0, aggressive: true].value += 1
			#expect(sut.value == 1)

			// will update nil value
			sut[unwrappedWith: 0, aggressive: true].value = 2
			#expect(sut.value == 2)
		}
	}
}
