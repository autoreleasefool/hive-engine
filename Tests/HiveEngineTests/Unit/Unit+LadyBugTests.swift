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
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 9, to: state)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .ladyBug:
				XCTAssertTrue(state.blackLadyBug.canCopyMoves(of: $0, in: state))
			case .spider, .beetle, .hopper, .ant, .mosquito, .pillBug, .queen:
				XCTAssertFalse(state.blackLadyBug.canCopyMoves(of: $0, in: state))
			}
		}
	}

	func testLadyBugMoves_AreCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 9, to: state)
		let expectedMoves: Set<Movement> = [
			.move(unit: state.blackLadyBug, to: Position(x: -1, y: 1, z: 0)),
			.move(unit: state.blackLadyBug, to: Position(x: 1, y: 0, z: -1)),
			.move(unit: state.blackLadyBug, to: Position(x: -1, y: 3, z: -2)),
			.move(unit: state.blackLadyBug, to: Position(x: -1, y: 4, z: -3)),
			.move(unit: state.blackLadyBug, to: Position(x: 0, y: 4, z: -4)),
			.move(unit: state.blackLadyBug, to: Position(x: 1, y: 3, z: -4)),
			.move(unit: state.blackLadyBug, to: Position(x: 1, y: 2, z: -3)),
			.move(unit: state.blackLadyBug, to: Position(x: -1, y: 0, z: 1)),
			.move(unit: state.blackLadyBug, to: Position(x: -2, y: 3, z: -1)),
			.move(unit: state.blackLadyBug, to: Position(x: -2, y: 2, z: 0))
		]

		XCTAssertEqual(expectedMoves, state.blackLadyBug.availableMoves(in: state))
	}

	func testLadyBug_WithoutFreedomOfMovement_CannotMove() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteSpider, at: Position(x: 1, y: -1, z: 0)),
			.place(unit: state.blackBeetle, at: Position(x: 1, y: 1, z: -2)),
			.place(unit: state.whiteBeetle, at: Position(x: 2, y: -2, z: 0)),
			.move(unit: state.blackBeetle, to: Position(x: 0, y: 1, z: -1)),
			.move(unit: state.whiteBeetle, to: Position(x: 1, y: -1, z: 0)),
			.place(unit: state.blackLadyBug, at: Position(x: 1, y: 1, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin),
			.move(unit: state.blackLadyBug, to: Position(x: 1, y: 0, z: -1)),
			.move(unit: state.whiteBeetle, to: Position(x: 1, y: -1, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMoves: Set<Movement> = [
			.move(unit: state.blackLadyBug, to: Position(x: -1, y: 1, z: 0)),
			.move(unit: state.blackLadyBug, to: Position(x: -1, y: 0, z: 1)),
			.move(unit: state.blackLadyBug, to: Position(x: 0, y: -1, z: 1))
		]

		XCTAssertEqual(expectedMoves, state.blackLadyBug.availableMoves(in: state))
	}

	func testLadyBug_CanMoveAcrossAnyHeight() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteSpider, at: Position(x: 1, y: -1, z: 0)),
			.place(unit: state.blackBeetle, at: Position(x: 1, y: 1, z: -2)),
			.place(unit: state.whiteBeetle, at: Position(x: 2, y: -2, z: 0)),
			.move(unit: state.blackBeetle, to: Position(x: 0, y: 1, z: -1)),
			.move(unit: state.whiteBeetle, to: Position(x: 1, y: -1, z: 0)),
			.place(unit: state.blackLadyBug, at: Position(x: 1, y: 1, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin)
		]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.blackLadyBug.availableMoves(in: state).count > 0)
	}

	static var allTests = [
		("testLadyBug_CanMoveAsLadyBugOnly", testLadyBug_CanMoveAsLadyBugOnly),
		("testLadyBugMoves_AreCorrect", testLadyBugMoves_AreCorrect),
		("testLadyBug_WithoutFreedomOfMovement_CannotMove", testLadyBug_WithoutFreedomOfMovement_CannotMove),
		("testLadyBug_CanMoveAcrossAnyHeight", testLadyBug_CanMoveAcrossAnyHeight)
	]
}
