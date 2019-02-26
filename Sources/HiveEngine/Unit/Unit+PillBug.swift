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
		guard self.canMove(in: state) || self.canUseSpecialAbility(in: state) else { return [] }
		guard self.canMove(as: .pillBug, in: state) else { return [] }
		guard let position = state.units[self], position != .inHand else { return [] }

		var specialAbilityMovements = Set<Movement>()
		let adjacentPlayablePositions = position.adjacent().intersection(state.playableSpaces())

		position.adjacent()
			// Find adjacent pieces which are in stacks of height 1
			.compactMap {
				guard let stack = state.stacks[$0], stack.endIndex == 1 else { return nil }
				return stack.last
			}
			// Ensure moving the unit does not violate the one hive rule
			.filter { state.oneHive(excluding: $0) }
			// Unable to move the most recently moved piece (either yoinked or moved last turn)
			.filter { $0 != state.lastMovedUnit }
			.forEach { unit in
				adjacentPlayablePositions.forEach { targetPosition in
					specialAbilityMovements.insert(.yoink(pillBug: self, unit: unit, to: targetPosition))
				}
			}

		return self.movesAsQueen(in: state).union(specialAbilityMovements)
	}
}
