//
//  Unit+Hopper.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsHopper(in state: GameState, moveSet: inout Set<Movement>) {
		guard self.canMove(in: state),
			self.canCopyMoves(of: .hopper, in: state),
			let position = state.unitsInPlay[owner]?[self] else {
			return
		}

		for adjacent in position.adjacent() {
			guard state.stacks[adjacent] != nil else { continue }

			// Determine direction to extend jump in
			let difference = adjacent.subtracting(position)
			var targetPosition = adjacent

			// Extend in direction until an empty space is found
			while state.stacks[targetPosition] != nil {
				targetPosition = targetPosition.adding(difference)
			}

			moveSet.insert(.move(unit: self, to: targetPosition))
		}
	}
}
