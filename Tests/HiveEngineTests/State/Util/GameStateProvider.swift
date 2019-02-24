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

	/// A game state after a certain number of moves
	func partialGameState(after moves: Int) -> GameState {
		return gameState(after: moves)
	}

	/// A game state with a single winner
	var wonGameState: GameState {
		return gameState(after: partialStateMoves.count - 1)
	}

	/// A game state with two winners
	lazy var tiedGameState: GameState = {
		return GameState()
	}()

	// MARK: State Builder

	private lazy var partialStateMoves: [Movement] = {
		return [
			.place(unit: initialGameState.whiteSpider, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: initialGameState.blackSpider, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: initialGameState.whiteAnt, at: .inPlay(x: -1, y: 0, z: 1)),
			.place(unit: initialGameState.blackLadyBug, at: .inPlay(x: 1, y: 1, z: -2))
		]
	}()

	/// Build a GameState for the given number of moves.
	/// Caches partially built states for faster testing.
	private func gameState(after moves: Int) -> GameState {
		precondition(moves >= 0, "Cannot provide a negative number of moves.")
		precondition(moves < partialStateMoves.count, "Must provide a value less than \(partialStateMoves.count)")

		if let cachedState = cache[moves] {
			return cachedState
		}

		if moves == 0 {
			cache[0] = initialGameState
			return cache[0]!
		}

		let previousState = gameState(after: moves - 1)
		let nextState = previousState.apply(partialStateMoves[moves - 1])
		cache[moves] = nextState
		return nextState
	}
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
