//
//  Unit+PillBug.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsPillBug(in state: GameState, moveSet: inout Set<Movement>) {
		let moveable = self.canMove(in: state)
		let hasSpecialAbility = self.canUseSpecialAbility(in: state)
		guard moveable || hasSpecialAbility,
			self.canCopyMoves(of: .pillBug, in: state),
			let position = state.unitsInPlay[owner]?[self] else {
			return
		}

		// Find empty adjacent spaces which have freedom of movement from top of pill bug to the position
		let playableSpaces = state.playableSpaces()
		var adjacentPlayablePositions: Set<Position> = []
		for adjacentPosition in position.adjacent() {
			if playableSpaces.contains(adjacentPosition) &&
				position.freedomOfMovement(to: adjacentPosition, startingHeight: 2, endingHeight: 1, in: state) {
				adjacentPlayablePositions.insert(adjacentPosition)
			}
		}

		for adjacent in position.adjacent() {
				// Find adjacent pieces which are in stacks of height 1
			guard let stack = state.stacks[adjacent], stack.endIndex == 1,
				// Ensure freedom of movement from the position to the top of the pill bug
				adjacent.freedomOfMovement(to: position, startingHeight: 1, endingHeight: 2, in: state),
				// Get the unit at the top of the stack
				let unit = stack.last,
				// Ensure moving the unit does not violate the one hive rule
				state.oneHive(excluding: unit),
				// Unable to move the most recently moved piece (either yoinked, placed, or moved last turn)
				unit != state.lastUnitMoved
				else { continue }

			for targetPosition in adjacentPlayablePositions {
				moveSet.insert(.yoink(pillBug: self, unit: unit, to: targetPosition))
			}
		}

		guard moveable else { return }
		self.movesAsQueen(in: state, moveSet: &moveSet)
	}
}
