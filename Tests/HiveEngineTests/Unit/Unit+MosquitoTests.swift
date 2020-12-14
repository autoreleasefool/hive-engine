//
//  Unit+MosquitoTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import HiveEngineTestUtilities
import XCTest
@testable import HiveEngine

final class UnitMosquitoTests: HiveEngineTestCase {

	func testMosquitoNotInPlay_CannotMove() {
		let state = stateProvider.initialGameState

		var availableMoves: Set<Movement> = []
		state.whiteMosquito.availableMoves(in: state, moveSet: &availableMoves)

		XCTAssertEqual(0, availableMoves.count)
	}

	func testMosquito_CanMoveAsAdjacentBugs_IsTrue() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 13, to: state)
		let adjacentUnitClasses = state.units(adjacentTo: state.blackMosquito).map { $0.class }

		HiveEngine.Unit.Class.allCases.forEach {
			if $0 == .mosquito {
				XCTAssertTrue(state.blackMosquito.canCopyMoves(of: $0, in: state))
			} else if adjacentUnitClasses.contains($0) {
				XCTAssertTrue(state.blackMosquito.canCopyMoves(of: $0, in: state))
			} else {
				XCTAssertFalse(state.blackMosquito.canCopyMoves(of: $0, in: state))
			}
		}
	}

	func testMosquito_BesideBeetle_CanMoveAsQueen() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteMosquito, at: .origin),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 1, z: -1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.whiteMosquito.canCopyMoves(of: .queen, in: state))
	}

	func testMosquito_BesidePillBug_CanMoveAsQueen() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteMosquito, at: .origin),
			.place(unit: state.blackPillBug, at: Position(x: 0, y: 1, z: -1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.whiteMosquito.canCopyMoves(of: .queen, in: state))
	}

	func testMosquitoBesidePillBug_CanUseSpecialAbility_IsTrue() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 16, to: state)
		XCTAssertTrue(state.whiteMosquito.canUseSpecialAbility(in: state))
	}

	func testMosquitoNotBesidePillBug_CanUseSpecialAbility_IsFalse() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 18, to: state)
		XCTAssertFalse(state.whiteMosquito.canUseSpecialAbility(in: state))
	}

	func testMosquito_OnTopOfHive_IsBeetle() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteQueen, at: .origin),
			.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			.place(unit: state.whiteMosquito, at: Position(x: 0, y: -1, z: 1)),
			.place(unit: state.blackMosquito, at: Position(x: 0, y: 2, z: -2)),
			.place(unit: state.whiteBeetle, at: Position(x: 1, y: -1, z: 0)),
			.place(unit: state.blackBeetle, at: Position(x: -1, y: 2, z: -1)),
			.move(unit: state.whiteMosquito, to: .origin),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .beetle, .mosquito:
				XCTAssertTrue(state.whiteMosquito.canCopyMoves(of: $0, in: state))
			case .ant, .hopper, .spider, .ladyBug, .pillBug, .queen:
				XCTAssertFalse(state.whiteMosquito.canCopyMoves(of: $0, in: state))
			}
		}
	}
}
