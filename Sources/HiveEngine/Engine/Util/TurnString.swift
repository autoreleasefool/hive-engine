//
//  TurnString.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Regex

public struct TurnString: Equatable, CustomStringConvertible {
	public let player: Player
	public let turn: Int

	public var description: String {
		"\(player)[\(turn)]"
	}

	internal init(player: Player, turn: Int) {
		self.player = player
		self.turn = turn
	}

	private static let regex = Regex(#"^(Black|White)\[(\d+)\]$"#)

	public init?(from: String) {
		guard let match = TurnString.regex.firstMatch(in: from),
			let player = Player(from: match.captures[0]!),
			let turn = Int(match.captures[1]!) else { return nil }

		self.player = player
		self.turn = turn
	}
}
