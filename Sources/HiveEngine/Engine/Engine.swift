//
//  Engine.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-08.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

public class Engine {
	var state: GameState?

	public func send(input: String) -> UHPResult? {
		return handle(
			command: UHPCommandParser.parse(input.trimmingCharacters(in: .whitespacesAndNewlines)),
			input: input
		)
	}

	private func handle(command: UHPCommand?, input: String) -> UHPResult? {
		let commandInput: String
		if let spaceIndex = input.firstIndex(of: " ") {
			commandInput = String(input.suffix(from: input.index(after: spaceIndex)))
		} else {
			commandInput = ""
		}

		let result = command?.invoke(commandInput, state: state)

		if case .state(let state) = result {
			self.state = state
		}

		return result
	}
}

// MARK: Info

extension Engine {
	enum Info {
		public static let name = "Hive Engine"
		public static let version = "3.1.1"
	}
}
