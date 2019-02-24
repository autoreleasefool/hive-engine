//
//  Unit+Ant.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsAnt(in state: GameState) -> Set<Movement> {
		guard self.canMove(in: state) else { return [] }
		guard self.canMove(as: .ant, in: state) else { return [] }
		guard let position = state.units[self], position != .inHand else { return [] }

		var moves = Set<Movement>()
		var visited: Set<Position> = []
		var toVisit = [position]

		while toVisit.isNotEmpty {
			let currentPosition = toVisit.popLast()!
			visited.insert(currentPosition)

			// Only consider valid playable positions that can be reached
			currentPosition.adjacent()
				// Is adjacent to another piece
				.filter { state.playableSpaces(excluding: self).contains($0) }
				// The piece can freely move to the new position
				.filter { currentPosition.freedomOfMovement(to: $0, in: state) }
				// The position has not already been explored
				.filter { visited.contains($0) == false }
				// The new position shares at least 1 adjacent unit with a previous space
				.filter { state.units(adjacentTo: currentPosition).intersection(state.units(adjacentTo: $0)).count > 0 }
				.forEach {
					toVisit.append($0)
					moves.insert(.move(unit: self, to: $0))
				}
		}

		return moves
	}
}
