//
//  InfoCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-08.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

class InfoCommand: UHPCommand {
	private static let engineName = "Hive Engine"
	private static let engineVersion = "2.0.0"
	private static let supportedExpansions = ["Mosquito", "Ladybug", "Pillbug"]

	required init() {}

	func invoke(_ command: String, state: inout GameState?) -> UHPResult {
		return .output([
			"id \(InfoCommand.engineName) v\(InfoCommand.engineVersion)",
			InfoCommand.supportedExpansions.joined(separator: ";"),
		].joined(separator: "\n"))
	}
}
