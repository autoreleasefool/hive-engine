//
//  GameStateProvider.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import HiveEngine

class GameStateProvider {

	/// A new game state
	var initialGameState: GameState {
		return GameState()
	}

	/// A game state with a single winner
	var wonGameState: GameState {
		let state = initialGameState
		apply(moves: 34, to: state)
		return state
	}

	// MARK: State Builder

	private func partialStateMoves(for state: GameState) -> [Movement] {
		return [
			/* 1  */ Movement.place(unit: state.whiteSpider, at: .origin),
			/* 2  */ Movement.place(unit: state.blackSpider, at: Position(x: 0, y: 1, z: -1)),
			/* 3  */ Movement.place(unit: state.whiteAnt, at: Position(x: -1, y: 0, z: 1)),
			/* 4  */ Movement.place(unit: state.blackLadyBug, at: Position(x: 1, y: 1, z: -2)),
			/* 5  */ Movement.place(unit: state.whitePillBug, at: Position(x: 0, y: -1, z: 1)),
			/* 6  */ Movement.place(unit: state.blackHopper, at: Position(x: -1, y: 2, z: -1)),
			/* 7  */ Movement.place(unit: state.whiteQueen, at: Position(x: 1, y: -1, z: 0)),
			/* 8  */ Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 2, z: -2)),
			/* 9  */ Movement.move(unit: state.whiteAnt, to: Position(x: 0, y: 3, z: -3)),
			/* 10 */ Movement.place(unit: state.blackMosquito, at: Position(x: 2, y: 1, z: -3)),
			/* 11 */ Movement.place(unit: state.whiteBeetle, at: Position(x: -1, y: 0, z: 1)),
			/* 12 */ Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: 0, z: -1)),
			/* 13 */ Movement.move(unit: state.whiteBeetle, to: .origin),
			/* 14 */ Movement.move(unit: state.blackMosquito, to: Position(x: 2, y: -1, z: -1)),
			/* 15 */ Movement.place(unit: state.whiteMosquito, at: Position(x: -1, y: 0, z: 1)),
			/* 16 */ Movement.place(unit: state.blackBeetle, at: Position(x: 2, y: 1, z: -3)),
			/* 17 */ Movement.move(unit: state.whiteMosquito, to: Position(x: -1, y: 1, z: 0)),
			/* 18 */ Movement.move(unit: state.blackHopper, to: Position(x: -1, y: 0, z: 1)),
			/* 19 */ Movement.place(unit: state.whiteHopper, at: Position(x: 1, y: -2, z: 1)),
			/* 20 */ Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: 0, z: -1)),
			/* 21 */ Movement.yoink(pillBug: state.whitePillBug, unit: state.blackHopper, to: Position(x: -1, y: -1, z: 2)),
			/* 22 */ Movement.move(unit: state.blackBeetle, to: Position(x: 1, y: 1, z: -2)),
			/* 23 */ Movement.move(unit: state.whiteMosquito, to: Position(x: -1, y: 2, z: -1)),
			/* 24 */ Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: -1, z: 0)),
			/* 25 */ Movement.place(unit: state.whiteLadyBug, at: Position(x: -1, y: 4, z: -3)),
			/* 26 */ Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: -2, z: 1)),
			/* 27 */ Movement.move(unit: state.whiteQueen, to: Position(x: 1, y: 0, z: -1)),
			/* 28 */ Movement.move(unit: state.blackBeetle, to: Position(x: 1, y: 0, z: -1)),
			/* 29 */ Movement.move(unit: state.whiteLadyBug, to: Position(x: -1, y: 3, z: -2)),
			/* 30 */ Movement.place(unit: state.blackPillBug, at: Position(x: 2, y: 0, z: -2)),
			/* 31 */ Movement.move(unit: state.whiteBeetle, to: Position(x: 0, y: 1, z: -1)),
			/* 32 */ Movement.place(unit: state.blackAnt, at: Position(x: 2, y: -1, z: -1)),
			/* 33 */ Movement.move(unit: state.whiteBeetle, to: Position(x: 0, y: 2, z: -2)),
			/* 34 */ Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: -1, z: 0))
			// Game won by black
		]
	}

	/// Build a GameState for the given number of moves.
	func apply(moves: Int, to state: GameState) {
		let partialStateMoves = self.partialStateMoves(for: state)
		precondition(moves >= 0, "Cannot provide a negative number of moves.")
		precondition(moves <= partialStateMoves.count, "Must provide a value less than or equal to \(partialStateMoves.count)")

		for (index, element) in partialStateMoves.prefix(moves).enumerated() {
			let previousMove = state.move
			state.apply(element)
			assert(previousMove != state.move, "Move #\(index) [\(element)] was not a valid move.")
		}
	}

	private func tiedStateMoves(for state: GameState) -> [Movement] {
		return [
			/* 34 */ Movement.move(unit: state.blackAnt, to: Position(x: 1, y: 3, z: -4)),
			/* 35 */ Movement.yoink(pillBug: state.whitePillBug, unit: state.blackHopper, to: Position(x: -1, y: 0, z: 1)),
			/* 36 */ Movement.move(unit: state.blackLadyBug, to: Position(x: 1, y: -1, z: 0)),
			/* 37 */ Movement.move(unit: state.whiteBeetle, to: Position(x: 1, y: 2, z: -3)),
			/* 38 */ Movement.move(unit: state.blackAnt, to: Position(x: 2, y: -1, z: -1)),
			/* 39 */ Movement.yoink(pillBug: state.whitePillBug, unit: state.blackHopper, to: Position(x: -1, y: -1, z: 2)),
			/* 40 */ Movement.move(unit: state.blackBeetle, to: Position(x: 1, y: 1, z: -2))
			// Game ends in a tie
		]
	}

	/// A game state with two winners
	var tiedGameState: GameState {
		let state = initialGameState
		apply(moves: 33, to: state)

		for (index, element) in tiedStateMoves(for: state).enumerated() {
			let previousMove = state.move
			state.apply(element)
			assert(previousMove != state.move, "Move #\(index) [\(element)] was not a valid move.")
		}
		return state
	}

	/// Build a GameState with the given moves.
	func apply(moves: [Movement], to state: GameState) {
		for (index, element) in moves.enumerated() {
			let previousMove = state.move
			state.apply(element)
			assert(previousMove != state.move, "Move #\(index) [\(element)] was not a valid move.")
		}
	}
}

