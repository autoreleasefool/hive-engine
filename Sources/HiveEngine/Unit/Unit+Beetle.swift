//
//  Unit+Beetle.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsBeetle(in state: GameState, moveSet: inout Set<Movement>) {
		guard self.canMove(in: state),
			self.canCopyMoves(of: .beetle, in: state),
			let position = state.unitsInPlay[owner]?[self],
			let height = self.stackPosition(in: state) else {
			return
		}

		let hivePositions = state.stacks.keys

		for adjacentPosition in position.adjacent() {
			// Only consider positions on top of the hive
			if hivePositions.contains(adjacentPosition) {
				// Filter to positions that the piece can freely move to
				let endHeight = (state.stacks[adjacentPosition]?.endIndex ?? 0) &+ 1
				if position.freedomOfMovement(to: adjacentPosition, startingHeight: height, endingHeight: endHeight, in: state) {
					moveSet.insert(.move(unit: self, to: adjacentPosition))
				}
			} else if height > 1 &&
				position.freedomOfMovement(to: adjacentPosition, startingHeight: height, endingHeight: 1, in: state) {
				// Filter to positions that contain no other units that the beetle can drop down to
				moveSet.insert(.move(unit: self, to: adjacentPosition))
			}
		}

		self.movesAsQueen(in: state, moveSet: &moveSet)
	}
}
