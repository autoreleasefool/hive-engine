//
//  NewGameCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

class NewGameCommand: UHPCommand {

	required init() {}

	func invoke(_ command: String, state: GameState?) -> UHPResult {
		guard command.contains(";") else {
			return parseGameTypeString(command)
		}
		return parseGameString(command)
	}

	private func parseGameTypeString(_ command: String) -> UHPResult {
		guard let gameTypeString = GameTypeString(from: command) else {
			return .invalidCommand(command)
		}

		return .state(gameTypeString.state)
	}

	private func parseGameString(_ command: String) -> UHPResult {
		guard let gameString = GameString(from: command) else {
			return .invalidCommand(command)
		}

		return .state(gameString.state)
	}
}
