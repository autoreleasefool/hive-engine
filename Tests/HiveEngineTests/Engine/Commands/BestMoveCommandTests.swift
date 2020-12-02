//
//  BestMoveCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-16.
//

import XCTest
@testable import HiveEngine

final class BestMoveCommandTests: HiveEngineTestCase {

	func testBestMoveCommand_ReturnsValidMoveNotation() {
		let state = stateProvider.initialGameState
		guard case let .output(notation) = BestMoveCommand().invoke("", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		let relativeMovement = RelativeMovement(notation: notation)
		XCTAssertNotNil(relativeMovement)
		let movement = relativeMovement?.movement(in: state)
		XCTAssertNotNil(movement)
		XCTAssertTrue(state.availableMoves.contains(movement!))
	}

	func testBestMoveCommand_ReturnsPassIfOnlyValidMove() {
		let state = stateProvider.shutOutState
		guard case let .output(notation) = BestMoveCommand().invoke("", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("pass", notation)
	}

	func testBestMoveCommand_ReturnsNothingIfGameIsOver() {
		let state = stateProvider.wonGameState
		guard case let .output(notation) = BestMoveCommand().invoke("", state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("", notation)
	}

	func testBestMoveCommand_RequiresNoInput() {
		let command = "1"
		let state = stateProvider.wonGameState
		guard case let .invalidCommand(message) = BestMoveCommand().invoke(command, state: state) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual(command, message)
	}

	func testBestMoveCommand_RequiresState() {
		guard case let .invalidCommand(message) = BestMoveCommand().invoke("", state: nil) else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertEqual("No state provided", message)
	}

	static var allTests = [
		("testBestMoveCommand_ReturnsValidMoveNotation", testBestMoveCommand_ReturnsValidMoveNotation),
		("testBestMoveCommand_ReturnsPassIfOnlyValidMove", testBestMoveCommand_ReturnsPassIfOnlyValidMove),
		("testBestMoveCommand_ReturnsNothingIfGameIsOver", testBestMoveCommand_ReturnsNothingIfGameIsOver),
		("testBestMoveCommand_RequiresNoInput", testBestMoveCommand_RequiresNoInput),
		("testBestMoveCommand_RequiresState", testBestMoveCommand_RequiresState),
	]
}
