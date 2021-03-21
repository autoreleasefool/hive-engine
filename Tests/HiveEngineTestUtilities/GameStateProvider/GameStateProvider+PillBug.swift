//
//  GameStateProvider+PillBug.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-12-02.
//

@testable import HiveEngine

extension GameState {
	public var whitePillBug: Unit {
		find(.pillBug, belongingTo: .white)
	}

	public var blackPillBug: Unit {
		find(.pillBug, belongingTo: .black)
	}
}

extension GameStateProvider {
	/// Produces a GameState in which the White Pill Bug has a number of interesting moves available
	public var whitePillBugGameState: GameState {
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
