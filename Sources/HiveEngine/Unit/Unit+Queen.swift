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
			self.canCopyMoves(of: .queen, in: state),
			let position = state.unitsInPlay[owner]?[self] else {
			return []
		}

		return Set(
			position.adjacent()
				.filter {
					// The new position shares at least 1 adjacent unit with a previous space
					guard let commonPositions = position.commonPositions(to: $0) else { return false }
					guard state.stacks[commonPositions.0] != nil || state.stacks[commonPositions.1] != nil else { return false }

					// Get positions that the piece is free to move to
					return position.freedomOfMovement(to: $0, in: state)
				}.map { Movement.move(unit: self, to: $0) })
	}
}
