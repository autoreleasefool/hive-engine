//
//  Unit+SpiderTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitSpiderTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testSpider_CanMoveAsSpider_IsTrue() {
		let state = stateProvider.gameState(after: 2)
		XCTAssertTrue(state.whiteSpider.canMove(as: .spider, in: state))
	}

	func testSpider_CanMoveAsOtherBug_IsFalse() {
		let state = stateProvider.gameState(after: 2)
		XCTAssertFalse(state.whiteSpider.canMove(as: .ant, in: state))
		XCTAssertFalse(state.whiteSpider.canMove(as: .beetle, in: state))
		XCTAssertFalse(state.whiteSpider.canMove(as: .hopper, in: state))
		XCTAssertFalse(state.whiteSpider.canMove(as: .ladyBug, in: state))
		XCTAssertFalse(state.whiteSpider.canMove(as: .mosquito, in: state))
		XCTAssertFalse(state.whiteSpider.canMove(as: .pillBug, in: state))
		XCTAssertFalse(state.whiteSpider.canMove(as: .queen, in: state))
	}

	func testSpiderMoves_AreCorrect() {
		let state = stateProvider.gameState(after: 2)
		let availableMoves = state.whiteSpider.availableMoves(in: state)
		XCTAssertEqual(1, availableMoves.count)

		let expectedMoves: Set<Movement> = [
			.move(unit: state.whiteSpider, to: .inPlay(x: 0, y: 2, z: -2))
		]
		XCTAssertEqual(expectedMoves, availableMoves)
	}

	func testSpider_FreedomOfMovement_IsCorrect() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackLadyBug, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.place(unit: stateProvider.whiteSpider, at: Position.inPlay(x: 2, y: -1, z: -1)),
			Movement.place(unit: stateProvider.blackSpider, at: Position.inPlay(x: 1, y: 2, z: -3)),
			Movement.place(unit: stateProvider.whiteAnt, at: Position.inPlay(x: 0, y: -1, z: 1)),
		]

		let state = stateProvider.gameState(from: setupMoves)
		let expectedMove: Movement = .move(unit: state.blackSpider, to: .inPlay(x: 3, y: -1, z: -2))
		XCTAssertTrue(state.blackSpider.availableMoves(in: state).contains(expectedMove))
		let unexpectedMove: Movement = .move(unit: state.blackSpider, to: .inPlay(x: 1, y: 0, z: -1))
		XCTAssertFalse(state.blackSpider.availableMoves(in: state).contains(unexpectedMove))
	}

	static var allTests = [
		("testSpider_CanMoveAsSpider_IsTrue", testSpider_CanMoveAsSpider_IsTrue),
		("testSpider_CanMoveAsOtherBug_IsFalse", testSpider_CanMoveAsOtherBug_IsFalse),

		("testSpiderMoves_AreCorrect", testSpiderMoves_AreCorrect),
		("testSpider_FreedomOfMovement_IsCorrect", testSpider_FreedomOfMovement_IsCorrect)
	]
}
