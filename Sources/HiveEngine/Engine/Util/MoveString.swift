//
//  MoveString.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

public struct MoveString {
	public let movement: RelativeMovement

	public init?(from: String) {
		guard let movement = RelativeMovement(notation: from) else { return nil }
		self.movement = movement
	}
}
