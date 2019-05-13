//
//  Unit+Mosquito.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsMosquito(in state: GameState, moveSet: inout Set<Movement>) {
		guard self.canMove(in: state) || self.canUseSpecialAbility(in: state),
			self.canCopyMoves(of: .mosquito, in: state),
			let height = self.stackPosition(in: state) else {
			return
		}

		if height > 1 {
			self.movesAsBeetle(in: state, moveSet: &moveSet)
		} else {
			// Copy moves of each adjacent unit
			for unit in state.units(adjacentTo: self) {
				guard unit.class != .mosquito else { continue }
				self.moves(as: unit.class, in: state, moveSet: &moveSet)
			}

		}
	}
}
