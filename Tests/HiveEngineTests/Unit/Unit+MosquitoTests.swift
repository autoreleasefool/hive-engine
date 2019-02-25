//
//  Unit+MosquitoTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitMosquitoTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testMosquito_CanMoveAsAdjacentBugs_IsTrue() {
		XCTFail("Not implemented")
	}

	func testMosquito_CanMoveAsNonAdjacentBugs_IsFalse() {
		XCTFail("Not implemented")
	}

	func testAnt_CanMoveAsOtherBug_IsFalse() {
		XCTFail("Not implemented")
	}

	func testMosquitoBesidePillBug_CanUseSpecialAbility_IsTrue() {
		XCTFail("Not implemented")
	}

	func testMosquitoNotBesidePillBug_CanUseSpecialAbility_IsFalse() {
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testMosquito_CanMoveAsAdjacentBugs_IsTrue", testMosquito_CanMoveAsAdjacentBugs_IsTrue),
		("testMosquito_CanMoveAsNonAdjacentBugs_IsFalse", testMosquito_CanMoveAsNonAdjacentBugs_IsFalse),
		("testAnt_CanMoveAsOtherBug_IsFalse", testAnt_CanMoveAsOtherBug_IsFalse),

		("testMosquitoBesidePillBug_CanUseSpecialAbility_IsTrue", testMosquitoBesidePillBug_CanUseSpecialAbility_IsTrue),
		("testMosquitoNotBesidePillBug_CanUseSpecialAbility_IsFalse", testMosquitoNotBesidePillBug_CanUseSpecialAbility_IsFalse)
	]
}
