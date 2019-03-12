//
//  Unit+Beetle.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsBeetle(in state: GameState) -> Set<Movement> {
		guard self.canMove(in: state),
			self.canMove(as: .beetle, in: state),
			let position = state.unitsInPlay[owner]?[self],
			let height = self.stackPosition(in: state) else {
			return []
		}

		let hivePositions = state.stacks.keys
		let movesOnTopOfHive =
			position.adjacent()
				.filter {
					// Only consider positions on top of the hive
					guard hivePositions.contains($0) else { return false }

					// Filter to positions that the piece can freely move to
					let endHeight = (state.stacks[$0]?.endIndex ?? 0) + 1
					return position.freedomOfMovement(to: $0, startingHeight: height, endingHeight: endHeight, in: state)
				}.compactMap {
					movement(to: $0)
				}

		let playableSpaces = state.playableSpaces()
		var movesDownFromHive: [Movement] = []
		if height > 1 {
			movesDownFromHive.append(contentsOf:
				position.adjacent()
					.filter {
							// Only consider positions down from the hive
						return playableSpaces.contains($0) &&
							// Filter to positions that the piece can freely move to
							position.freedomOfMovement(to: $0, startingHeight: height, endingHeight: 1, in: state)

					}
					.compactMap { movement(to: $0) }
			)
		}

		var allMoves = self.movesAsQueen(in: state)
		movesDownFromHive.forEach { allMoves.insert($0) }
		movesOnTopOfHive.forEach { allMoves.insert($0) }
		return allMoves
	}
}
