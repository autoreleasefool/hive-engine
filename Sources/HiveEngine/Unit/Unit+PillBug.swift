//
//  Unit+PillBug.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsPillBug(in state: GameState) -> Set<Movement> {
		guard self.canMove(in: state) || self.canUseSpecialAbility(in: state),
			self.canMove(as: .pillBug, in: state),
			let position = state.unitsInPlay[owner]?[self] else {
			return []
		}

		var specialAbilityMovements = Set<Movement>()

		// Find empty adjacent spaces which have freedom of movement from top of pill bug to the position
		let adjacentPlayablePositions = Set(position.adjacent()
			.filter { position.freedomOfMovement(to: $0, startingHeight: 2, endingHeight: 1, in: state) })
			.intersection(state.playableSpaces())

		position.adjacent()
			.compactMap {
					// Find adjacent pieces which are in stacks of height 1
				guard let stack = state.stacks[$0], stack.endIndex == 1,
					// Ensure freedom of movement from the position to the top of the pill bug
					$0.freedomOfMovement(to: position, startingHeight: 1, endingHeight: 2, in: state),
					// Get the unit at the top of the stack
					let unit = stack.last,
					// Ensure moving the unit does not violate the one hive rule
					state.oneHive(excluding: unit),
					// Unable to move the most recently moved piece (either yoinked or moved last turn)
					state.currentPlayer != state.previousMoves.last?.player && unit != state.previousMoves.last?.movement.movedUnit
					else { return nil }
				return unit
			}
			.forEach { unit in
				adjacentPlayablePositions.forEach { targetPosition in
					specialAbilityMovements.insert(.yoink(pillBug: self, unit: unit, to: targetPosition))
				}
			}

		return self.movesAsQueen(in: state).union(specialAbilityMovements)
	}
}
