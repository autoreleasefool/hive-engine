//
//  Unit+Spider.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsSpider(in state: GameState) -> Set<Movement> {
		guard self.canMove(in: state),
			self.canCopyMoves(of: .spider, in: state),
			let startPosition = state.unitsInPlay[owner]?[self] else {
			return []
		}

		let maxDistance = 3

		let playableSpaces = state.playableSpaces(excluding: self)
		var moves = Set<Movement>()
		var visited = Set<Position>()
		var toVisit = [startPosition]
		var distance: [Position: Int] = [:]
		distance[startPosition] = 0

		while toVisit.isNotEmpty {
			let currentPosition = toVisit.popLast()!
			visited.insert(currentPosition)

			// Only consider valid playable positions that can be reached
			currentPosition.adjacent()
				.filter {
					// Is adjacent to another piece and the position has not already been explored
					guard playableSpaces.contains($0) && visited.contains($0) == false else { return false }

					// The new position shares at least 1 adjacent unit with a previous space
					guard let commonPositions = currentPosition.commonPositions(to: $0) else { return false }
					guard state.stacks[commonPositions.0] != nil || state.stacks[commonPositions.1] != nil else { return false }

					// The piece can freely move to the new position
					return currentPosition.freedomOfMovement(to: $0, in: state)
				}
				.forEach {
					let distanceToRoot = distance[currentPosition]! &+ 1
					if distanceToRoot == maxDistance {
						// Spider moves exactly 3 spaces
						moves.insert(.move(unit: self, to: $0))
					} else if distanceToRoot < maxDistance {
						toVisit.append($0)
						distance[$0] = distanceToRoot
					}
				}
		}

		return moves
	}
}
