//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Memo
import XCTest

final class MemoTests: XCTestCase {
	var effects = 0

	override func setUp() {
		effects = 0
	}


	// MARK: Evaluation

	func testEvaluatesLazilyWithAutoclosureConstruction() {
		let memo = Memo(++effects)
		XCTAssertEqual(effects, 0)
	}

	func testEvaluatesLazilyWithClosureConstruction() {
		let memo = Memo { ++self.effects }
		XCTAssertEqual(effects, 0)
	}

	func testEvaluatesEagerlyWithValueConstruction() {
		let memo = Memo(evaluated: ++effects)
		XCTAssertEqual(effects, 1)
	}


	// MARK: Memoization

	func testMemoizesWithAutoclosureConstruction() {
		let memo = Memo(++effects)
		XCTAssertEqual(memo.value, memo.value)
		XCTAssertEqual(memo.value, effects)
		XCTAssertEqual(effects, 1)
	}

	func testMemoizesWithClosureConstruction() {
		let memo = Memo { ++self.effects }
		XCTAssertEqual(memo.value, memo.value)
		XCTAssertEqual(memo.value, effects)
		XCTAssertEqual(effects, 1)
	}

	func testMemoizesWithValueConstruction() {
		let memo = Memo(evaluated: ++effects)
		XCTAssertEqual(memo.value, memo.value)
		XCTAssertEqual(memo.value, effects)
		XCTAssertEqual(effects, 1)
	}


	// MARK: Copying

	func testCopiesMemoizeTogether() {
		let memo = Memo(++effects)
		XCTAssertEqual(effects, 0)

		let copy = memo

		XCTAssertEqual(memo.value, copy.value)
		XCTAssertEqual(copy.value, effects)
		XCTAssertEqual(effects, 1)
	}


	// MARK: Map

	func testMapEvaluatesLazily() {
		let memo = Memo(++effects)
		let mapped = memo.map { $0 + ++self.effects }
		XCTAssertEqual(effects, 0)
		XCTAssertEqual(memo.value, 1)
		XCTAssertEqual(effects, 1)
		XCTAssertEqual(mapped.value, effects + memo.value)
		XCTAssertEqual(effects, 2)
	}
}
