//
//  UnitTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-16.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
@testable import HiveEngine

final class UnitTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	// MARK: - Unit

	func testWhenSurrounded_IsSurrounded_IsTrue() {
		let state = stateProvider.wonGameState
		XCTAssertTrue(state.whiteQueen.isSurrounded(in: state))
	}

	func testWhenNotSurrounded_IsSurrounded_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin)
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertFalse(state.whiteQueen.isSurrounded(in: state))
	}

	func testWhenTopOfStack_IsTopOfStack_IsTrue() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin)
		]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.whiteBeetle.isTopOfStack(in: state))
	}

	func testWhenBottomOfStack_IsTopOfStack_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin)
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertFalse(state.whiteQueen.isTopOfStack(in: state))
	}

	func testStackPosition_IsCorrect() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin)
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertEqual(2, state.whiteBeetle.stackPosition(in: state))
		XCTAssertEqual(1, state.whiteQueen.stackPosition(in: state))
	}

	func testWhenTopOfStackNotOneHive_CanMove_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin)
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.blackQueen.isTopOfStack(in: state))
		XCTAssertFalse(state.oneHive(excluding: state.blackQueen))
		XCTAssertFalse(state.blackQueen.canMove(in: state))
	}

	func testWhenBottomOfStackOneHive_CanMove_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin)
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertFalse(state.whiteQueen.isTopOfStack(in: state))
		XCTAssertTrue(state.oneHive(excluding: state.whiteQueen))
		XCTAssertFalse(state.whiteQueen.canMove(in: state))
	}

	func testWhenTopOfStackOneHive_CanMove_IsTrue() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin)
			]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.blackBeetle.isTopOfStack(in: state))
		XCTAssertTrue(state.oneHive(excluding: state.blackBeetle))
		XCTAssertTrue(state.blackBeetle.canMove(in: state))
	}

	func testUnitDescription_IsCorrect() {
		let state = stateProvider.initialGameState
		XCTAssertEqual("Black Ant (1)", state.blackAnt.description)
		XCTAssertEqual("White Beetle (1)", state.whiteBeetle.description)
	}

	func testUnitNotation_IsCorrect() {
		let state = stateProvider.initialGameState
		XCTAssertEqual("bA1", state.blackAnt.notation)
		XCTAssertEqual("wS2", HiveEngine.Unit(class: .spider, owner: .white, index: 2).notation)
	}

	static var allTests = [
		("testWhenSurrounded_IsSurrounded_IsTrue", testWhenSurrounded_IsSurrounded_IsTrue),
		("testWhenNotSurrounded_IsSurrounded_IsFalse", testWhenNotSurrounded_IsSurrounded_IsFalse),

		("testWhenTopOfStack_IsTopOfStack_IsTrue", testWhenTopOfStack_IsTopOfStack_IsTrue),
		("testWhenBottomOfStack_IsTopOfStack_IsFalse", testWhenBottomOfStack_IsTopOfStack_IsFalse),

		("testStackPosition_IsCorrect", testStackPosition_IsCorrect),

		("testWhenTopOfStackNotOneHive_CanMove_IsFalse", testWhenTopOfStackNotOneHive_CanMove_IsFalse),
		("testWhenBottomOfStackOneHive_CanMove_IsFalse", testWhenBottomOfStackOneHive_CanMove_IsFalse),
		("testWhenTopOfStackOneHive_CanMove_IsTrue", testWhenTopOfStackOneHive_CanMove_IsTrue),

		("testUnitDescription_IsCorrect", testUnitDescription_IsCorrect),
		("testUnitNotation_IsCorrect", testUnitNotation_IsCorrect)
	]
}
