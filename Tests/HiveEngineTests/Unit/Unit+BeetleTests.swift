//
//  Unit+BeetleTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitBeetleTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testBeetle_CanMoveAsBeetle_IsTrue() {
		XCTFail("Not implemented")
	}

	func testBeetle_CanMoveAsQueen_IsTrue() {
		XCTFail("Not implemented")
	}

	func testBeetle_CanMoveAsOtherBug_IsFalse() {
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testBeetle_CanMoveAsBeetle_IsTrue", testBeetle_CanMoveAsBeetle_IsTrue),
		("testBeetle_CanMoveAsQueen_IsTrue", testBeetle_CanMoveAsQueen_IsTrue),
		("testBeetle_CanMoveAsOtherBug_IsFalse", testBeetle_CanMoveAsOtherBug_IsFalse)
	]
}
