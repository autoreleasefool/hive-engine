//
//  Unit+Queen.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsQueen(in state: GameState, moveSet: inout Set<Movement>) {
		guard self.canMove(in: state),
			self.canCopyMoves(of: .queen, in: state),
			let position = state.unitsInPlay[owner]?[self] else {
			return
		}

		for adjacent in position.adjacent() {
			// The new position shares at least 1 adjacent unit with a previous space
			guard let commonPositions = position.commonPositions(to: adjacent),
				state.stacks[commonPositions.0] != nil || state.stacks[commonPositions.1] != nil,
				// Get positions that the piece is free to move to
				position.freedomOfMovement(to: adjacent, in: state) else { continue }

			moveSet.insert(.move(unit: self, to: adjacent))
		}
	}
}
