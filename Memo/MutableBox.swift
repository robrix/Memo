//  Copyright © 2015 Rob Rix. All rights reserved.

final class MutableBox<T> {
	init(_ value: T) {
		self.value = value
	}

	var value: T
}
