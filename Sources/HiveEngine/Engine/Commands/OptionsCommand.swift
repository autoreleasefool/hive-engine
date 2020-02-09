//
//  OptionsCommand.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-13.
//

class OptionsCommand: UHPCommand {

	required init() {}

	func invoke(_ command: String, state: GameState?) -> UHPResult {
		if command.isEmpty {
			return optionsList(state: state ?? GameState())
		}

		if command.hasPrefix("set") {
			return set(command, in: state ?? GameState())
		} else if command.hasPrefix("get") {
			return get(command, in: state ?? GameState())
		} else {
			return .invalidCommand(command)
		}
	}

	private func set(_ command: String, in state: GameState) -> UHPResult {
		guard let (option, value) = extractOption(from: command, hasValue: true) else { return .invalidCommand(command) }

		var options = state.options
		if value == true {
			options.insert(option)
		} else {
			options.remove(option)
		}

		return .state(GameState(from: state, withOptions: options))
	}

	private func get(_ command: String, in state: GameState) -> UHPResult {
		guard let (option, _) = extractOption(from: command, hasValue: false) else { return .invalidCommand(command) }

		return .output("\(option.rawValue);bool;\(state.options.contains(option));false")
	}

	private func optionsList(state: GameState) -> UHPResult {
		let output = GameState.Option.allCases
			.filter { $0.isModifiable }
			.map { "\($0.rawValue);bool;\(state.options.contains($0));false" }
			.joined(separator: "\n")

		return .output(output)
	}

	private func extractOption(from command: String, hasValue: Bool) -> (option: GameState.Option, value: Bool?)? {
		guard let firstSpace = command.firstIndex(of: " "),
			let lastSpace = command.lastIndex(of: " ") else { return nil }

		let optionNameBegin = command.index(after: firstSpace)

		if !hasValue {
			guard let option = GameState.Option(rawValue: String(command[optionNameBegin..<command.endIndex])) else { return nil }
			return (option: option, value: nil)
		}

		let valueBegin = command.index(after: lastSpace)

		guard let option = GameState.Option(rawValue: String(command[optionNameBegin..<lastSpace])),
			let value = Bool(String(command.suffix(from: valueBegin))) else { return nil }
		return (option: option, value: value)
	}
}
