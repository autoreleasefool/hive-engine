//
//  UndoCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-16.
//

import XCTest
@testable import HiveEngine

final class UndoCommandTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testUndoCommand_UpdatesEngineState() {
		let initialState = stateProvider.initialGameState
		stateProvider.apply(moves: 1, to: initialState)
		XCTAssertNotEqual(stateProvider.initialGameState, initialState)

		let engine = Engine()
		_ = engine.send(input: "newgame \(initialState.gameString)")

		XCTAssertEqual(initialState, engine.state)

		guard case let .state(newState) = engine.send(input: "undo 1") else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(stateProvider.initialGameState, newState)
		XCTAssertEqual(stateProvider.initialGameState, engine.state)
	}

	func testUndoCommand_RequiresState() {
		guard case let .invalidCommand(message) = UndoCommand().invoke("1", state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("No state provided", message)
	}

	func testUndoCommand_DefaultsToOneMove() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 2, to: state)

		let expectedState = stateProvider.initialGameState
		stateProvider.apply(moves: 1, to: expectedState)
		XCTAssertNotEqual(expectedState, state)

		guard case let .state(newState) = UndoCommand().invoke("", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(expectedState, newState)
	}

	func testUndoCommand_UndoesMultipleMoves() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 5, to: state)

		let expectedState = stateProvider.initialGameState
		stateProvider.apply(moves: 1, to: expectedState)
		XCTAssertNotEqual(expectedState, state)

		guard case let .state(newState) = UndoCommand().invoke("4", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(expectedState, newState)
	}

	func testUndoCommand_UndoesMovesToGameStart() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 20, to: state)

		XCTAssertNotEqual(stateProvider.initialGameState, state)

		guard case let .state(newState) = UndoCommand().invoke("20", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(stateProvider.initialGameState, newState)
	}

	func testUndoCommand_RequiresIntegerInput() {
		let command = "one"

		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 1, to: state)

		guard case let .invalidCommand(message) = UndoCommand().invoke(command, state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(command, message)
	}

	static var allTests = [
		("testUndoCommand_UpdatesEngineState", testUndoCommand_UpdatesEngineState),
		("testUndoCommand_RequiresState", testUndoCommand_RequiresState),
		("testUndoCommand_DefaultsToOneMove", testUndoCommand_DefaultsToOneMove),
		("testUndoCommand_UndoesMultipleMoves", testUndoCommand_UndoesMultipleMoves),
		("testUndoCommand_UndoesMovesToGameStart", testUndoCommand_UndoesMovesToGameStart),
		("testUndoCommand_RequiresIntegerInput", testUndoCommand_RequiresIntegerInput),
	]
}
