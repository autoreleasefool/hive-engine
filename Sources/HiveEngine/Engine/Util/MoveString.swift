//
//  MoveString.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

struct MoveString {
	let movement: RelativeMovement

	init?(from: String) {
		guard let movement = RelativeMovement(notation: from) else { return nil }
		self.movement = movement
	}
}
