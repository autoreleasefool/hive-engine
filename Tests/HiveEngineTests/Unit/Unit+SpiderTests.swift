//
//  Unit+SpiderTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitSpiderTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testSpider_CanMoveAsSpider_IsTrue() {
		XCTFail("Not implemented")
	}

	func testSpider_CanMoveAsOtherBug_IsFalse() {
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testSpider_CanMoveAsSpider_IsTrue", testSpider_CanMoveAsSpider_IsTrue),
		("testSpider_CanMoveAsOtherBug_IsFalse", testSpider_CanMoveAsOtherBug_IsFalse)
	]
}
