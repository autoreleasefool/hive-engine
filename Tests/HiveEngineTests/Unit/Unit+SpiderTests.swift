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

	func testSpider_CanMoveAsSpiderOnly() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 2, to: state)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .spider:
				XCTAssertTrue(state.whiteSpider.canMove(as: $0, in: state))
			case .ant, .beetle, .hopper, .ladyBug, .mosquito, .pillBug, .queen:
				XCTAssertFalse(state.whiteSpider.canMove(as: $0, in: state))
			}
		}
	}

	func testSpiderMoves_AreCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 2, to: state)
		let availableMoves = state.whiteSpider.availableMoves(in: state)
		XCTAssertEqual(1, availableMoves.count)

		let expectedMoves: Set<Movement> = [
			.move(unit: state.whiteSpider, to: .inPlay(x: 0, y: 2, z: -2))
		]
		XCTAssertEqual(expectedMoves, availableMoves)
	}

	func testSpider_FreedomOfMovement_IsCorrect() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackLadyBug, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteSpider, at: Position.inPlay(x: 2, y: -1, z: -1)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: 1, y: 2, z: -3)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 0, y: -1, z: 1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMove: Movement = .move(unit: state.blackSpider, to: .inPlay(x: 3, y: -1, z: -2))
		XCTAssertTrue(state.blackSpider.availableMoves(in: state).contains(expectedMove))
		let unexpectedMove: Movement = .move(unit: state.blackSpider, to: .inPlay(x: 1, y: 0, z: -1))
		XCTAssertFalse(state.blackSpider.availableMoves(in: state).contains(unexpectedMove))
	}

	static var allTests = [
		("testSpider_CanMoveAsSpiderOnly", testSpider_CanMoveAsSpiderOnly),
		("testSpiderMoves_AreCorrect", testSpiderMoves_AreCorrect),
		("testSpider_FreedomOfMovement_IsCorrect", testSpider_FreedomOfMovement_IsCorrect)
	]
}
