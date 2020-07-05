//
//  GameState+UHPTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-02-23.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import XCTest
import HiveEngine

final class GameStateUHPTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	// MARK: - Initial Game State

	func testInitialGameState_GameString_IsCorrect() {
		let state = GameState(options: [])
		XCTAssertEqual("Base;NotStarted;White[1]", state.gameString)
	}

	func testInitialGameState_GameTypeString_IsCorrect() {
		let state = GameState(options: [])
		XCTAssertEqual("Base", state.gameTypeString)

		let stateWithExpansions = GameState(options: Set(GameState.Option.allCases))
		XCTAssertEqual("Base+LMP", stateWithExpansions.gameTypeString)
	}

	func testInitialGameState_GameStateString_IsCorrect() {
		let state = GameState(options: [])
		XCTAssertEqual("NotStarted", state.gameStateString)
	}

	func testInitialGameState_TurnString_IsCorrect() {
		let state = GameState(options: [])
		XCTAssertEqual("White[1]", state.turnString)
	}

	func testInitialGameState_MoveString_IsCorrect() {
		let state = GameState(options: [])
		XCTAssertEqual("", state.moveString)
	}

	func testInitialGameState_MoveStrings_IsCorrect() {
		let state = GameState(options: [])
		XCTAssertEqual([], state.moveStrings)
	}

	// MARK: - In Progress Game State

	func testPartialGameState_GameString_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 2, to: state)
		XCTAssertEqual(#"Base+LMP;InProgress;White[2];wS1;bS1 \wS1"#, state.gameString)
	}

	func testPartialGameState_GameStateString_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 12, to: state)
		XCTAssertEqual("InProgress", state.gameStateString)
	}

	func testPartialGameState_TurnString_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 13, to: state)
		XCTAssertEqual("Black[7]", state.turnString)
	}

	func testPartialGameState_MoveString_IsCorrect() {
		let state = stateProvider.initialGameState
		let moves: [Movement] = [
			.place(unit: state.whiteAnt, at: .origin),
			.place(unit: state.blackAnt, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteQueen, at: Position(x: 0, y: -1, z: 1)),
		]
		stateProvider.apply(moves: moves, to: state)

		XCTAssertEqual(#"wA1;bA1 \wA1;wQ wA1\"#, state.moveString)
	}

	func testPartialGameState_MoveStrings_IsCorrect() {
		let state = stateProvider.initialGameState
		let moves: [Movement] = [
			.place(unit: state.whiteAnt, at: .origin),
			.place(unit: state.blackAnt, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteQueen, at: Position(x: 0, y: -1, z: 1)),
		]
		stateProvider.apply(moves: moves, to: state)

		XCTAssertEqual(["wA1", #"bA1 \wA1"#, #"wQ wA1\"#], state.moveStrings)
	}

	// MARK: - Completed Game State

	func testCompletedGameState_GameStateString_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 34, to: state)
		XCTAssertEqual("BlackWins", state.gameStateString)
	}

	// MARK: - Linux Tests

	static var allTests = [
		("testInitialGameState_GameString_IsCorrect", testInitialGameState_GameString_IsCorrect),
		("testInitialGameState_GameTypeString_IsCorrect", testInitialGameState_GameTypeString_IsCorrect),
		("testInitialGameState_GameStateString_IsCorrect", testInitialGameState_GameStateString_IsCorrect),
		("testInitialGameState_TurnString_IsCorrect", testInitialGameState_TurnString_IsCorrect),
		("testInitialGameState_MoveString_IsCorrect", testInitialGameState_MoveString_IsCorrect),
		("testInitialGameState_MoveStrings_IsCorrect", testInitialGameState_MoveStrings_IsCorrect),

		("testPartialGameState_GameString_IsCorrect", testPartialGameState_GameString_IsCorrect),
		("testPartialGameState_GameStateString_IsCorrect", testPartialGameState_GameStateString_IsCorrect),
		("testPartialGameState_TurnString_IsCorrect", testPartialGameState_TurnString_IsCorrect),
		("testPartialGameState_MoveString_IsCorrect", testPartialGameState_MoveString_IsCorrect),
		("testPartialGameState_MoveStrings_IsCorrect", testPartialGameState_MoveStrings_IsCorrect),

		("testCompletedGameState_GameStateString_IsCorrect", testCompletedGameState_GameStateString_IsCorrect),
	]
}
