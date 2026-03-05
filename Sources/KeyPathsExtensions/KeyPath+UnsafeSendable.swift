// Copyright (c) 2020 Point-Free, Inc.
//
// Source: https://github.com/pointfreeco/swift-composable-architecture

import SwiftMarkerProtocols

public typealias _SendableAnyKeyPath = any AnyKeyPath & Sendable
public typealias _SendablePartialKeyPath<Root> = any PartialKeyPath<Root> & Sendable
public typealias _SendableKeyPath<Root, Value> = any KeyPath<Root, Value> & Sendable
public typealias _SendableWritableKeyPath<Root, Value> = any WritableKeyPath<Root, Value> & Sendable
public typealias _SendableReferenceWritableKeyPath<Root, Value> = any ReferenceWritableKeyPath<
	Root, Value
> & Sendable

// NB: Dynamic member lookup does not currently support sendable key paths and even breaks
//     autocomplete.
//
//     * https://github.com/swiftlang/swift/issues/77035
//     * https://github.com/swiftlang/swift/issues/77105
extension _AnyKeyPathProtocol {
	@_transparent
	public func unsafeSendable() -> _SendableAnyKeyPath
	where Self == AnyKeyPath {
		unsafeBitCast(self, to: _SendableAnyKeyPath.self)
	}

	@_transparent
	public func unsafeSendable<Root>() -> _SendablePartialKeyPath<Root>
	where Self == PartialKeyPath<Root> {
		unsafeBitCast(self, to: _SendablePartialKeyPath<Root>.self)
	}

	@_transparent
	public func unsafeSendable<Root, Value>() -> _SendableKeyPath<Root, Value>
	where Self == KeyPath<Root, Value> {
		unsafeBitCast(self, to: _SendableKeyPath<Root, Value>.self)
	}

	@_transparent
	public func unsafeSendable<Root, Value>() -> _SendableWritableKeyPath<Root, Value>
	where Self == WritableKeyPath<Root, Value> {
		unsafeBitCast(self, to: _SendableWritableKeyPath<Root, Value>.self)
	}

	@_transparent
	public func unsafeSendable<Root, Value>() -> _SendableReferenceWritableKeyPath<Root, Value>
	where Self == ReferenceWritableKeyPath<Root, Value> {
		unsafeBitCast(self, to: _SendableReferenceWritableKeyPath<Root, Value>.self)
	}
}
