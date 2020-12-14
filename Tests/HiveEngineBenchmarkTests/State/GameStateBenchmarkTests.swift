//
//  GameStateBenchmarkTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-12-02.
//

import HiveEngineTestUtilities
import XCTest
@testable import HiveEngine

final class GameStateBenchmarkTests: HiveEngineTestCase {

	func testFinishedGameStateBenchmark() {
		measure {
			let state = GameState(options: [.ladyBug, .mosquito, .pillBug])
			stateProvider.apply(moves: 34, to: state)
		}
	}

	func testAvailableMovesBenchmark() {
		measure {
			for i in 0..<34 {
				let state = GameState(options: [.ladyBug, .mosquito, .pillBug])
				stateProvider.apply(moves: i, to: state)
				_ = state.availableMoves
			}
		}
	}

	func testExplorationBenchmark() {
		func explore(state: GameState, depth: Int) {
			guard depth > 0 else { return }
			for move in state.availableMoves {
				state.apply(move)
				explore(state: state, depth: depth - 1)
				state.undoMove()
			}
		}

		measure {
			let state = GameState(options: [.ladyBug, .mosquito, .pillBug])
			explore(state: state, depth: 3)
		}
	}
}
