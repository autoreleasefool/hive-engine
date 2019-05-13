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
				XCTAssertTrue(state.blackHopper.canCopyMoves(of: $0, in: state))
			case .ant, .beetle, .spider, .ladyBug, .mosquito, .pillBug, .queen:
				XCTAssertFalse(state.blackHopper.canCopyMoves(of: $0, in: state))
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

		var availableMoves: Set<Movement> = []
		state.blackHopper.availableMoves(in: state, moveSet: &availableMoves)

		XCTAssertEqual(expectedMoves, availableMoves)
	}

	func testHopperNotInPlay_CannotMove() {
		let state = stateProvider.initialGameState

		var availableMoves: Set<Movement> = []
		state.whiteHopper.availableMoves(in: state, moveSet: &availableMoves)

		XCTAssertEqual(0, availableMoves.count)
	}

	func testHopper_CanJumpAnyHeight() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteBeetle, to: .origin),
			.move(unit: state.blackBeetle, to: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteMosquito, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackHopper, at: Position(x: 0, y: 2, z: -2)),
			.move(unit: state.whiteMosquito, to: .origin)
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMoves: Set<Movement> = [
			.move(unit: state.blackHopper, to: Position(x: 0, y: -1, z: 1))
		]

		var availableMoves: Set<Movement> = []
		state.blackHopper.availableMoves(in: state, moveSet: &availableMoves)
		XCTAssertEqual(expectedMoves, availableMoves)
	}

	static var allTests = [
		("testHopper_CanMoveAsHopperOnly", testHopper_CanMoveAsHopperOnly),
		("testHopperMoves_AreCorrect", testHopperMoves_AreCorrect),
		("testHopperNotInPlay_CannotMove", testHopperNotInPlay_CannotMove),
		("testHopper_CanJumpAnyHeight", testHopper_CanJumpAnyHeight)
	]
}
