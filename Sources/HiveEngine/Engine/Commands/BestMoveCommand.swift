//
//  BestMoveCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-13.
//

class BestMoveCommand: UHPCommand {

	required init() {}

	func invoke(_ command: String, state: GameState?) -> UHPResult {
		guard command.isEmpty else {
			return .invalidCommand(command)
		}

		guard let state = state else {
			return .invalidCommand("No state provided")
		}

		return .output(state.availableMoves.first?.notation(in: state) ?? "")
	}
}
