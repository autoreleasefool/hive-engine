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

	func testHopper_CanMoveAsHopper_IsTrue() {
		let state = stateProvider.gameState(after: 9)
		XCTAssertTrue(state.blackHopper.canMove(as: .hopper, in: state))
	}

	func testHopper_CanMoveAsOtherBug_IsFalse() {
		let state = stateProvider.gameState(after: 9)
		XCTAssertFalse(state.blackHopper.canMove(as: .ant, in: state))
		XCTAssertFalse(state.blackHopper.canMove(as: .beetle, in: state))
		XCTAssertFalse(state.blackHopper.canMove(as: .ladyBug, in: state))
		XCTAssertFalse(state.blackHopper.canMove(as: .mosquito, in: state))
		XCTAssertFalse(state.blackHopper.canMove(as: .pillBug, in: state))
		XCTAssertFalse(state.blackHopper.canMove(as: .queen, in: state))
		XCTAssertFalse(state.blackHopper.canMove(as: .spider, in: state))
	}

	func testHopperMoves_AreCorrect() {
		let state = stateProvider.gameState(after: 9)
		let expectedMoves: Set<Movement> = [
			.move(unit: state.blackHopper, to: .inPlay(x: 1, y: 2, z: -3)),
			.move(unit: state.blackHopper, to: .inPlay(x: 1, y: 0, z: -1))
		]

		XCTAssertEqual(expectedMoves, state.blackHopper.availableMoves(in: state))
	}

	static var allTests = [
		("testHopper_CanMoveAsHopper_IsTrue", testHopper_CanMoveAsHopper_IsTrue),
		("testHopper_CanMoveAsOtherBug_IsFalse", testHopper_CanMoveAsOtherBug_IsFalse),

		("testHopperMoves_AreCorrect", testHopperMoves_AreCorrect)
	]
}
