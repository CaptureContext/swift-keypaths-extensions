extension Optional {
	@_spi(Internals)
	public subscript(
		_forceSet forceSet: Bool = false,
		unwrappedWith defaultValue: Wrapped
	) -> Wrapped {
		get { self ?? defaultValue }
		set {
			if forceSet { self = newValue }
			else if self != nil { self = newValue }
		}
	}

	@_spi(Internals)
	public subscript(
		_forceSet forceSet: Bool = false,
		unwrappedWith defaultValue: _ForceHashable<Wrapped>
	) -> Wrapped {
		get { self ?? defaultValue.value }
		set {
			_ = self[_forceSet: forceSet, unwrappedWith: defaultValue]
			if forceSet { self = newValue }
			else if self != nil { self = newValue }
		}
	}

	@_spi(Internals)
	public subscript<Value>(_unwrappedKeyPath keyPath: KeyPath<Wrapped, Value>) -> Value? {
		get { self?[keyPath: keyPath] }
	}

	@_spi(Internals)
	public subscript<Value>(_unwrappedKeyPath keyPath: WritableKeyPath<Wrapped, Value>) -> Value? {
		get { self?[keyPath: keyPath] }
		set {
			guard let newValue else { return }
			self?[keyPath: keyPath] = newValue
		}
	}

	@_spi(Internals)
	public subscript<Value>(_unwrappedKeyPath keyPath: ReferenceWritableKeyPath<Wrapped, Value>) -> Value? {
		get { self?[keyPath: keyPath] }
		nonmutating set {
			guard let newValue else { return }
			self?[keyPath: keyPath] = newValue
		}
	}
}
