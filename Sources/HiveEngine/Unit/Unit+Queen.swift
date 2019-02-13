//
//  Unit+Queen.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsQueen(in state: GameState) -> Set<Movement> {
		guard self.canMove(as: .queen, in: state) else { return [] }
		guard let position = state.units[self], position != .inHand else { return [] }

		return Set(
			position.adjacent()
				.filter {
					// Get positions that the piece is free to move to
					position.freedomOfMovement(to: $0, in: state)
				}.filter {
					// Filter to positions that do not jump across spaces
					return state.units(adjacentTo: position).intersection(state.units(adjacentTo: $0)).count > 0
				}.compactMap {
					movement(to: $0)
				})
	}
}
