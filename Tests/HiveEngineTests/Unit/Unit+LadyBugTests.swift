//
//  Unit+LadyBugTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitLadyBugTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testLadyBug_CanMoveAsLadyBug_IsTrue() {
		XCTFail("Not implemented")
	}

	func testLadyBug_CanMoveAsOtherBug_IsFalse() {
		XCTFail("Not implemented")
	}

	func testLadyBugMoves_AreCorrect() {
		XCTFail("Not implemented")
	}

	func testLadyBug_WithoutFreedomOfMovement_CannotMove() {
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testLadyBug_CanMoveAsLadyBug_IsTrue", testLadyBug_CanMoveAsLadyBug_IsTrue),
		("testLadyBug_CanMoveAsOtherBug_IsFalse", testLadyBug_CanMoveAsOtherBug_IsFalse),

		("testLadyBugMoves_AreCorrect", testLadyBugMoves_AreCorrect)
	]
}
