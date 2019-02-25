//
//  Unit+QueenTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitQueenTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testQueen_CanMoveAsQueen_IsTrue() {
		XCTFail("Not implemented")
	}

	func testQueen_CanMoveAsOtherBug_IsFalse() {
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testQueen_CanMoveAsQueen_IsTrue", testQueen_CanMoveAsQueen_IsTrue),
		("testQueen_CanMoveAsOtherBug_IsFalse", testQueen_CanMoveAsOtherBug_IsFalse)
	]
}

