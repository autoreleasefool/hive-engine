//
//  ValidMovesCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-13.
//

class ValidMovesCommand: UHPCommand {

	required init() {}

	func invoke(_ command: String, state: GameState?) -> UHPResult {
		guard command.isEmpty else {
			return .invalidCommand(command)
		}

		guard let state = state else {
			return .invalidCommand("No state provided")
		}

		return .output(state.availableMoves
			.map({ $0.notation(in: state) })
			.sorted()
			.joined(separator: ";")
		)
	}
}
