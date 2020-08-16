//
//  UHPCommandParserTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import XCTest
@testable import HiveEngine

final class UHPCommandParserTests: HiveEngineTestCase {
	func testParsesInfoCommand() {
		let command = UHPCommandParser.parse("info")
		XCTAssertNotNil(command as? InfoCommand)
	}

	func testParsesNewGameCommand() {
		let command = UHPCommandParser.parse("newgame")
		XCTAssertNotNil(command as? NewGameCommand)
	}

	func testParsesPlayCommand() {
		let command = UHPCommandParser.parse("play")
		XCTAssertNotNil(command as? PlayCommand)
	}

	func testParsesPassCommand() {
		let command = UHPCommandParser.parse("pass")
		XCTAssertNotNil(command as? PlayCommand)
	}

	func testParsesOptionsCommand() {
		let command = UHPCommandParser.parse("options")
		XCTAssertNotNil(command as? OptionsCommand)
	}

	func testParsesUndoCommand() {
		let command = UHPCommandParser.parse("undo")
		XCTAssertNotNil(command as? UndoCommand)
	}

	func testParsesValidMovesCommand() {
		let command = UHPCommandParser.parse("validmoves")
		XCTAssertNotNil(command as? ValidMovesCommand)
	}

	func testParsesBestMoveCommand() {
		let command = UHPCommandParser.parse("bestmove")
		XCTAssertNotNil(command as? BestMoveCommand)
	}


	static var allTests = [
		("testParsesInfoCommand", testParsesInfoCommand),
		("testParsesNewGameCommand", testParsesNewGameCommand),
		("testParsesPlayCommand", testParsesPlayCommand),
		("testParsesPassCommand", testParsesPassCommand),
		("testParsesOptionsCommand", testParsesOptionsCommand),
		("testParsesUndoCommand", testParsesUndoCommand),
		("testParsesValidMovesCommand", testParsesValidMovesCommand),
		("testParsesBestMoveCommand", testParsesBestMoveCommand),
	]
}
