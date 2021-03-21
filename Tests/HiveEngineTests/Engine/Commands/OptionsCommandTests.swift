//
//  OptionsCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-16.
//

import HiveEngineTestUtilities
import Regex
import XCTest
@testable import HiveEngine

final class OptionsCommandTests: HiveEngineTestCase {
	private static let defaultOptionsRegex = Regex(#"(\w+;bool;false;false\n?)+"#)
	private static let optionsRegex = Regex(#"(\w+;bool;(true|false);false\n?)+"#)

	func testOptionsCommand_UpdatesEngineState() {
		let engine = Engine()
		XCTAssertNil(engine.state)

		guard case let .state(state) = engine.send(input: "options set NoFirstMoveQueen true") else {
			XCTFail("Command result was not valid")
			return
		}

		let expectedState = GameState(options: [.noFirstMoveQueen])
		XCTAssertEqual(expectedState, state)
		XCTAssertEqual(expectedState, engine.state)
	}

	func testOptionsCommand_ReturnsAvailableOptionsForDefaultState() {
		guard case let .output(message) = OptionsCommand().invoke("", state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertTrue(Self.defaultOptionsRegex.matches(message))
	}

	func testOptionsCommand_ReturnsAvailableOptionsForGivenState() {
		let state = GameState(options: [.noFirstMoveQueen])
		guard case let .output(message) = OptionsCommand().invoke("", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertTrue(Self.optionsRegex.matches(message))
		XCTAssertTrue(message.contains("NoFirstMoveQueen;bool;true;false"))
	}

	func testOptionsCommand_SetsOption_ToTrue() {
		let state = GameState()
		XCTAssertFalse(state.options.contains(.noFirstMoveQueen))

		guard case let .state(firstState) = OptionsCommand().invoke("set NoFirstMoveQueen true", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertTrue(firstState?.options.contains(.noFirstMoveQueen) ?? false)

		guard case let .state(secondState) =
			OptionsCommand().invoke("set AllowSpecialAbilityAfterYoink true", state: firstState) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertTrue(secondState?.options.contains(.noFirstMoveQueen) ?? false)
		XCTAssertTrue(secondState?.options.contains(.allowSpecialAbilityAfterYoink) ?? false)
	}

	func testOptionsCommand_SetsOption_ToFalse() {
		let state = GameState(options: [.noFirstMoveQueen])
		XCTAssertTrue(state.options.contains(.noFirstMoveQueen))

		guard case let .state(firstState) = OptionsCommand().invoke("set NoFirstMoveQueen false", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertFalse(firstState?.options.contains(.noFirstMoveQueen) ?? true)
	}

	func testOptionsCommand_GetsOption() {
		let state = GameState(options: [.noFirstMoveQueen])

		guard case let .output(firstMoveQueen) = OptionsCommand().invoke("get NoFirstMoveQueen", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("NoFirstMoveQueen;bool;true;false", firstMoveQueen)

		guard case let .output(allowSpecial) =
			OptionsCommand().invoke("get AllowSpecialAbilityAfterYoink", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("AllowSpecialAbilityAfterYoink;bool;false;false", allowSpecial)
	}

	func testOptionsCommand_IgnoresInvalidCommand() {
		let command = "invalid command"
		guard case let .invalidCommand(message) = OptionsCommand().invoke(command, state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(command, message)
	}

	func testOptionsCommand_Set_IgnoresInvalidOption() {
		let command = "set invalid"
		guard case let .invalidCommand(message) = OptionsCommand().invoke(command, state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(command, message)
	}

	func testOptionsCommand_Set_RequiresValidBoolean() {
		let command = "set NoFirstMoveQueen invalid"
		guard case let .invalidCommand(message) = OptionsCommand().invoke(command, state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(command, message)
	}

	func testOptionsCommand_Get_IgnoresInvalidOption() {
		let command = "get invalid"
		guard case let .invalidCommand(message) = OptionsCommand().invoke(command, state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(command, message)
	}

	func testOptionsCommand_RequiresOptionName() {
		let command = "get"
		guard case let .invalidCommand(message) = OptionsCommand().invoke(command, state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(command, message)
	}
}
