//
//  InfoCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-08.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

class InfoCommand: UHPCommand {
	private static let supportedExpansions = ["Mosquito", "Ladybug", "Pillbug"]

	required init() {}

	func invoke(_ command: String, state: GameState?) -> UHPResult {
		return .output([
			"id \(Engine.Info.name) v\(Engine.Info.version)",
			InfoCommand.supportedExpansions.joined(separator: ";"),
		].joined(separator: "\n"))
	}
}
