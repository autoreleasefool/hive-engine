//
//  GameStateProvider+Spider.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-12-02.
//

@testable import HiveEngine

extension GameState {
	public var whiteSpider: Unit {
		find(.spider, belongingTo: .white)
	}

	public var blackSpider: Unit {
		find(.spider, belongingTo: .black)
	}
}

extension GameStateProvider {
	/// Produces a GameState in which the White Spider has a number of interesting moves available
	public var whiteSpiderGameState: GameState {
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
