//
//  Unit+Beetle.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsBeetle(in state: GameState, moveSet: inout Set<Movement>) {
		guard self.canMove(in: state),
			self.canCopyMoves(of: .beetle, in: state),
			let position = state.unitsInPlay[owner]?[self],
			let height = self.stackPosition(in: state) else {
			return
		}

		let hivePositions = state.stacks.keys
		position.adjacent()
			.filter {
				// Only consider positions on top of the hive
				guard hivePositions.contains($0) else { return false }

				// Filter to positions that the piece can freely move to
				let endHeight = (state.stacks[$0]?.endIndex ?? 0) &+ 1
				return position.freedomOfMovement(to: $0, startingHeight: height, endingHeight: endHeight, in: state)
			}.forEach { moveSet.insert(.move(unit: self, to: $0)) }

		let playableSpaces = state.playableSpaces()
		if height > 1 {
			position.adjacent()
				.filter {
						// Only consider positions down from the hive
					return playableSpaces.contains($0) &&
						// Filter to positions that the piece can freely move to
						position.freedomOfMovement(to: $0, startingHeight: height, endingHeight: 1, in: state)

				}.forEach { moveSet.insert(.move(unit: self, to: $0)) }
		}

		self.movesAsQueen(in: state, moveSet: &moveSet)
	}
}
