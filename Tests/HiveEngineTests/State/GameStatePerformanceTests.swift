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
			let state = GameState(options: [.ladyBug, .mosquito, .pillBug, .disableMovementValidation])
			stateProvider.apply(moves: 34, to: state)
		}
	}

	func testAvailableMoves_Performance() {
		measure {
			for i in 0..<34 {
				let state = GameState(options: [.ladyBug, .mosquito, .pillBug, .disableMovementValidation])
				stateProvider.apply(moves: i, to: state)
				_ = state.availableMoves
			}
		}
	}

	func testExploration_Performance() {
		func explore(state: GameState, depth: Int) {
			guard depth > 0 else { return }
			for move in state.availableMoves {
				state.apply(move)
				explore(state: state, depth: depth &- 1)
				state.undoMove()
			}
		}

		measure {
			let state = GameState(options: [.ladyBug, .mosquito, .pillBug, .disableMovementValidation])
			explore(state: state, depth: 3)
		}
	}

	// MARK: - Linux Tests

	static var allTests = [
		("testFinishedGameState_Performance", testFinishedGameState_Performance),
		("testAvailableMoves_Performance", testAvailableMoves_Performance),
		("testExploration_Performance", testExploration_Performance)
	]
}
