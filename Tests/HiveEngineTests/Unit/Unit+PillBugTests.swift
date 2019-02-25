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

	static var allTests = [
		("testPillBug_CanMoveAsPillBug_IsTrue", testPillBug_CanMoveAsPillBug_IsTrue),
		("testPillBug_CanMoveAsQueen_IsTrue", testPillBug_CanMoveAsQueen_IsTrue),
		("testPillBug_CanMoveAsOtherBug_IsFalse", testPillBug_CanMoveAsOtherBug_IsFalse),

		("testPillBug_CanUseSpecialAbility_IsTrue", testPillBug_CanUseSpecialAbility_IsTrue),
		("testNotPillBug_CanUseSpecialAbility_IsFalse", testNotPillBug_CanUseSpecialAbility_IsFalse)
	]
}
