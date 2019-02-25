//
//  GameStateProvider.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import HiveEngine

class GameStateProvider {

	private var cache: [Int: GameState] = [:]

	/// A new game state
	let initialGameState = GameState()

	/// A game state with a single winner
	var wonGameState: GameState {
		return gameState(after: partialStateMoves.count)
	}

	private var whiteAnt: Unit!
	private var whiteBeetle: Unit!
	private var whiteHopper: Unit!
	private var whiteLadyBug: Unit!
	private var whiteMosquito: Unit!
	private var whitePillBug: Unit!
	private var whiteQueen: Unit!
	private var whiteSpider: Unit!
	private var blackAnt: Unit!
	private var blackBeetle: Unit!
	private var blackHopper: Unit!
	private var blackLadyBug: Unit!
	private var blackMosquito: Unit!
	private var blackPillBug: Unit!
	private var blackQueen: Unit!
	private var blackSpider: Unit!

	init() {
		whiteAnt = initialGameState.whiteAnt
		whiteBeetle = initialGameState.whiteBeetle
		whiteHopper = initialGameState.whiteHopper
		whiteLadyBug = initialGameState.whiteLadyBug
		whiteMosquito = initialGameState.whiteMosquito
		whitePillBug = initialGameState.whitePillBug
		whiteQueen = initialGameState.whiteQueen
		whiteSpider = initialGameState.whiteSpider
		blackAnt = initialGameState.blackAnt
		blackBeetle = initialGameState.blackBeetle
		blackHopper = initialGameState.blackHopper
		blackLadyBug = initialGameState.blackLadyBug
		blackMosquito = initialGameState.blackMosquito
		blackPillBug = initialGameState.blackPillBug
		blackQueen = initialGameState.blackQueen
		blackSpider = initialGameState.blackSpider
	}

	// MARK: State Builder

	// Hopper: black, 9 + black, 21 (can't move after yoink)
	// Spider: black, 3
	// Lady Bug: black, 9,
	// Queen: white, 9
	// Beetle: white, 12
	// Mosquito: black, 13, black, 19, black 23 (can't move to 0, 1, -1)
	// Pill Bug: white, 16 (can move mosquito, not others) + white, 18 (can't move any -- hopper just moved),
	// Ant: white, 14
	// Can place black units at 2,-1,-1 and 2,0,-2 after move 29

	private lazy var partialStateMoves: [Movement] = {
		return [
			/* 1  */ Movement.place(unit: whiteSpider, at: Position.inPlay(x: 0, y: 0, z: 0)),
			/* 2  */ Movement.place(unit: blackSpider, at: Position.inPlay(x: 0, y: 1, z: -1)),
			/* 3  */ Movement.place(unit: whiteAnt, at: Position.inPlay(x: -1, y: 0, z: 1)),
			/* 4  */ Movement.place(unit: blackLadyBug, at: Position.inPlay(x: 1, y: 1, z: -2)),
			/* 5  */ Movement.place(unit: whitePillBug, at: Position.inPlay(x: 0, y: -1, z: 1)),
			/* 6  */ Movement.place(unit: blackHopper, at: Position.inPlay(x: -1, y: 2, z: -1)),
			/* 7  */ Movement.place(unit: whiteQueen, at: Position.inPlay(x: 1, y: -1, z: 0)),
			/* 8  */ Movement.place(unit: blackQueen, at: Position.inPlay(x: 0, y: 2, z: -2)),
			/* 9  */ Movement.move(unit: whiteAnt, to: Position.inPlay(x: 0, y: 3, z: -3)),
			/* 10 */ Movement.place(unit: blackMosquito, at: Position.inPlay(x: 2, y: 1, z: -3)),
			/* 11 */ Movement.place(unit: whiteBeetle, at: Position.inPlay(x: -1, y: 0, z: 1)),
			/* 12 */ Movement.move(unit: blackMosquito, to: Position.inPlay(x: 1, y: 0, z: -1)),
			/* 13 */ Movement.move(unit: whiteBeetle, to: Position.inPlay(x: 0, y: 0, z: 0)),
			/* 14 */ Movement.move(unit: blackMosquito, to: Position.inPlay(x: 2, y: -1, z: -1)),
			/* 15 */ Movement.place(unit: whiteMosquito, at: Position.inPlay(x: -1, y: 0, z: 1)),
			/* 16 */ Movement.place(unit: blackBeetle, at: Position.inPlay(x: 2, y: 1, z: -3)),
			/* 17 */ Movement.move(unit: whiteMosquito, to: Position.inPlay(x: -1, y: 1, z: 0)),
			/* 18 */ Movement.move(unit: blackHopper, to: Position.inPlay(x: -1, y: 0, z: 1)),
			/* 19 */ Movement.place(unit: whiteHopper, at: Position.inPlay(x: 1, y: -2, z: 1)),
			/* 20 */ Movement.move(unit: blackMosquito, to: Position.inPlay(x: 1, y: 0, z: -1)),
			/* 21 */ Movement.yoink(pillBug: whitePillBug, unit: blackHopper, to: Position.inPlay(x: -1, y: -1, z: 2)),
			/* 22 */ Movement.move(unit: blackBeetle, to: Position.inPlay(x: 1, y: 1, z: -2)),
			/* 23 */ Movement.move(unit: whiteMosquito, to: Position.inPlay(x: -1, y: 2, z: -1)),
			/* 24 */ Movement.move(unit: blackMosquito, to: Position.inPlay(x: 1, y: -1, z: 0)),
			/* 25 */ Movement.place(unit: whiteLadyBug, at: Position.inPlay(x: -1, y: 4, z: -3)),
			/* 26 */ Movement.move(unit: blackMosquito, to: Position.inPlay(x: 1, y: -2, z: 1)),
			/* 27 */ Movement.move(unit: whiteQueen, to: Position.inPlay(x: 1, y: 0, z: -1)),
			/* 28 */ Movement.move(unit: blackBeetle, to: Position.inPlay(x: 1, y: 0, z: -1)),
			/* 29 */ Movement.move(unit: whiteLadyBug, to: Position.inPlay(x: -1, y: 3, z: -2)),
			/* 30 */ Movement.place(unit: blackPillBug, at: Position.inPlay(x: 2, y: 0, z: -2)),
			/* 31 */ Movement.move(unit: whiteBeetle, to: Position.inPlay(x: 0, y: 1, z: -1)),
			/* 32 */ Movement.place(unit: blackAnt, at: Position.inPlay(x: 2, y: -1, z: -1)),
			/* 33 */ Movement.move(unit: whiteBeetle, to: Position.inPlay(x: 0, y: 2, z: -2)),
			/* 34 */ Movement.move(unit: blackMosquito, to: Position.inPlay(x: 1, y: -1, z: 0))
			// Game won by black
		]
	}()

