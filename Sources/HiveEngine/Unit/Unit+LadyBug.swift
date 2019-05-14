//
//  Unit+LadyBug.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsLadyBug(in state: GameState, moveSet: inout Set<Movement>) {
		guard self.canMove(in: state),
			self.canCopyMoves(of: .ladyBug, in: state),
			let startPosition = state.unitsInPlay[owner]?[self] else {
			return
		}

		var visited: Set<Position> = []
		var toVisit = [startPosition]
		var distance: [Position: Int] = [:]
		distance[startPosition] = 0

		let distanceOnHive = 2
		let playableSpaces = state.playableSpaces()

		while toVisit.isNotEmpty {
			let currentPosition = toVisit.popLast()!
			visited.insert(currentPosition)

			for adjacentPosition in currentPosition.adjacent() {
				// Unit cannot backtrack
				guard visited.contains(adjacentPosition) == false,
					// Only consider positions on top of the hive
					let currentStack = state.stacks[currentPosition], let targetStack = state.stacks[adjacentPosition] else { continue }

				// Unit can freely move to the target position
				// When at the start position, it moves from its current height, but when on top of the stack,
				// it moves from one higher than the stack's height, to 1 higher than the target stack's height
				if currentPosition.freedomOfMovement(
					to: adjacentPosition,
					startingHeight: currentStack.endIndex &+ (currentPosition == startPosition ? 0 : 1),
					endingHeight: targetStack.endIndex &+ 1,
					in: state
					) {

					let distanceToRoot = distance[currentPosition]! &+ 1
					if distanceToRoot == distanceOnHive {
						// Lady Bug moves exactly 2 spaces on top of hive, then must come down
						for downPosition in adjacentPosition.adjacent() {
							if playableSpaces.contains(downPosition) && adjacentPosition.freedomOfMovement(to: downPosition, startingHeight: targetStack.endIndex &+ 1, endingHeight: 1, in: state) {
								moveSet.insert(.move(unit: self, to: downPosition))
							}
						}
					} else if distanceToRoot < distanceOnHive {
						toVisit.append(adjacentPosition)
						distance[adjacentPosition] = distanceToRoot
					}
				}
			}
		}
	}
}
