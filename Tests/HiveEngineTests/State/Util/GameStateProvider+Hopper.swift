//
//  GameStateProvider+Hopper.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-12-02.
//

@testable import HiveEngine

extension GameState {
	var whiteHopper: Unit {
		find(.hopper, belongingTo: .white)
	}

	var blackHopper: Unit {
		find(.hopper, belongingTo: .black)
	}
}

extension GameStateProvider {
	/// Produces a GameState in which the White Hopper has a number of interesting moves available
	var whiteHopperGameState: GameState {
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
