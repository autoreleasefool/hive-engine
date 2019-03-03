//
//  Unit+Beetle.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsBeetle(in state: GameState) -> Set<Movement> {
		guard self.canMove(in: state) else { return [] }
		guard self.canMove(as: .beetle, in: state) else { return [] }

		guard let position = state.units[self],
			position != .inHand,
			let height = self.stackPosition(in: state) else {
			return []
		}

		let moves = Set(
			position.adjacent()
				// Only consider positions that the beetle would move up onto
				.intersection(state.stacks.keys)
				// Filter to positions that the piece can freely move to
				.filter {
					let endHeight = (state.stacks[$0]?.endIndex ?? 0) + 1
					return position.freedomOfMovement(to: $0, startingHeight: height, endingHeight: endHeight, in: state)
				}.compactMap {
					movement(to: $0)
				})

		return self.movesAsQueen(in: state).union(moves)
	}
}
