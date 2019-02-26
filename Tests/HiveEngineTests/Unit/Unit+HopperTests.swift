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
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testHopper_CanMoveAsHopperOnly", testHopper_CanMoveAsHopperOnly),
		("testHopperMoves_AreCorrect", testHopperMoves_AreCorrect),
		("testHopper_CanJumpAnyHeight", testHopper_CanJumpAnyHeight)
	]
}
