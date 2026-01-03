import Testing
@_spi(Internals) @testable import KeyPathsExtensions

@MainActor
@Suite("KeyPathsOptionalTests")
struct KeyPathsOptionalTests {
	@MainActor
	@Suite("ValueTypeInValueType")
	struct ValueTypeInValueType {
		struct Root {
			struct Property {
				var value: Int

				init(_ value: Int) {
					self.value = value
				}
			}

			var property: Property?

			init(_ value: Int?) {
				self.property = value.map(Property.init)
			}

			@MainActor
			enum kp {
				static let defaultValue: Int = 69
				static let defaultProperty: Property = .init(defaultValue)
				static let expression: KeyPath<Root, Int?> = \.property?.value

				static let property: WritableKeyPath<Root, Property?> = \.property
				static let propertyValue: WritableKeyPath<Property, Int> = \.value

				// Equivalent to `expression` keypath
				static let combined: WritableKeyPath<Root, Int?> = property.appending(path: propertyValue)

				// Won't set value if property is nil
				static let combinedUnwrapped: WritableKeyPath<Root, Int> = combined
					.unwrapped(with: defaultValue)

				// Won't set value if property is nil
				static let combinedAggressivelyUnwrapped: WritableKeyPath<Root, Int> = combined
					.unwrapped(with: defaultValue, aggressive: true)

				// Won't set value if property is nil
				static let unwrapped: WritableKeyPath<Root, Int> = property
					.unwrapped(with: defaultProperty, aggressive: false)
					.appending(path: propertyValue)

				// Will set value even if property is nil
				static let aggressivelyUnwrapped: WritableKeyPath<Root, Int> = property
					.unwrapped(with: defaultProperty, aggressive: true)
					.appending(path: propertyValue)
			}
		}

