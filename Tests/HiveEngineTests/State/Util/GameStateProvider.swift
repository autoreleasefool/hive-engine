//
//  GameStateProvider.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

@testable import HiveEngine

class GameStateProvider {

	/// A new game state
	var initialGameState: GameState {
		GameState(options: [.ladyBug, .mosquito, .pillBug])
	}

	/// A game state with a single winner
	var wonGameState: GameState {
		let state = initialGameState
		apply(moves: 34, to: state)
		return state
	}

	// A game state where the black player has no moves
	var shutOutState: GameState {
		let state = initialGameState
		apply(
			moves: [
				Movement.place(unit: state.whiteQueen, at: .origin),
				Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
				Movement.place(unit: state.whiteAnt, at: Position(x: 0, y: -1, z: 1)),
				Movement.move(unit: state.blackQueen, to: Position(x: 1, y: 0, z: -1)),
				Movement.move(unit: state.whiteAnt, to: Position(x: 2, y: 0, z: -2)),
			],
			to: state
		)
		return state
	}

	// MARK: State Builder

	private func partialStateMoves(for state: GameState) -> [RelativeMovement] {
		[
			/* 1  */ state.whiteSpider.atOrigin(),
							 // Movement.place(unit: state.whiteSpider, at: .origin),
			/* 2  */ state.blackSpider.north(of: state.whiteSpider),
							 // Movement.place(unit: state.blackSpider, at: Position(x: 0, y: 1, z: -1)),
			/* 3  */ state.whiteAnt.southWest(of: state.whiteSpider),
							 // Movement.place(unit: state.whiteAnt, at: Position(x: -1, y: 0, z: 1)),
			/* 4  */ state.blackLadyBug.northEast(of: state.blackSpider),
							 // Movement.place(unit: state.blackLadyBug, at: Position(x: 1, y: 1, z: -2)),
			/* 5  */ state.whitePillBug.south(of: state.whiteSpider),
							 // Movement.place(unit: state.whitePillBug, at: Position(x: 0, y: -1, z: 1)),
			/* 6  */ state.blackHopper.northWest(of: state.blackSpider),
							 // Movement.place(unit: state.blackHopper, at: Position(x: -1, y: 2, z: -1)),
			/* 7  */ state.whiteQueen.southEast(of: state.whiteSpider),
							 // Movement.place(unit: state.whiteQueen, at: Position(x: 1, y: -1, z: 0)),
			/* 8  */ state.blackQueen.north(of: state.blackSpider),
							 // Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 2, z: -2)),
			/* 9  */ state.whiteAnt.north(of: state.blackQueen),
							 // Movement.move(unit: state.whiteAnt, to: Position(x: 0, y: 3, z: -3)),
			/* 10 */ state.blackMosquito.northEast(of: state.blackLadyBug),
							 // Movement.place(unit: state.blackMosquito, at: Position(x: 2, y: 1, z: -3)),
			/* 11 */ state.whiteBeetle.southWest(of: state.whiteSpider),
							 // Movement.place(unit: state.whiteBeetle, at: Position(x: -1, y: 0, z: 1)),
			/* 12 */ state.blackMosquito.northEast(of: state.whiteSpider),
							 // Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: 0, z: -1)),
			/* 13 */ state.whiteBeetle.onTop(of: state.whiteSpider),
							 // Movement.move(unit: state.whiteBeetle, to: .origin),
			/* 14 */ state.blackMosquito.northEast(of: state.whiteQueen),
							 // Movement.move(unit: state.blackMosquito, to: Position(x: 2, y: -1, z: -1)),
			/* 15 */ state.whiteMosquito.northWest(of: state.whitePillBug),
							 // Movement.place(unit: state.whiteMosquito, at: Position(x: -1, y: 0, z: 1)),
			/* 16 */ state.blackBeetle.northEast(of: state.blackLadyBug),
							 // Movement.place(unit: state.blackBeetle, at: Position(x: 2, y: 1, z: -3)),
			/* 17 */ state.whiteMosquito.south(of: state.blackHopper),
							 // Movement.move(unit: state.whiteMosquito, to: Position(x: -1, y: 1, z: 0)),
			/* 18 */ state.blackHopper.south(of: state.whiteMosquito),
							 // Movement.move(unit: state.blackHopper, to: Position(x: -1, y: 0, z: 1)),
			/* 19 */ state.whiteHopper.south(of: state.whiteQueen),
							 // Movement.place(unit: state.whiteHopper, at: Position(x: 1, y: -2, z: 1)),
			/* 20 */ state.blackMosquito.north(of: state.whiteQueen),
							 // Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: 0, z: -1)),
			/* 21 */ state.blackHopper.southWest(of: state.whitePillBug),
							 // Movement.yoink(pillBug: state.whitePillBug, unit: state.blackHopper, to: Position(x: -1, y: -1, z: 2)),
			/* 22 */ state.blackBeetle.onTop(of: state.blackLadyBug),
							 // Movement.move(unit: state.blackBeetle, to: Position(x: 1, y: 1, z: -2)),
			/* 23 */ state.whiteMosquito.northWest(of: state.blackSpider),
							 // Movement.move(unit: state.whiteMosquito, to: Position(x: -1, y: 2, z: -1)),
			/* 24 */ state.blackMosquito.onTop(of: state.whiteQueen),
							 // Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: -1, z: 0)),
			/* 25 */ state.whiteLadyBug.northWest(of: state.whiteAnt),
							 // Movement.place(unit: state.whiteLadyBug, at: Position(x: -1, y: 4, z: -3)),
			/* 26 */ state.blackMosquito.onTop(of: state.whiteHopper),
							 // Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: -2, z: 1)),
			/* 27 */ state.whiteQueen.south(of: state.blackBeetle),
							 // Movement.move(unit: state.whiteQueen, to: Position(x: 1, y: 0, z: -1)),
			/* 28 */ state.blackBeetle.onTop(of: state.whiteQueen),
							 // Movement.move(unit: state.blackBeetle, to: Position(x: 1, y: 0, z: -1)),
			/* 29 */ state.whiteLadyBug.northWest(of: state.blackQueen),
							 // Movement.move(unit: state.whiteLadyBug, to: Position(x: -1, y: 3, z: -2)),
			/* 30 */ state.blackPillBug.northEast(of: state.blackBeetle),
							 // Movement.place(unit: state.blackPillBug, at: Position(x: 2, y: 0, z: -2)),
			/* 31 */ state.whiteBeetle.onTop(of: state.blackSpider),
							 // Movement.move(unit: state.whiteBeetle, to: Position(x: 0, y: 1, z: -1)),
			/* 32 */ state.blackAnt.southEast(of: state.blackBeetle),
							 // Movement.place(unit: state.blackAnt, at: Position(x: 2, y: -1, z: -1)),
			/* 33 */ state.whiteBeetle.onTop(of: state.blackQueen),
							 // Movement.move(unit: state.whiteBeetle, to: Position(x: 0, y: 2, z: -2)),
			/* 34 */ state.blackMosquito.south(of: state.blackBeetle),
							 // Movement.move(unit: state.blackMosquito, to: Position(x: 1, y: -1, z: 0)),
			// Game won by black
		]
	}

