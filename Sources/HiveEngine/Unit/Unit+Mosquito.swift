//
//  Unit+Mosquito.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsMosquito(in state: GameState) -> Set<Movement> {
		guard self.canMove(as: .mosquito, in: state) else { return [] }
		var moves = Set<Movement>()

		// Copy moves of each adjacent unit
		state.units(adjacentTo: self).forEach {
			guard $0.class != .mosquito else { return }
			moves = moves.union(self.moves(as: $0.class, in: state))
		}

		return moves
	}
}
