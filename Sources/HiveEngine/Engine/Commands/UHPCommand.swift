//
//  UHPCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-08.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

protocol UHPCommand: AnyObject {
	init()
	func invoke(_ command: String, state: GameState?) -> UHPResult
}

struct UHPCommandParser {
	private static let commands: [String: UHPCommand.Type] = [
		"info": InfoCommand.self,
		"newgame": NewGameCommand.self,
		"play": PlayCommand.self,
		"pass": PlayCommand.self,
		"options": OptionsCommand.self,
		"undo": UndoCommand.self,
		"validmoves": ValidMovesCommand.self,
		"bestmove": BestMoveCommand.self,
	]

	static func parse(_ input: String) -> UHPCommand? {
		for (prefix, command) in UHPCommandParser.commands {
			if input.hasPrefix(prefix) {
				return command.init()
			}
		}

		return nil
	}
}
