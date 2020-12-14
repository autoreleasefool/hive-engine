//
//  PlayCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-15.
//

import HiveEngineTestUtilities
import XCTest
@testable import HiveEngine

final class PlayCommandTests: HiveEngineTestCase {

	func testPlayCommand_ReturnsNewState() {
		let engine = Engine()
		_ = engine.send(input: "newgame Base;NotStarted;White[1]")

		guard case let .state(state) = engine.send(input: "playmove wQ") else {
			XCTFail("Command result was not valid")
			return
		}

		let expectedState = GameState()
		expectedState.apply(.place(unit: expectedState.whiteQueen, at: .origin))
		XCTAssertEqual(expectedState, state)
	}

	func testPlayCommand_UpdatesEngineState() {
		let engine = Engine()
		_ = engine.send(input: "newgame Base;NotStarted;White[1]")
		_ = engine.send(input: "playmove wQ")

		let expectedState = GameState()
		expectedState.apply(.place(unit: expectedState.whiteQueen, at: .origin))
		XCTAssertEqual(expectedState, engine.state)
	}

	func testPlayCommand_InvalidMoveFails() {
		let command = "notAPiece"
		let result = PlayCommand().invoke(command, state: stateProvider.initialGameState)

		XCTAssertEqual(.invalidCommand(command), result)
	}

	func testPlayCommand_NoInputPasses() {
		let command = ""
		guard case let .state(newState) = PlayCommand().invoke(command, state: stateProvider.shutOutState) else {
			XCTFail("Command result was not valid")
			return
		}
		XCTAssertNotEqual(stateProvider.shutOutState, newState)
	}

	func testPlayCommand_Passes() {
		let command = "pass"
		guard case let .state(newState) = PlayCommand().invoke(command, state: stateProvider.shutOutState) else {
			XCTFail("Command result was not valid")
			return
		}
		XCTAssertNotEqual(stateProvider.shutOutState, newState)
	}
}
