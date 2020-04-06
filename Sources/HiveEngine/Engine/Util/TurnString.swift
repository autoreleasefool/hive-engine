//
//  TurnString.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Regex

public struct TurnString: CustomStringConvertible {
	let player: Player
	let turn: Int

	public var description: String {
		return "\(player)[\(turn)]"
	}

	private static let regex = Regex(#"^(Black|White)\[(\d+)\]$"#)

	init?(from: String) {
		guard let match = TurnString.regex.firstMatch(in: from),
			let player = Player(from: match.captures[0]!),
			let turn = Int(match.captures[1]!) else { return nil }

		self.player = player
		self.turn = turn
	}
}