extension GameState {

	// MARK: - GameState units

	private static func unitSort(u1: Unit, u2: Unit) -> Bool {
		if u1.owner != u2.owner {
			return u1.owner < u2.owner
		} else if u1.class != u2.class {
			return u1.class < u2.class
		} else {
			return u1.index < u2.index
		}
	}

	private func find(_ class: Unit.Class, belongingTo owner: Player) -> Unit {
		return unitsInPlay[owner]!.keys.sorted(by: GameState.unitSort).first { $0.class == `class` }
			?? unitsInHand[owner]!.sorted(by: GameState.unitSort).first { $0.class == `class` }!
	}

	var whiteAnt: Unit {
		return find(.ant, belongingTo: .white)
	}

	var blackAnt: Unit {
		return find(.ant, belongingTo: .black)
	}

	var whiteBeetle: Unit {
		return find(.beetle, belongingTo: .white)
	}

	var blackBeetle: Unit {
		return find(.beetle, belongingTo: .black)
	}

	var whiteHopper: Unit {
		return find(.hopper, belongingTo: .white)
	}

	var blackHopper: Unit {
		return find(.hopper, belongingTo: .black)
	}

	var whiteLadyBug: Unit {
		return find(.ladyBug, belongingTo: .white)
	}

	var blackLadyBug: Unit {
		return find(.ladyBug, belongingTo: .black)
	}

	var whiteMosquito: Unit {
		return find(.mosquito, belongingTo: .white)
	}

	var blackMosquito: Unit {
		return find(.mosquito, belongingTo: .black)
	}

	var whitePillBug: Unit {
		return find(.pillBug, belongingTo: .white)
	}

	var blackPillBug: Unit {
		return find(.pillBug, belongingTo: .black)
	}

	var whiteQueen: Unit {
		return find(.queen, belongingTo: .white)
	}

	var blackQueen: Unit {
		return find(.queen, belongingTo: .black)
	}

	var whiteSpider: Unit {
		return find(.spider, belongingTo: .white)
	}

	var blackSpider: Unit {
		return find(.spider, belongingTo: .black)
	}
}