	/// Build a GameState for the given number of moves.
	func apply(moves: Int, to state: GameState) {
		let partialStateMoves = self.partialStateMoves(for: state)
		precondition(moves >= 0, "Cannot provide a negative number of moves.")
		precondition(
			moves <= partialStateMoves.count,
			"Must provide a value less than or equal to \(partialStateMoves.count)"
		)

		for (index, element) in partialStateMoves.prefix(moves).enumerated() {
			assert(state.apply(relativeMovement: element), "Move #\(index + 1) [\(element)] was not a valid move.")
		}
	}

	private func tiedStateMoves(for state: GameState) -> [RelativeMovement] {
		[
			/* 34 */ state.blackAnt.northEast(of: state.whiteAnt),
							 // Movement.move(unit: state.blackAnt, to: Position(x: 1, y: 3, z: -4)),
			/* 35 */ state.blackHopper.southWest(of: state.whiteSpider),
							 // Movement.yoink(pillBug: state.whitePillBug, unit: state.blackHopper, to: Position(x: -1, y: 0, z: 1)),
			/* 36 */ state.blackLadyBug.north(of: state.blackMosquito),
							 // Movement.move(unit: state.blackLadyBug, to: Position(x: 1, y: -1, z: 0)),
			/* 37 */ state.whiteBeetle.south(of: state.blackAnt),
							 // Movement.move(unit: state.whiteBeetle, to: Position(x: 1, y: 2, z: -3)),
			/* 38 */ state.blackAnt.south(of: state.blackPillBug),
							 // Movement.move(unit: state.blackAnt, to: Position(x: 2, y: -1, z: -1)),
			/* 39 */ state.blackHopper.southWest(of: state.whitePillBug),
							 // Movement.yoink(pillBug: state.whitePillBug, unit: state.blackHopper, to: Position(x: -1, y: -1, z: 2)),
			/* 40 */ state.blackBeetle.northEast(of: state.blackSpider),
							 // Movement.move(unit: state.blackBeetle, to: Position(x: 1, y: 1, z: -2)),
			// Game ends in a tie
		]
	}

	/// A game state with two winners
	var tiedGameState: GameState {
		let state = initialGameState
		apply(moves: 33, to: state)

		for (index, element) in tiedStateMoves(for: state).enumerated() {
			assert(state.apply(relativeMovement: element), "Move #\(index + 1) [\(element)] was not a valid move.")
		}
		return state
	}

	/// Build a GameState with the given moves.
	func apply(moves: [Movement], to state: GameState) {
		for (index, element) in moves.enumerated() {
			assert(state.apply(element), "Move #\(index + 1) [\(element)] was not a valid move.")
		}
	}

	func apply(moves: [RelativeMovement], to state: GameState) {
		for (index, element) in moves.enumerated() {
			assert(state.apply(relativeMovement: element), "Move #\(index + 1) [\(element)] was not a valid move.")
		}
	}
}

extension GameState {

	// MARK: - GameState units

	static func unitSort(u1: Unit, u2: Unit) -> Bool {
		if u1.owner != u2.owner {
			return u1.owner < u2.owner
		} else if u1.class != u2.class {
			return u1.class < u2.class
		} else {
			return u1.index < u2.index
		}
	}

	func find(_ class: Unit.Class, belongingTo owner: Player) -> Unit {
		return unitsInPlay[owner]!.keys.sorted(by: GameState.unitSort).first { $0.class == `class` }
			?? unitsInHand[owner]!.sorted(by: GameState.unitSort).first { $0.class == `class` }!
	}
}
