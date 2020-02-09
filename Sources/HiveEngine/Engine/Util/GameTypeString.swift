//
//  GameTypeString.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Regex

struct GameTypeString {
	let state: GameState

	private let regex = Regex("^Base(\\+([MLP]{1,3}))?$")

	init?(from: String) {
		guard let match = regex.firstMatch(in: from) else { return nil }

		var options: Set<GameState.Option> = []

		if match.captures[1]?.contains("M") == true {
			options.insert(.mosquito)
		}
		if match.captures[1]?.contains("L") == true {
			options.insert(.ladyBug)
		}
		if match.captures[1]?.contains("P") == true {
			options.insert(.pillBug)
		}

		self.state = GameState(options: options)
	}
}
