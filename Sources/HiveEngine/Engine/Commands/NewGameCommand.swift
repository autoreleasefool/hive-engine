//
//  NewGameCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

class NewGameCommand: UHPCommand {

	required init() {}

	func invoke(_ command: String, state: inout GameState?) -> UHPResult {
		return .output("ok")
	}
}
