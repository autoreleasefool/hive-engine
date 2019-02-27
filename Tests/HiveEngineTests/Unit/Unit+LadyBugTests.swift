//
//  Unit+LadyBugTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitLadyBugTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testLadyBug_CanMoveAsLadyBugOnly() {
		let state = stateProvider.gameState(after: 9)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .ladyBug:
				XCTAssertTrue(state.blackLadyBug.canMove(as: $0, in: state))
			case .spider, .beetle, .hopper, .ant, .mosquito, .pillBug, .queen:
				XCTAssertFalse(state.blackLadyBug.canMove(as: $0, in: state))
			}
		}
	}

	func testLadyBugMoves_AreCorrect() {
		let state = stateProvider.gameState(after: 9)
		let expectedMoves: Set<Movement> = [
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: -1, y: 1, z: 0)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: 1, y: 0, z: -1)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: -1, y: 3, z: -2)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: -1, y: 4, z: -3)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: 0, y: 4, z: -4)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: 1, y: 3, z: -4)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: 1, y: 2, z: -3)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: -1, y: 0, z: 1)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: -2, y: 3, z: -1)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: -2, y: 2, z: 0))
		]

		XCTAssertEqual(expectedMoves, state.blackLadyBug.availableMoves(in: state))
	}

	func testLadyBug_WithoutFreedomOfMovement_CannotMove() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteSpider, at: .inPlay(x: 1, y: -1, z: 0)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 1, y: 1, z: -2)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 2, y: -2, z: 0)),
			.move(unit: stateProvider.blackBeetle, to: .inPlay(x: 0, y: 1, z: -1)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 1, y: -1, z: 0)),
			.place(unit: stateProvider.blackLadyBug, at: .inPlay(x: 1, y: 1, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: 1, y: 0, z: -1)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 1, y: -1, z: 0))
		]

		let state = stateProvider.gameState(from: setupMoves)
		let expectedMoves: Set<Movement> = [
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: -1, y: 1, z: 0)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: -1, y: 0, z: 1)),
			.move(unit: stateProvider.blackLadyBug, to: .inPlay(x: 0, y: -1, z: 1))
		]

		XCTAssertEqual(expectedMoves, state.blackLadyBug.availableMoves(in: state))
	}

	func testLadyBug_CanMoveAcrossAnyHeight() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteSpider, at: .inPlay(x: 1, y: -1, z: 0)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 1, y: 1, z: -2)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 2, y: -2, z: 0)),
			.move(unit: stateProvider.blackBeetle, to: .inPlay(x: 0, y: 1, z: -1)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 1, y: -1, z: 0)),
			.place(unit: stateProvider.blackLadyBug, at: .inPlay(x: 1, y: 1, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0))
		]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertTrue(state.blackLadyBug.availableMoves(in: state).count > 0)
	}

	static var allTests = [
		("testLadyBug_CanMoveAsLadyBugOnly", testLadyBug_CanMoveAsLadyBugOnly),
		("testLadyBugMoves_AreCorrect", testLadyBugMoves_AreCorrect),
		("testLadyBug_WithoutFreedomOfMovement_CannotMove", testLadyBug_WithoutFreedomOfMovement_CannotMove),
		("testLadyBug_CanMoveAcrossAnyHeight", testLadyBug_CanMoveAcrossAnyHeight)
	]
}
