//
//  Unit+AntTests.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitAntTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testAnt_CanMoveAsAnt_IsTrue() {
		XCTFail("Not implemented")
	}

	func testAnt_CanMoveAsOtherBug_IsFalse() {
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testAnt_CanMoveAsAnt_IsTrue", testAnt_CanMoveAsAnt_IsTrue),
		("testAnt_CanMoveAsOtherBug_IsFalse", testAnt_CanMoveAsOtherBug_IsFalse)
	]
}
