//
//  ValidMovesCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-16.
//

import XCTest
@testable import HiveEngine

final class ValidMovesCommandTests: HiveEngineTestCase {

	func testValidMovesCommand_RequiresState() {
		guard case let .invalidCommand(message) = ValidMovesCommand().invoke("", state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("No state provided", message)
	}

	func testValidMovesCommand_RequiresNoInput() {
		let command = "allMoves"
		guard case let .invalidCommand(message) = ValidMovesCommand().invoke(command, state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(command, message)
	}

	func testValidMovesCommand_OutputsPass() {
		let state = stateProvider.shutOutState
		guard case let .output(message) = ValidMovesCommand().invoke("", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("pass", message)
	}

	func testValidMovesCommand_HasNoMovesForFinishedGame() {
		let state = stateProvider.wonGameState
		guard case let .output(message) = ValidMovesCommand().invoke("", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("", message)
	}

	func testValidMovesCommand_OutputsAllValidMoves() {
		let state = stateProvider.initialGameState
		guard case let .output(message) = ValidMovesCommand().invoke("", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("wA1;wB1;wG1;wL;wM;wP;wQ;wS1", message)
	}

	static var allTests = [
		("testValidMovesCommand_RequiresState", testValidMovesCommand_RequiresState),
		("testValidMovesCommand_RequiresNoInput", testValidMovesCommand_RequiresNoInput),
		("testValidMovesCommand_OutputsPass", testValidMovesCommand_OutputsPass),
		("testValidMovesCommand_HasNoMovesForFinishedGame", testValidMovesCommand_HasNoMovesForFinishedGame),
		("testValidMovesCommand_OutputsAllValidMoves", testValidMovesCommand_OutputsAllValidMoves),
	]
}
