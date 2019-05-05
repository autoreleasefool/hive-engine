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
		guard self.canMove(in: state),
			self.canCopyMoves(of: .ladyBug, in: state),
			let startPosition = state.unitsInPlay[owner]?[self] else {
			return []
		}

		var moves = Set<Movement>()
		var visited = Set<Position>()
		var toVisit = [startPosition]
		var distance: [Position: Int] = [:]
		distance[startPosition] = 0

		let distanceOnHive = 2
		let playableSpaces = state.playableSpaces(excluding: self)

		while toVisit.isNotEmpty {
			let currentPosition = toVisit.popLast()!
			visited.insert(currentPosition)

			currentPosition.adjacent()
				.filter {
						// Unit cannot backtrack
					guard visited.contains($0) == false,
						// Only consider positions on top of the hive
						let currentStack = state.stacks[currentPosition], let targetStack = state.stacks[$0] else { return false }

					// Unit can freely move to the target position
					// When at the start position, it moves from its current height, but when on top of the stack,
					// it moves from one higher than the stack's height, to 1 higher than the target stack's height
					return currentPosition.freedomOfMovement(
						to: $0,
						startingHeight: currentStack.endIndex + (currentPosition == startPosition ? 0 : 1),
						endingHeight: targetStack.endIndex + 1,
						in: state
					)
				}.forEach { hivePosition in
					let distanceToRoot = distance[currentPosition]! + 1
					if distanceToRoot == distanceOnHive {
						// Lady Bug moves exactly 2 spaces on top of hive, then must come down
						hivePosition.adjacent().filter { downPosition in
							guard let hiveStack = state.stacks[hivePosition] else { return false }

							return playableSpaces.contains(downPosition) &&
								hivePosition.freedomOfMovement(
									to: downPosition,
									startingHeight: hiveStack.endIndex + 1,
									endingHeight: 1,
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