		@Test
		func combined() async throws {
			// NOTE: Those keypaths are equivalent, but not equal!
			#expect(Root.kp.expression !== Root.kp.combined)

			let kp: WritableKeyPath<Root, Int?> = Root.kp.combined

			do { // getters
				#expect(Root(nil)[keyPath: kp] == nil)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func combinedUnwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.combinedUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func combinedAggressivelyUnwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.combinedAggressivelyUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func unwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.unwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func aggressivelyUnwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.aggressivelyUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}
	}

	@MainActor
	@Suite("ReferenceTypeInValueType")
	struct ReferenceTypeInValueType {
		struct Root {
			class Property {
				var value: Int

				init(_ value: Int) {
					self.value = value
				}
			}

			var property: Property?

			init(_ value: Int?) {
				self.property = value.map(Property.init)
			}

			@MainActor
			enum kp {
				static let defaultValue: Int = 69
				static var defaultProperty: Property { .init(defaultValue) }
				static let expression: KeyPath<Root, Int?> = \.property?.value

				static let property: WritableKeyPath<Root, Property?> = \.property
				static let propertyValue: ReferenceWritableKeyPath<Property, Int> = \.value

				// Equivalent to `expression` keypath
				static let combined: ReferenceWritableKeyPath<Root, Int?> = property.appending(path: propertyValue)

				// Won't set value if property is nil
				static let combinedUnwrapped: ReferenceWritableKeyPath<Root, Int> = combined
					.unwrapped(with: defaultValue)

				// Won't set value if property is nil
				static let combinedAggressivelyUnwrapped: ReferenceWritableKeyPath<Root, Int> = combined
					.unwrapped(with: defaultValue, aggressive: true)

				// Won't set value if property is nil
				static let unwrapped: ReferenceWritableKeyPath<Root, Int> = property
					.unwrapped(with: defaultProperty, aggressive: false)
					.appending(path: propertyValue)

				// Will set value even if property is nil
				static let aggressivelyUnwrapped: ReferenceWritableKeyPath<Root, Int> = property
					.unwrapped(with: defaultProperty, aggressive: true)
					.appending(path: propertyValue)
			}
		}

		@Test
		func combined() async throws {
			// NOTE: Those keypaths are equivalent, but not equal!
			#expect(Root.kp.expression !== Root.kp.combined)

			let kp: WritableKeyPath<Root, Int?> = Root.kp.combined

			do { // getters
				#expect(Root(nil)[keyPath: kp] == nil)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func combinedUnwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.combinedUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func combinedAggressivelyUnwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.combinedAggressivelyUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func unwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.unwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func aggressivelyUnwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.aggressivelyUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}
	}

	@MainActor
	@Suite("ValueTypeInReferenceType")
	struct ValueTypeInReferenceType {
		class Root {
			struct Property {
				var value: Int

				init(_ value: Int) {
					self.value = value
				}
			}

			var property: Property?

			init(_ value: Int?) {
				self.property = value.map(Property.init)
			}

			@MainActor
			enum kp {
				static let defaultValue: Int = 69
				static let defaultProperty: Property = .init(defaultValue)
				static let expression: KeyPath<Root, Int?> = \.property?.value

				static let property: ReferenceWritableKeyPath<Root, Property?> = \.property
				static let propertyValue: WritableKeyPath<Property, Int> = \.value

				// Equivalent to `expression` keypath
				static let combined: ReferenceWritableKeyPath<Root, Int?> = property.appending(path: propertyValue)

				// Won't set value if property is nil
				static let combinedUnwrapped: WritableKeyPath<Root, Int> = combined
					.unwrapped(with: defaultValue)

				// Won't set value if property is nil
				static let combinedAggressivelyUnwrapped: WritableKeyPath<Root, Int> = combined
					.unwrapped(with: defaultValue, aggressive: true)

				// Won't set value if property is nil
				static let unwrapped: WritableKeyPath<Root, Int> = property
					.unwrapped(with: defaultProperty, aggressive: false)
					.appending(path: propertyValue)

				// Will set value even if property is nil
				static let aggressivelyUnwrapped: WritableKeyPath<Root, Int> = property
					.unwrapped(with: defaultProperty, aggressive: true)
					.appending(path: propertyValue)
			}
		}

		@Test
		func combined() async throws {
			// NOTE: Those keypaths are equivalent, but not equal!
			#expect(Root.kp.expression !== Root.kp.combined)

			let kp: WritableKeyPath<Root, Int?> = Root.kp.combined

			do { // getters
				#expect(Root(nil)[keyPath: kp] == nil)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func combinedUnwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.combinedUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func combinedAggressivelyUnwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.combinedAggressivelyUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func unwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.unwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func aggressivelyUnwrapped() async throws {
			let kp: WritableKeyPath<Root, Int> = Root.kp.aggressivelyUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				var sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}

			do { // setters with value
				var sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}
	}

	@MainActor
	@Suite("ReferenceTypeInReferenceType")
	struct ReferenceTypeInReferenceType {
		class Root {
			class Property {
				var value: Int

				init(_ value: Int) {
					self.value = value
				}
			}

			var property: Property?

			init(_ value: Int?) {
				self.property = value.map(Property.init)
			}

			@MainActor
			enum kp {
				static let defaultValue: Int = 69
				static var defaultProperty: Property { .init(defaultValue) }
				static let expression: KeyPath<Root, Int?> = \.property?.value

				static let property: ReferenceWritableKeyPath<Root, Property?> = \.property
				static let propertyValue: ReferenceWritableKeyPath<Property, Int> = \.value

				// Equivalent to `expression` keypath
				static let combined: ReferenceWritableKeyPath<Root, Int?> = property.appending(path: propertyValue)

				// Won't set value if property is nil
				static let combinedUnwrapped: ReferenceWritableKeyPath<Root, Int> = combined
					.unwrapped(with: defaultValue)

				// Won't set value if property is nil
				static let combinedAggressivelyUnwrapped: ReferenceWritableKeyPath<Root, Int> = combined
					.unwrapped(with: defaultValue, aggressive: true)

				// Won't set value if property is nil
				static let unwrapped: ReferenceWritableKeyPath<Root, Int> = property
					.unwrapped(with: defaultProperty, aggressive: false)
					.appending(path: propertyValue)

				// Will set value even if property is nil
				static let aggressivelyUnwrapped: ReferenceWritableKeyPath<Root, Int> = property
					.unwrapped(with: defaultProperty, aggressive: true)
					.appending(path: propertyValue)
			}
		}

		@Test
		func combined() async throws {
			// NOTE: Those keypaths are equivalent, but not equal!
			#expect(Root.kp.expression !== Root.kp.combined)

			let kp: ReferenceWritableKeyPath<Root, Int?> = Root.kp.combined

			do { // getters
				#expect(Root(nil)[keyPath: kp] == nil)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				let sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				let sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func combinedUnwrapped() async throws {
			let kp: ReferenceWritableKeyPath<Root, Int> = Root.kp.combinedUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				let sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				let sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func combinedAggressivelyUnwrapped() async throws {
			let kp: ReferenceWritableKeyPath<Root, Int> = Root.kp.combinedAggressivelyUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				let sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				let sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func unwrapped() async throws {
			let kp: ReferenceWritableKeyPath<Root, Int> = Root.kp.unwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				let sut = Root(nil)
				#expect(sut.property?.value == nil)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)
			}

			do { // setters with value
				let sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}

		@Test
		func aggressivelyUnwrapped() async throws {
			let kp: ReferenceWritableKeyPath<Root, Int> = Root.kp.aggressivelyUnwrapped

			do { // getters
				#expect(Root(nil)[keyPath: kp] == Root.kp.defaultValue)
				#expect(Root(100)[keyPath: kp] == 100)
			}

			do { // setters with nil
				let sut = Root(nil)
				#expect(sut.property?.value == nil)

				// ⚠️
				// Even tho it's aggressively unwrapped seems like
				// KeyPath internals won't perform the assignment
				// if property is nil
				sut[keyPath: kp] = 0
				#expect(sut.property?.value == nil)

				// Works correctly with non-nil props tho
				sut.property = .init(0)
				sut[keyPath: kp] = 1
				#expect(sut.property?.value == 1)
			}

			do { // setters with value
				let sut = Root(100)
				#expect(sut.property?.value == 100)

				sut[keyPath: kp] = 0
				#expect(sut.property?.value == 0)
			}
		}
	}
}
