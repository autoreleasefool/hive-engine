//
//  GameStateProvider+Beetle.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-12-02.
//

@testable import HiveEngine

extension GameState {
	var whiteBeetle: Unit {
		find(.beetle, belongingTo: .white)
	}

	var blackBeetle: Unit {
		find(.beetle, belongingTo: .black)
	}
}

extension GameStateProvider {
	/// Produces a GameState in which the White Beetle has a number of interesting moves available
	var whiteBeetleGameState: GameState {
		let state = GameState()
		self.apply(
			moves: [
				RelativeMovement(unit: state.whiteQueen, adjacentTo: nil),
				RelativeMovement(unit: state.blackQueen, adjacentTo: (state.whiteQueen, .south)),
				RelativeMovement(unit: state.whiteBeetle, adjacentTo: (state.whiteQueen, .northEast)),
				RelativeMovement(unit: state.blackAnt, adjacentTo: (state.blackQueen, .southEast)),
				RelativeMovement(unit: state.whiteBeetle, adjacentTo: (state.whiteQueen, .southEast)),
				RelativeMovement(unit: state.blackBeetle, adjacentTo: (state.blackQueen, .southWest)),
			],
			to: state
		)
		return state
	}
}
