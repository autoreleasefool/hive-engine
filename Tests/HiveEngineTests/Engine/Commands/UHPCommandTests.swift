//
//  UHPCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import XCTest
@testable import HiveEngine

final class UHPCommandTests: HiveEngineTestCase {
	func testInfoCommand() {
		let result = InfoCommand().invoke("", state: nil)
		XCTAssertEqual(.output("id Hive Engine v2.0.0\nMosquito;Ladybug;Pillbug"), result)
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
		state.apply(.place(unit: state.whiteSpider, at: .origin))
		state.apply(.place(unit: state.blackHopper, at: Position(x: -1, y: 1, z: 0)))
		state.apply(.place(unit: state.whiteAnt, at: Position(x: 1, y: 0, z: -1)))
		state.apply(.place(unit: state.blackSpider, at: Position(x: -2, y: 1, z: 1)))

		let result = NewGameCommand().invoke("Base;InProgress;White[3];wS1;bG1 -wS1;wA1 wS1/;bS1 /bG1", state: nil)
		XCTAssertEqual(.state(state), result)
	}

	func testValidMovesCommand() {
		let state = GameState()

		let result = ValidMovesCommand().invoke("", state: state)
		XCTAssertEqual(.output("wA1;wB1;wG1;wQ;wS1"), result)
	}

	func testUndoCommand() {
		let state = GameState()
		state.apply(.place(unit: state.whiteSpider, at: .origin))
		state.apply(.place(unit: state.blackHopper, at: Position(x: -1, y: 1, z: 0)))
		state.apply(.place(unit: state.whiteAnt, at: Position(x: 1, y: 0, z: -1)))
		state.apply(.place(unit: state.blackSpider, at: Position(x: -2, y: 1, z: 1)))

		let initialResult = NewGameCommand().invoke("Base;InProgress;White[3];wS1;bG1 -wS1;wA1 wS1/;bS1 /bG1", state: nil)
		XCTAssertEqual(.state(state), initialResult)

		guard case let .state(resultState) = initialResult else {
			fatalError("Result was not a valid state.")
		}

		state.undoMove()
		state.undoMove()

		let finalResult = UndoCommand().invoke("2", state: resultState)
		XCTAssertEqual(.state(state), finalResult)
	}

	func testOptionsCommand_List() {
		let result = OptionsCommand().invoke("", state: nil)
		XCTAssertEqual(.output([
				"RestrictedOpening;bool;false;false",
				"NoFirstMoveQueen;bool;false;false",
				"AllowSpecialAbilityAfterYoink;bool;false;false",
				"DisableMovementValidation;bool;false;false",
				"DisableStandardNotation;bool;false;false",
				"TreatYoinkAsMove;bool;false;false",
			].joined(separator: "\n")), result)
	}

	func testOptionsCommand_SetValue() {
		let state = GameState(options: [.restrictedOpening, .noFirstMoveQueen])
		let result = OptionsCommand().invoke("set RestrictedOpening false", state: state)
		XCTAssertEqual(.state(GameState(options: [.noFirstMoveQueen])), result)
	}

	func testOptionsCommand_GetValue() {
		let state = GameState(options: [.disableMovementValidation])
		let firstResult = OptionsCommand().invoke("get DisableMovementValidation", state: state)
		XCTAssertEqual(.output("DisableMovementValidation;bool;true;false"), firstResult)
		let secondResult = OptionsCommand().invoke("get TreatYoinkAsMove", state: state)
		XCTAssertEqual(.output("TreatYoinkAsMove;bool;false;false"), secondResult)
	}

	static var allTests = [
		("testInfoCommand", testInfoCommand),
		("testNewGameCommand_Base", testNewGameCommand_Base),
		("testNewGameCommand_BaseMLP", testNewGameCommand_BaseMLP),
		("testNewGameCommand_GameString", testNewGameCommand_GameString),
		("testValidMovesCommand", testValidMovesCommand),
		("testUndoCommand", testUndoCommand),
		("testOptionsCommand_List", testOptionsCommand_List),
		("testOptionsCommand_SetValue", testOptionsCommand_SetValue),
		("testOptionsCommand_GetValue", testOptionsCommand_GetValue),
	]
}
