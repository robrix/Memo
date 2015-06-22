//  Copyright © 2015 Rob Rix. All rights reserved.

/// A mutable reference type boxing a value.
final class MutableBox<T> {
	init(_ value: T) {
		self.value = value
	}

	var value: T
}
