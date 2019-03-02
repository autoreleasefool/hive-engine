//
//  Unit+AntTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitAntTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testAnt_CanMoveAsAntOnly() {
		let state = stateProvider.gameState(after: 14)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .ant:
				XCTAssertTrue(state.whiteAnt.canMove(as: $0, in: state))
			case .spider, .beetle, .hopper, .ladyBug, .mosquito, .pillBug, .queen:
				XCTAssertFalse(state.whiteAnt.canMove(as: $0, in: state))
			}
		}
	}

	func testAntMoves_AreCorrect() {
		let state = stateProvider.gameState(after: 14)
		let availableMoves = state.whiteAnt.availableMoves(in: state)
		XCTAssertEqual(14, availableMoves.count)

		let expectedMoves: Set<Movement> = [
			.move(unit: state.whiteAnt, to: .inPlay(x: -1, y: 3, z: -2)),
			.move(unit: state.whiteAnt, to: .inPlay(x: -2, y: 3, z: -1)),
			.move(unit: state.whiteAnt, to: .inPlay(x: -2, y: 2, z: 0)),
			.move(unit: state.whiteAnt, to: .inPlay(x: -1, y: 1, z: 0)),
			.move(unit: state.whiteAnt, to: .inPlay(x: -1, y: 0, z: 1)),
			.move(unit: state.whiteAnt, to: .inPlay(x: -1, y: -1, z: 2)),
			.move(unit: state.whiteAnt, to: .inPlay(x: 0, y: -2, z: 2)),
			.move(unit: state.whiteAnt, to: .inPlay(x: 1, y: -2, z: 1)),
			.move(unit: state.whiteAnt, to: .inPlay(x: 2, y: -2, z: 0)),
			.move(unit: state.whiteAnt, to: .inPlay(x: 3, y: -2, z: -1)),
			.move(unit: state.whiteAnt, to: .inPlay(x: 3, y: -1, z: -2)),
			.move(unit: state.whiteAnt, to: .inPlay(x: 2, y: 0, z: -2)),
			.move(unit: state.whiteAnt, to: .inPlay(x: 2, y: 1, z: -3)),
			.move(unit: state.whiteAnt, to: .inPlay(x: 1, y: 2, z: -3))
		]
		XCTAssertEqual(expectedMoves, availableMoves)
	}

	func testAnt_FreedomOfMovement_IsCorrect() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackLadyBug, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.place(unit: stateProvider.whiteSpider, at: Position.inPlay(x: 2, y: -1, z: -1)),
			Movement.place(unit: stateProvider.blackAnt, at: Position.inPlay(x: 1, y: 2, z: -3)),
			Movement.place(unit: stateProvider.whiteAnt, at: Position.inPlay(x: 0, y: -1, z: 1))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let expectedMove: Movement = .move(unit: state.blackAnt, to: .inPlay(x: 3, y: -1, z: -2))
		XCTAssertTrue(state.blackAnt.availableMoves(in: state).contains(expectedMove))
		let unexpectedMove: Movement = .move(unit: state.blackAnt, to: .inPlay(x: 1, y: 0, z: -1))
		XCTAssertFalse(state.blackAnt.availableMoves(in: state).contains(unexpectedMove))
	}

	static var allTests = [
		("testAnt_CanMoveAsAntOnly", testAnt_CanMoveAsAntOnly),
		("testAntMoves_AreCorrect", testAntMoves_AreCorrect),
		("testAnt_FreedomOfMovement_IsCorrect", testAnt_FreedomOfMovement_IsCorrect)
	]
}
