//
//  Unit+SpiderTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitSpiderTests: HiveEngineTestCase {

	func testSpider_CanMoveAsSpiderOnly() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 2, to: state)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .spider:
				XCTAssertTrue(state.whiteSpider.canCopyMoves(of: $0, in: state))
			case .ant, .beetle, .hopper, .ladyBug, .mosquito, .pillBug, .queen:
				XCTAssertFalse(state.whiteSpider.canCopyMoves(of: $0, in: state))
			}
		}
	}

	func testSpiderMoves_AreCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 2, to: state)
		var availableMoves: Set<Movement> = []
		state.whiteSpider.availableMoves(in: state, moveSet: &availableMoves)
		XCTAssertEqual(1, availableMoves.count)

		let expectedMoves: Set<Movement> = [
			.move(unit: state.whiteSpider, to: Position(x: 0, y: 2, z: -2)),
		]
		XCTAssertEqual(expectedMoves, availableMoves)
	}

	func testSpider_EntersGapsCorrectly() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.disableMovementValidation)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.blackQueen, at: .origin),
			Movement.place(unit: state.blackAnt, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.blackBeetle, at: Position(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.blackHopper, at: Position(x: 2, y: 0, z: -2)),
			Movement.place(unit: state.whiteSpider, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.whiteQueen, at: Position(x: -1, y: 0, z: 1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		state.internalOptions.remove(.disableMovementValidation)

		var availableMoves: Set<Movement> = []
		state.whiteSpider.availableMoves(in: state, moveSet: &availableMoves)

		let expectedMoves: Set<Movement> = [
			.move(unit: state.whiteSpider, to: Position(x: -2, y: 0, z: 2)),
			.move(unit: state.whiteSpider, to: Position(x: 3, y: -1, z: -2)),
		]

		XCTAssertEqual(availableMoves, expectedMoves)
	}

	func testSpiderNotInPlay_CannotMove() {
		let state = stateProvider.initialGameState

		var availableMoves: Set<Movement> = []
		state.whiteSpider.availableMoves(in: state, moveSet: &availableMoves)

		XCTAssertEqual(0, availableMoves.count)
	}

	func testSpider_FreedomOfMovement_IsCorrect() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackLadyBug, at: Position(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteSpider, at: Position(x: 2, y: -1, z: -1)),
			Movement.place(unit: state.blackSpider, at: Position(x: 1, y: 2, z: -3)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 0, y: -1, z: 1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		var availableMoves: Set<Movement> = []
		state.blackSpider.availableMoves(in: state, moveSet: &availableMoves)

		let expectedMove: Movement = .move(unit: state.blackSpider, to: Position(x: 3, y: -1, z: -2))
		XCTAssertTrue(availableMoves.contains(expectedMove))
		let unexpectedMove: Movement = .move(unit: state.blackSpider, to: Position(x: 1, y: 0, z: -1))
		XCTAssertFalse(availableMoves.contains(unexpectedMove))
	}
}
