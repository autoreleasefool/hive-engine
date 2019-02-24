//
//  Unit+LadyBug.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsLadyBug(in state: GameState) -> Set<Movement> {
		guard self.canMove(in: state) else { return [] }
		guard self.canMove(as: .ladyBug, in: state) else { return [] }
		guard let startPosition = state.units[self], startPosition != .inHand else { return [] }

		var moves = Set<Movement>()
		var visited = Set<Position>()
		var toVisit = [startPosition]
		var distance: [Position: Int] = [:]
		distance[startPosition] = 0

		let distanceOnHive = 2

		while toVisit.isNotEmpty {
			let currentPosition = toVisit.popLast()!
			visited.insert(currentPosition)

			currentPosition.adjacent()
				// Unit cannot backtrack
				.filter { visited.contains($0) == false }
				.filter {
					// Only consider positions on top of the hive
					guard let currentStack = state.stacks[currentPosition], let targetStack = state.stacks[$0] else { return false }

					// Unit can freely move to the target position
					return currentPosition.freedomOfMovement(
						to: $0,
						startingHeight: currentStack.endIndex,
						endingHeight: targetStack.endIndex,
						in: state
					)
				}.forEach { hivePosition in
					let distanceToRoot = distance[currentPosition]! + 1
					if distanceToRoot == distanceOnHive {
						// Lady Bug moves exactly 2 spaces on top of hive, then must come down
						hivePosition.adjacent().filter { downPosition in
							guard let hiveStack = state.stacks[hivePosition] else { return false }
							let downStack = state.stacks[downPosition]

							return state.playableSpaces(excluding: self).contains(downPosition) &&
								hivePosition.freedomOfMovement(
									to: downPosition,
									startingHeight: hiveStack.endIndex,
									endingHeight: downStack?.endIndex ?? 1,
									in: state
								)
							}.forEach { downPosition in moves.insert(.move(unit: self, to: downPosition)) }
					} else if distanceToRoot < distanceOnHive {
						toVisit.append(hivePosition)
						distance[hivePosition] = distanceToRoot
					}
			}
		}

		return moves
	}
}
