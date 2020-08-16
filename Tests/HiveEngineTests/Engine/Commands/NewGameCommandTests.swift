//
//  NewGameCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-15.
//

import XCTest
@testable import HiveEngine

final class NewGameCommandTests: HiveEngineTestCase {

	func testNewGameCommand_ReturnsInitialState() {
		let engine = Engine()
		guard case let .state(state) = engine.send(input: "newgame Base;NotStarted;White[1]") else {
			XCTFail("Command result was not valid")
			return
		}

		let expectedState = GameState(options: [])
		XCTAssertEqual(expectedState, state)
	}

	func testNewGameCommand_UpdatesEngineState() {
		let engine = Engine()
		_ = engine.send(input: "newgame Base;NotStarted;White[1]")

		let expectedState = GameState(options: [])
		XCTAssertEqual(expectedState, engine.state)
	}

	func testNewGameCommand_InvalidGameStringFails() {
		let command = "Invalid;NotStarted;White[1]"
		let result = NewGameCommand().invoke(command, state: nil)
		XCTAssertEqual(.invalidCommand(command), result)
	}

	func testNewGameCommand_InvalidGameTypeStringFails() {
		let command = "Invalid"
		let result = NewGameCommand().invoke(command, state: nil)
		XCTAssertEqual(.invalidCommand(command), result)
	}

	func testNewGameCommand_Base() {
		let result = NewGameCommand().invoke("Base", state: nil)
		XCTAssertEqual(.state(GameState()), result)
	}

	func testNewGameCommand_BaseMLP() {
		let result = NewGameCommand().invoke("Base+MLP", state: nil)
		XCTAssertEqual(.state(GameState(options: [.mosquito, .ladyBug, .pillBug])), result)
	}

	func testNewGameCommand_GameString() {
		let state = GameState()
		state.internalOptions.insert(.unrestrictOpening)
		state.apply(.place(unit: state.whiteSpider, at: .origin))
		state.apply(.place(unit: state.blackHopper, at: Position(x: -1, y: 1, z: 0)))
		state.apply(.place(unit: state.whiteAnt, at: Position(x: 1, y: 0, z: -1)))
		state.apply(.place(unit: state.blackSpider, at: Position(x: -2, y: 1, z: 1)))

		let result = NewGameCommand().invoke("Base;InProgress;White[3];wS1;bG1 -wS1;wA1 wS1/;bS1 /bG1", state: nil)
		XCTAssertEqual(.state(state), result)
	}

	static var allTests = [
		("testNewGameCommand_ReturnsInitialState", testNewGameCommand_ReturnsInitialState),
		("testNewGameCommand_UpdatesEngineState", testNewGameCommand_UpdatesEngineState),
		("testNewGameCommand_InvalidGameStringFails", testNewGameCommand_InvalidGameStringFails),
		("testNewGameCommand_InvalidGameTypeStringFails", testNewGameCommand_InvalidGameTypeStringFails),
		("testNewGameCommand_Base", testNewGameCommand_Base),
		("testNewGameCommand_BaseMLP", testNewGameCommand_BaseMLP),
		("testNewGameCommand_GameString", testNewGameCommand_GameString),
	]
}
