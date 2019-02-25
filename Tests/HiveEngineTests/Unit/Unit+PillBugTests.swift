//
//  Unit+PillBugTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitPillBugTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testPillBug_CanMoveAsPillBug_IsTrue() {
		XCTFail("Not implemented")
	}

	func testPillBug_CanMoveAsQueen_IsTrue() {
		XCTFail("Not implemented")
	}

	func testPillBug_CanMoveAsOtherBug_IsFalse() {
		XCTFail("Not implemented")
	}

	func testPillBug_CanUseSpecialAbility_IsTrue() {
		XCTFail("Not implemented")
	}

	func testNotPillBug_CanUseSpecialAbility_IsFalse() {
		XCTFail("Not implemented")
	}

	func testPillBug_CannotMovePieceJustMoved_IsTrue() {
		XCTFail("Not implemented")
	}

	func testPillBug_PieceJustYoinkedCannotMove_IsTrue() {
		XCTFail("Not implemented")
	}

	func testPillBug_WithoutFreedomOfMovementToPosition_CannotYoinkToPosition() {
		XCTFail("Not implemented")
	}

	func testPillBug_WithoutFreedomOfMovementFromPosition_CannotYoinkFromPosition() {
		XCTFail("Not implemented")
	}

	func testPillBug_YoinkCannotBreakHive() {
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testPillBug_CanMoveAsPillBug_IsTrue", testPillBug_CanMoveAsPillBug_IsTrue),
		("testPillBug_CanMoveAsQueen_IsTrue", testPillBug_CanMoveAsQueen_IsTrue),
		("testPillBug_CanMoveAsOtherBug_IsFalse", testPillBug_CanMoveAsOtherBug_IsFalse),

		("testPillBug_CanUseSpecialAbility_IsTrue", testPillBug_CanUseSpecialAbility_IsTrue),
		("testNotPillBug_CanUseSpecialAbility_IsFalse", testNotPillBug_CanUseSpecialAbility_IsFalse),

		("testPillBug_CannotMovePieceJustMoved_IsTrue", testPillBug_CannotMovePieceJustMoved_IsTrue),
		("testPillBug_PieceJustYoinkedCannotMove_IsTrue", testPillBug_PieceJustYoinkedCannotMove_IsTrue),

		("testPillBug_WithoutFreedomOfMovementToPosition_CannotYoinkToPosition", testPillBug_WithoutFreedomOfMovementToPosition_CannotYoinkToPosition),
		("testPillBug_WithoutFreedomOfMovementFromPosition_CannotYoinkFromPosition", testPillBug_WithoutFreedomOfMovementFromPosition_CannotYoinkFromPosition),
		("testPillBug_YoinkCannotBreakHive", testPillBug_YoinkCannotBreakHive)
	]
}
