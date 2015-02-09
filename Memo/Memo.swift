//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Deferred, memoized evaluation.
public struct Memo<T> {
	// MARK: Lifecycle

	/// Constructs a `Memo` which lazily evaluates the argument.
	public init(_ unevaluated:  () -> T) {
		self.init(unevaluated: unevaluated)
	}

	/// Constructs a `Memo` which lazily evaluates the passed function.
	public init(unevaluated: () -> T) {
		self.init(state: .Unevaluated(unevaluated))
	}

	/// Constructs a `Memo` wrapping the already-evaluated argument.
	public init(evaluated: T) {
		self.init(state: .Evaluated(Box(evaluated)))
	}


	// MARK: Properties

	/// Returns the value held by the receiver, computing & memoizing it first if necessary.
	public var value: T {
		return state.value.value()
	}


	// MARK: API

	/// Returns a new `Memo` which lazily memoizes the result of applying `f` to the receiver’s value.
	public func map<U>(f: T -> U) -> Memo<U> {
		return Memo<U> { f{self.value) }
	}


	// MARK: Private

	/// Initialize with the passed `state`.
	private init(state: MemoState<T>) {
		self.state = MutableBox(state)
	}

	/// The underlying state.
	///
	/// The `enum` implements the basic semantics (either evaluated or un), while the `MutableBox` provides us with reference semantics for the memoized result.
	private let state: MutableBox<MemoState<T>>
}


// MARK: Equality.

/// Equality of `Memo`s of `Equatable` types.
///
/// We cannot declare that `Memo<T: Equatable>` conforms to `Equatable`, so this is defined ad hoc.
public func == <T: Equatable> (lhs: Memo<T>, rhs: Memo<T>) -> Bool {
	return lhs.value == rhs.value
}

/// Inequality of `Memo`s of `Equatable` types.
///
/// We cannot declare that `Memo<T: Equatable>` conforms to `Equatable`, so this is defined ad hoc.
public func != <T: Equatable> (lhs: Memo<T>, rhs: Memo<T>) -> Bool {
	return lhs.value != rhs.value
}


// MARK: Private

/// Private state for memoization.
private enum MemoState<T> {
	case Evaluated(Box<T>)
	case Unevaluated(() -> T)

	/// Return the value, computing and memoizing it first if necessary.
	mutating func value() -> T {
		switch self {
		case let Evaluated(x):
			return x.value
		case let Unevaluated(f):
			let value = f()
			self = Evaluated(Box(value))
			return value
		}
	}
}


// MARK: Imports

import Box
