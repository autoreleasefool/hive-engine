//
//  GameStateProvider+Mosquito.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-12-02.
//

@testable import HiveEngine

extension GameState {
	public var whiteMosquito: Unit {
		find(.mosquito, belongingTo: .white)
	}

	public var blackMosquito: Unit {
		find(.mosquito, belongingTo: .black)
	}
}

extension GameStateProvider {
	/// Produces a GameState in which the White Mosquito has a number of interesting moves available
	public var whiteMosquitoGameState: GameState {
		let state = GameState()
		self.apply(
			moves: [
				RelativeMovement(notation: "wQ")!,
			],
			to: state
		)
		return state
	}
}