	/// Build a GameState for the given number of moves.
	/// Caches partially built states for faster testing.
	func gameState(after move: Int) -> GameState {
		precondition(move >= 0, "Cannot provide a negative number of moves.")
		precondition(move <= partialStateMoves.count, "Must provide a value less than or equal to \(partialStateMoves.count)")

		if let cachedState = cache[move] {
			return cachedState
		}

		if move == 0 {
			cache[0] = initialGameState
			return cache[0]!
		}

		let previousState = gameState(after: move - 1)
		let nextState = previousState.apply(partialStateMoves[move - 1])
		assert(previousState != nextState, "Move #\(move) [\(partialStateMoves[move - 1])] was not a valid move.")
		cache[move] = nextState
		return nextState
	}

	/// A game state with two winners
	private lazy var tiedStateMoves: [Movement] = {
		return [
			/* 34 */ Movement.move(unit: blackAnt, to: Position.inPlay(x: 1, y: 3, z: -4)),
			/* 35 */ Movement.yoink(pillBug: whitePillBug, unit: blackHopper, to: Position.inPlay(x: -1, y: 0, z: 1)),
			/* 36 */ Movement.move(unit: blackLadyBug, to: Position.inPlay(x: 1, y: -1, z: 0)),
			/* 37 */ Movement.move(unit: whiteBeetle, to: Position.inPlay(x: 1, y: 2, z: -3)),
			/* 38 */ Movement.move(unit: blackAnt, to: Position.inPlay(x: 2, y: -1, z: -1)),
			/* 39 */ Movement.yoink(pillBug: whitePillBug, unit: blackHopper, to: Position.inPlay(x: -1, y: -1, z: 2)),
			/* 40 */ Movement.move(unit: blackBeetle, to: Position.inPlay(x: 1, y: 1, z: -2))
			// Game ends in a tie
		]
	}()

	/// A game state with two winners
	lazy var tiedGameState: GameState = {
		var state = gameState(after: partialStateMoves.count - 1)
		tiedStateMoves.forEach {
			assert(state != state.apply($0), "\($0) was not a valid move.")
			state = state.apply($0)
		}
		return state
	}()
}

extension GameState {

	// MARK: - GameState units

	private func find(_ class: Unit.Class, belongingTo owner: Player) -> Unit {
		return units.keys
				.filter { $0.owner == owner && $0.class == `class` }
				.sorted { $0.identifier.uuidString < $1.identifier.uuidString }
				.first!
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
