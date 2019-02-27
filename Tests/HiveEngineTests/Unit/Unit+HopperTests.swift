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
		let state = stateProvider.gameState(after: 9)
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
		let state = stateProvider.gameState(after: 9)
		let expectedMoves: Set<Movement> = [
			.move(unit: state.blackHopper, to: .inPlay(x: 1, y: 2, z: -3)),
			.move(unit: state.blackHopper, to: .inPlay(x: 1, y: 0, z: -1))
		]

		XCTAssertEqual(expectedMoves, state.blackHopper.availableMoves(in: state))
	}

	func testHopper_CanJumpAnyHeight() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: 2, z: -2)),
			.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0)),
			.move(unit: stateProvider.blackBeetle, to: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteMosquito, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackHopper, at: .inPlay(x: 0, y: 2, z: -2)),
			.move(unit: stateProvider.whiteMosquito, to: .inPlay(x: 0, y: 0, z: 0))
		]

		let state = stateProvider.gameState(from: setupMoves)
		let expectedMoves: Set<Movement> = [
			.move(unit: state.blackHopper, to: .inPlay(x: 0, y: -1, z: 1))
		]
		XCTAssertEqual(expectedMoves, state.blackHopper.availableMoves(in: state))
	}

	static var allTests = [
		("testHopper_CanMoveAsHopperOnly", testHopper_CanMoveAsHopperOnly),
		("testHopperMoves_AreCorrect", testHopperMoves_AreCorrect),
		("testHopper_CanJumpAnyHeight", testHopper_CanJumpAnyHeight)
	]
}
