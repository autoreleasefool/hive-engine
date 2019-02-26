//
//  Unit+QueenTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitQueenTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testQueen_CanMoveAsQueen_IsTrue() {
		let state = stateProvider.gameState(after: 8)
		XCTAssertTrue(state.whiteQueen.canMove(as: .queen, in: state))
	}

	func testQueen_CanMoveAsOtherBug_IsFalse() {
		let state = stateProvider.gameState(after: 8)
		XCTAssertFalse(state.whiteQueen.canMove(as: .ant, in: state))
		XCTAssertFalse(state.whiteQueen.canMove(as: .beetle, in: state))
		XCTAssertFalse(state.whiteQueen.canMove(as: .hopper, in: state))
		XCTAssertFalse(state.whiteQueen.canMove(as: .ladyBug, in: state))
		XCTAssertFalse(state.whiteQueen.canMove(as: .mosquito, in: state))
		XCTAssertFalse(state.whiteQueen.canMove(as: .pillBug, in: state))
		XCTAssertFalse(state.whiteQueen.canMove(as: .spider, in: state))
	}

	func testQueenMoves_AreCorrect() {
		let state = stateProvider.gameState(after: 8)
		let availableMoves = state.whiteQueen.availableMoves(in: state)
		XCTAssertEqual(2, availableMoves.count)

		let expectedMoves: Set<Movement> = [
			.move(unit: state.whiteQueen, to: .inPlay(x: 1, y: 0, z: -1)),
			.move(unit: state.whiteQueen, to: .inPlay(x: 1, y: -2, z: 1))
		]
		XCTAssertEqual(expectedMoves, availableMoves)
	}

	func testQueen_FreedomOfMovement_IsCorrect() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteHopper, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackLadyBug, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.place(unit: stateProvider.whiteSpider, at: Position.inPlay(x: 2, y: -1, z: -1)),
			Movement.place(unit: stateProvider.blackSpider, at: Position.inPlay(x: 1, y: 2, z: -3)),
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 3, y: -1, z: -2)),
			Movement.move(unit: stateProvider.blackSpider, to: Position.inPlay(x: -1, y: 1, z: 0)),
			Movement.move(unit: stateProvider.whiteQueen, to: Position.inPlay(x: 2, y: 0, z: -2)),
			Movement.move(unit: stateProvider.blackSpider, to: Position.inPlay(x: 1, y: 2, z: -3)),
			]

		let state = stateProvider.gameState(from: setupMoves)
		let expectedMove: Movement = .move(unit: state.whiteQueen, to: .inPlay(x: 2, y: 1, z: -3))
		XCTAssertTrue(state.whiteQueen.availableMoves(in: state).contains(expectedMove))
		let unexpectedMove: Movement = .move(unit: state.whiteQueen, to: .inPlay(x: 1, y: 0, z: -1))
		XCTAssertFalse(state.whiteQueen.availableMoves(in: state).contains(unexpectedMove))
	}

	static var allTests = [
		("testQueen_CanMoveAsQueen_IsTrue", testQueen_CanMoveAsQueen_IsTrue),
		("testQueen_CanMoveAsOtherBug_IsFalse", testQueen_CanMoveAsOtherBug_IsFalse),

		("testQueenMoves_AreCorrect", testQueenMoves_AreCorrect),
		("testQueen_FreedomOfMovement_IsCorrect", testQueen_FreedomOfMovement_IsCorrect)
	]
}
