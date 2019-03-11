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
			self.canMove(as: .spider, in: state),
			let startPosition = state.unitsInPlayNext[self] else {
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
			let adjacentUnits = state.units(adjacentTo: currentPosition)

			// Only consider valid playable positions that can be reached
			currentPosition.adjacent()
				// Target position is adjacent to another piece
				.filter { playableSpaces.contains($0) }
				// Unit cannot backtrack
				.filter { visited.contains($0) == false }
				// Target position shares at least 1 adjacent unit with the current position
				.filter { adjacentUnits.intersection(state.units(adjacentTo: $0)).count > 0 }
				// Unit can freely move to the target position
				.filter { currentPosition.freedomOfMovement(to: $0, in: state) }
				.forEach {
					let distanceToRoot = distance[currentPosition]! + 1
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
