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
		guard self.canMove(in: state),
			self.canMove(as: .queen, in: state),
			let position = state.unitsInPlay[owner]?[self] else {
			return []
		}
		let adjacentUnits = state.units(adjacentTo: position)

		return Set(
			position.adjacent()
				.filter {
					// Filter to positions that do not jump across spaces
					return adjacentUnits.intersection(state.units(adjacentTo: $0)).count > 0
				}.filter {
					// Get positions that the piece is free to move to
					position.freedomOfMovement(to: $0, in: state)
				}.compactMap {
					movement(to: $0)
				})
	}
}
