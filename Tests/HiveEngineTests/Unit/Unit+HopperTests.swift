//
//  Unit+HopperTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitHopperTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testHopper_CanMoveAsHopper_IsTrue() {
		XCTFail("Not implemented")
	}

	func testHopper_CanMoveAsOtherBug_IsFalse() {
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testHopper_CanMoveAsHopper_IsTrue", testHopper_CanMoveAsHopper_IsTrue),
		("testHopper_CanMoveAsOtherBug_IsFalse", testHopper_CanMoveAsOtherBug_IsFalse)
	]
}
