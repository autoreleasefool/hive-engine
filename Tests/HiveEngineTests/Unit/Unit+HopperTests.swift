//
//  Unit+HopperTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitHopperTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testHopper_CanMoveAsHopperOnly() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 9, to: state)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .hopper:
				XCTAssertTrue(state.blackHopper.canMove(as: $0, in: state))
			case .ant, .beetle, .spider, .ladyBug, .mosquito, .pillBug, .queen:
				XCTAssertFalse(state.blackHopper.canMove(as: $0, in: state))
			}
		}
	}

	func testHopperMoves_AreCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 9, to: state)
		let expectedMoves: Set<Movement> = [
			.move(unit: state.blackHopper, to: Position(x: 1, y: 2, z: -3)),
			.move(unit: state.blackHopper, to: Position(x: 1, y: 0, z: -1))
		]

		XCTAssertEqual(expectedMoves, state.blackHopper.availableMoves(in: state))
	}

	func testHopper_CanJumpAnyHeight() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: Position(x: 0, y: 0, z: 0)),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: Position(x: 0, y: 0, z: 0)),
			.move(unit: state.blackBeetle, to: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteMosquito, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackHopper, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteMosquito, to: Position(x: 0, y: 0, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMoves: Set<Movement> = [
			.move(unit: state.blackHopper, to: Position(x: 0, y: -1, z: 1))
		]
		XCTAssertEqual(expectedMoves, state.blackHopper.availableMoves(in: state))
	}

	static var allTests = [
		("testHopper_CanMoveAsHopperOnly", testHopper_CanMoveAsHopperOnly),
		("testHopperMoves_AreCorrect", testHopperMoves_AreCorrect),
		("testHopper_CanJumpAnyHeight", testHopper_CanJumpAnyHeight)
	]
}
