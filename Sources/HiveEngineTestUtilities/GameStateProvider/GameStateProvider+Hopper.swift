//
//  GameStateProvider+Hopper.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-12-02.
//

@testable import HiveEngine

extension GameState {
	public var whiteHopper: Unit {
		find(.hopper, belongingTo: .white)
	}

	public var blackHopper: Unit {
		find(.hopper, belongingTo: .black)
	}
}

extension GameStateProvider {
	/// Produces a GameState in which the White Hopper has a number of interesting moves available
	public var whiteHopperGameState: GameState {
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
