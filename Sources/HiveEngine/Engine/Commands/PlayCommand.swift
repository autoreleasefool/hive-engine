//
//  PlayCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-13.
//

class PlayCommand: UHPCommand {

	required init() {}

	func invoke(_ command: String, state: GameState?) -> UHPResult {
		guard command.count > 0 && command != "pass" else {
			state?.apply(.pass)
			return .state(state)
		}

		guard let moveString = MoveString(from: command) else {
			return .invalidCommand(command)
		}

		state?.apply(relativeMovement: moveString.movement)
		return .state(state)
	}
}
