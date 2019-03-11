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

	func testQueen_CanMoveAsQueenOnly() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .queen:
				XCTAssertTrue(state.whiteQueen.canMove(as: $0, in: state))
			case .ant, .beetle, .hopper, .ladyBug, .mosquito, .pillBug, .spider:
				XCTAssertFalse(state.whiteQueen.canMove(as: $0, in: state))
			}
		}
	}

	func testQueenMoves_AreCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)
		let availableMoves = state.whiteQueen.availableMoves(in: state)
		XCTAssertEqual(2, availableMoves.count)

		let expectedMoves: Set<Movement> = [
			.move(unit: state.whiteQueen, to: Position(x: 1, y: 0, z: -1)),
			.move(unit: state.whiteQueen, to: Position(x: 1, y: -2, z: 1))
		]
		XCTAssertEqual(expectedMoves, availableMoves)
	}

	func testQueen_FreedomOfMovement_IsCorrect() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteHopper, at: Position(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackLadyBug, at: Position(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteSpider, at: Position(x: 2, y: -1, z: -1)),
			Movement.place(unit: state.blackSpider, at: Position(x: 1, y: 2, z: -3)),
			Movement.place(unit: state.whiteQueen, at: Position(x: 3, y: -1, z: -2)),
			Movement.move(unit: state.blackSpider, to: Position(x: -1, y: 1, z: 0)),
			Movement.move(unit: state.whiteQueen, to: Position(x: 2, y: 0, z: -2)),
			Movement.move(unit: state.blackSpider, to: Position(x: 1, y: 2, z: -3))
			]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMove: Movement = .move(unit: state.whiteQueen, to: Position(x: 2, y: 1, z: -3))
		XCTAssertTrue(state.whiteQueen.availableMoves(in: state).contains(expectedMove))
		let unexpectedMove: Movement = .move(unit: state.whiteQueen, to: Position(x: 1, y: 0, z: -1))
		XCTAssertFalse(state.whiteQueen.availableMoves(in: state).contains(unexpectedMove))
	}

	static var allTests = [
		("testQueen_CanMoveAsQueenOnly", testQueen_CanMoveAsQueenOnly),
		("testQueenMoves_AreCorrect", testQueenMoves_AreCorrect),
		("testQueen_FreedomOfMovement_IsCorrect", testQueen_FreedomOfMovement_IsCorrect)
	]
}
