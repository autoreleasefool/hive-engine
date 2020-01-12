//
//  PerftTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-05-02.
//

import XCTest
import HiveEngine

class PerftTests: HiveEngineTestCase {

	/// Values from https://github.com/jonthysell/Mzinga/wiki/Perft
	/// Notes:
	/// 1. The Queen Bee cannot be played on a player's first turn
	/// 2. If a player has multiple bugs of the same type in their hand, then only one is used to calculate the number of valid placements. Ie. if you have two ants in your hand, and five open positions to place a bug, you have five valid moves, not ten.
	/// 3. A player can only Pass if there are no other legal moves, and then that Pass counts as one move for the purposes of calculating perft.
	private let perftTable: [String: [Int]] = [
		"": [4, 96, 1_440, 21_600, 516_240, 12_219_480, 181_641_900], // 2_657_392_800
		"M": [5, 150, 2_610, 45_414, 1_252_800, 34_233_432],
		"L": [5, 150, 2_610, 45_414, 1_252_800, 34_233_672],
		"P": [5, 150, 2_610, 45_414, 1_255_932, 34_395_984],
		"ML": [6, 216, 4_320, 86_400, 2_725_920, 85_201_200],
		"MP": [6, 216, 4_320, 86_400, 2_730_888, 85_492_248],
		"LP": [6, 216, 4_320, 86_400, 2_730_240, 85_457_136],
		"MLP": [7, 294, 6_678, 151_686, 5_427_108, 192_353_904],
	]

	private static var perftGameStateOptions: Set<GameState.Options> {
		return [.noFirstMoveQueen, .disableMovementValidation, .disableNotation, .treatYoinkAsMove]
	}

	private func baseOptions(with: [GameState.Options] = []) -> Set<GameState.Options> {
		var gameStateOptions = PerftTests.perftGameStateOptions
		with.forEach { gameStateOptions.insert($0) }
		return gameStateOptions
	}

	/// Count the number of valid states at a certain depth by iterating all possible moves.
	private func perft(state: GameState, depth: Int) -> Int {
		guard state.move < depth else {
			return state.availableMoves.count
		}

		var perftCount = 0
		for move in state.availableMoves {
			state.apply(move)
			perftCount += perft(state: state, depth: depth)
			state.undoMove()
		}
		return perftCount
	}

	func testPerftBenchmarkPerformance() {
		measure {
			let state = GameState(options: baseOptions())
			_ = perft(state: state, depth: 4)
		}
	}

	func testPerftValidation_BaseGame() {
		let state = GameState(options: baseOptions())
		let perftReference = perftTable[""]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_Mosquito() {
		let state = GameState(options: baseOptions(with: [.mosquito]))
		let perftReference = perftTable["M"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_LadyBug() {
		let state = GameState(options: baseOptions(with: [.ladyBug]))
		let perftReference = perftTable["L"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_PillBug() {
		let state = GameState(options: baseOptions(with: [.pillBug]))
		let perftReference = perftTable["P"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_Mosquito_LadyBug() {
		let state = GameState(options: baseOptions(with: [.mosquito, .ladyBug]))
		let perftReference = perftTable["ML"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_Mosquito_PillBug() {
		let state = GameState(options: baseOptions(with: [.mosquito, .pillBug]))
		let perftReference = perftTable["MP"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_LadyBug_PillBug() {
		let state = GameState(options: baseOptions(with: [.ladyBug, .pillBug]))
		let perftReference = perftTable["LP"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	func testPerftValidation_Mosquito_LadyBug_PillBug() {
		let state = GameState(options: baseOptions(with: [.mosquito, .ladyBug, .pillBug]))
		let perftReference = perftTable["MLP"]!

		for depth in 0..<perftReference.count {
			XCTAssertEqual(perftReference[depth], perft(state: state, depth: depth))
		}
	}

	static var allTests = [
		("testPerftBenchmarkPerformance", testPerftBenchmarkPerformance),
		("testPerftValidation_BaseGame", testPerftValidation_BaseGame),
		("testPerftValidation_Mosquito", testPerftValidation_Mosquito),
		("testPerftValidation_LadyBug", testPerftValidation_LadyBug),
		("testPerftValidation_PillBug", testPerftValidation_PillBug),
		("testPerftValidation_Mosquito_LadyBug", testPerftValidation_Mosquito_LadyBug),
		("testPerftValidation_Mosquito_PillBug", testPerftValidation_Mosquito_PillBug),
		("testPerftValidation_LadyBug_PillBug", testPerftValidation_LadyBug_PillBug),
		("testPerftValidation_Mosquito_LadyBug_PillBug", testPerftValidation_Mosquito_LadyBug_PillBug)
	]
}
