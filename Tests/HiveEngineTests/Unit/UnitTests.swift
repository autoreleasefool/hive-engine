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

	func testGetMovementToPositionInPlay_IsCorrect() {
		let unit = stateProvider.initialGameState.whiteAnt
		let position: Position = .inPlay(x: 0, y: 2, z: -2)
		let expectedMovement: Movement = .move(unit: unit, to: position)

		XCTAssertEqual(expectedMovement, unit.movement(to: position))
	}

	func testGetMovementToPositionInHand_IsNil() {
		let unit = stateProvider.initialGameState.whiteAnt
		let position: Position = .inHand

		XCTAssertNil(unit.movement(to: position))
	}

	func testWhenSurrounded_IsSurrounded_IsTrue() {
		let state = stateProvider.wonGameState
		XCTAssertTrue(state.whiteQueen.isSurrounded(in: state))
	}

	func testWhenNotSurrounded_IsSurrounded_IsFalse() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: 2, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0))
			]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertFalse(state.whiteQueen.isSurrounded(in: state))
	}

	func testWhenTopOfStack_IsTopOfStack_IsTrue() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: 2, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0))
		]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertTrue(state.whiteBeetle.isTopOfStack(in: state))
	}

	func testWhenBottomOfStack_IsTopOfStack_IsFalse() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: 2, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0))
			]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertFalse(state.whiteQueen.isTopOfStack(in: state))
	}

	func testStackPosition_IsCorrect() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: 2, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0))
			]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertEqual(2, state.whiteBeetle.stackPosition(in: state))
		XCTAssertEqual(1, state.whiteQueen.stackPosition(in: state))
	}

	func testWhenTopOfStackNotOneHive_CanMove_IsFalse() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: 2, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0))
			]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertTrue(state.blackQueen.isTopOfStack(in: state))
		XCTAssertFalse(state.oneHive(excluding: state.blackQueen))
		XCTAssertFalse(state.blackQueen.canMove(in: state))
	}

	func testWhenBottomOfStackOneHive_CanMove_IsFalse() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: 2, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0))
			]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertFalse(state.whiteQueen.isTopOfStack(in: state))
		XCTAssertTrue(state.oneHive(excluding: state.whiteQueen))
		XCTAssertFalse(state.whiteQueen.canMove(in: state))
	}

	func testWhenTopOfStackOneHive_CanMove_IsTrue() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: 2, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0))
			]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertTrue(state.blackBeetle.isTopOfStack(in: state))
		XCTAssertTrue(state.oneHive(excluding: state.blackBeetle))
		XCTAssertTrue(state.blackBeetle.canMove(in: state))
	}

	func testUnitDescription_IsCorrect() {
		XCTAssertEqual("Black Ant", stateProvider.blackAnt.description)
		XCTAssertEqual("White Beetle", stateProvider.whiteBeetle.description)
	}

	static var allTests = [
		("testGetMovementToPositionInPlay_IsCorrect", testGetMovementToPositionInPlay_IsCorrect),
		("testGetMovementToPositionInHand_IsNil", testGetMovementToPositionInHand_IsNil),

		("testWhenSurrounded_IsSurrounded_IsTrue", testWhenSurrounded_IsSurrounded_IsTrue),
		("testWhenNotSurrounded_IsSurrounded_IsFalse", testWhenNotSurrounded_IsSurrounded_IsFalse),

		("testWhenTopOfStack_IsTopOfStack_IsTrue", testWhenTopOfStack_IsTopOfStack_IsTrue),
		("testWhenBottomOfStack_IsTopOfStack_IsFalse", testWhenBottomOfStack_IsTopOfStack_IsFalse),

		("testStackPosition_IsCorrect", testStackPosition_IsCorrect),

		("testWhenTopOfStackNotOneHive_CanMove_IsFalse", testWhenTopOfStackNotOneHive_CanMove_IsFalse),
		("testWhenBottomOfStackOneHive_CanMove_IsFalse", testWhenBottomOfStackOneHive_CanMove_IsFalse),
		("testWhenTopOfStackOneHive_CanMove_IsTrue", testWhenTopOfStackOneHive_CanMove_IsTrue),

		("testUnitDescription_IsCorrect", testUnitDescription_IsCorrect)
	]
}
