//
//  GameStringTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-17.
//

import XCTest
@testable import HiveEngine

final class GameStringTests: HiveEngineTestCase {

	func testGameString_ParsesCorrectly() {
		let state = GameState()
		state.internalOptions.insert(.unrestrictOpening)
		state.apply(.place(unit: state.whiteSpider, at: .origin))
		state.apply(.place(unit: state.blackHopper, at: Position(x: -1, y: 1, z: 0)))
		state.apply(.place(unit: state.whiteAnt, at: Position(x: 1, y: 0, z: -1)))
		state.apply(.place(unit: state.blackSpider, at: Position(x: -2, y: 1, z: 1)))

		let gameString = GameString(from: "Base;InProgress;White[3];wS1;bG1 -wS1;wA1 wS1/;bS1 /bG1")
		XCTAssertEqual(state, gameString?.state)
	}

	func testGameString_DiscardsStateWithInvalidGameTypeString() {
		XCTAssertNotNil(GameString(from: "Base;InProgress;Black[1];wQ"))
		XCTAssertNil(GameString(from: "Base;NotInProgress;Black[1];wQ"))
	}

	func testGameString_DiscardsStateWithInvalidMoveString() {
		XCTAssertNotNil(GameString(from: "Base;InProgress;Black[1];wQ"))
		XCTAssertNil(GameString(from: "Base;InProgress;Black[1];lQ"))
	}

	func testGameString_DiscardsStateWithInvalidMove() {
		XCTAssertNotNil(GameString(from: "Base;InProgress;Black[1];wQ"))
		XCTAssertNil(GameString(from: "Base;InProgress;Black[1];bQ"))
	}

	func testGameString_TurnStringMustBeCorrect() {
		XCTAssertNotNil(GameString(from: "Base;InProgress;Black[1];wQ"))
		XCTAssertNil(GameString(from: "Base;InProgress;Black[2];wQ"))
	}

	func testGameString_MustHaveCorrectNumberOfComponents() {
		XCTAssertNil(GameString(from: "Base"))
		XCTAssertNil(GameString(from: "Base;InProgress"))
		XCTAssertNotNil(GameString(from: "Base;InProgress;White[1]"))
	}
}
