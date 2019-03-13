//
//  GameStatePerformanceTests.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-03-11.
//

import XCTest
@testable import HiveEngine

final class GameStatePerformanceTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testFinishedGameState_Performance() {
		measure {
			_ = stateProvider.wonGameState
		}
	}

	// MARK: - Linux Tests

	static var allTests = [
		("testFinishedGameState_Performance", testFinishedGameState_Performance)
	]
}
