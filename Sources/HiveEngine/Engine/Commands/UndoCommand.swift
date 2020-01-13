//
//  UndoCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-13.
//

class UndoCommand: UHPCommand {

	required init() {}

	func invoke(_ command: String, state: GameState?) -> UHPResult {
		let undoCount: Int
		if command.count > 0 {
			if let count = Int(command) {
				undoCount = count
			} else {
				return .invalidCommand(command)
			}
		} else {
			undoCount = 1
		}

		if let state = state {
			(0..<undoCount).forEach { _ in state.undoMove() }
			return .state(state)
		} else {
			return .invalidCommand("No state provided")
		}
	}
}
