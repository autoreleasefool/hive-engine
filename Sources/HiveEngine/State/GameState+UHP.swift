//
//  GameState+UHP.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-02-23.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

extension GameState {
	public var gameString: String {
		let baseString = "\(gameTypeString);\(gameStateString);\(turnString)"
		let moveString = self.moveString
		if moveString.count > 0 {
			return "\(baseString);\(moveString)"
		} else {
			return baseString
		}
	}

	public var gameTypeString: String {
		var string = "Base"
		var hasExpansion = false
		for option in GameState.Option.allCases where option.isExpansion && self.options.contains(option) {
			if !hasExpansion {
				hasExpansion = true
				string += "+"
			}
			string += String(option.rawValue[option.rawValue.startIndex])
		}

		return string
	}

	public var gameStateString: String {
		if self.move == 0 {
			return "NotStarted"
		}

		let winner = self.winner

		if winner.count == 2 {
			return "Draw"
		} else if winner.first == .white {
			return "WhiteWins"
		} else if winner.first == .black {
			return "BlackWins"
		}

		return "InProgress"
	}

	public var turnString: String {
		"\(self.currentPlayer)[\(self.move / 2 + 1)]"
	}

	public var moveString: String {
		moveStrings.joined(separator: ";")
	}

	public var moveStrings: [String] {
		self.updates.map { $0.notation }
	}
}
