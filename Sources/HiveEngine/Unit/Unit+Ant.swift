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
		guard self.canMove(in: state),
			self.canMove(as: .ant, in: state),
			let position = state.unitsInPlay[owner]?[self] else {
			return []
		}

		let playableSpaces = state.playableSpaces(excluding: self)

		var moves = Set<Movement>()
		var visited: Set<Position> = []
		var toVisit = [position]

		while toVisit.isNotEmpty {
			let currentPosition = toVisit.popLast()!
			visited.insert(currentPosition)
			let adjacentUnits = state.units(adjacentTo: currentPosition)

			// Only consider valid playable positions that can be reached
			currentPosition.adjacent()
				.filter {
					// Is adjacent to another piece
					return playableSpaces.contains($0) &&
						// The position has not already been explored
						visited.contains($0) == false &&
						// The new position shares at least 1 adjacent unit with a previous space
						adjacentUnits.intersection(state.units(adjacentTo: $0)).count > 0 &&
						// The piece can freely move to the new position
						currentPosition.freedomOfMovement(to: $0, in: state)
				}
				.forEach {
					toVisit.append($0)
					moves.insert(.move(unit: self, to: $0))
				}
		}

		return moves
	}
}
