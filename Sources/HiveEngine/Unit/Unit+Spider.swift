//
//  Unit+Spider.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsSpider(in state: GameState, moveSet: inout Set<Movement>) {
		guard self.canMove(in: state),
			self.canCopyMoves(of: .spider, in: state),
			let startPosition = state.unitsInPlay[owner]?[self] else {
			return
		}

		let maxDistance = 3

		let playableSpaces = state.playableSpaces(excluding: self)
		var visited: Set<Position> = []
		var toVisit = [startPosition]
		var distance: [Position: Int] = [:]
		distance[startPosition] = 0

		while toVisit.isEmpty == false {
			let currentPosition = toVisit.popLast()!
			visited.insert(currentPosition)

			// Only consider valid playable positions that can be reached
			for adjacentPosition in currentPosition.adjacent() {
					// Is adjacent to another piece and the position has not already been explored
				guard playableSpaces.contains(adjacentPosition) && visited.contains(adjacentPosition) == false,
					// The new position shares at least 1 adjacent unit with a previous space
					let commonPositions = currentPosition.commonPositions(to: adjacentPosition),
					state.stacks[commonPositions.0] != nil || state.stacks[commonPositions.1] != nil,
					// The piece can freely move to the new position
					currentPosition.freedomOfMovement(to: adjacentPosition, in: state) else { continue }

				let distanceToRoot = distance[currentPosition]! &+ 1
				if distanceToRoot == maxDistance {
					// Spider moves exactly 3 spaces
					moveSet.insert(.move(unit: self, to: adjacentPosition))
				} else if distanceToRoot < maxDistance {
					toVisit.append(adjacentPosition)
					distance[adjacentPosition] = distanceToRoot
				}
			}
		}
	}
}
