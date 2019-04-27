//
//  Unit+MosquitoTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitMosquitoTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testMosquito_CanMoveAsAdjacentBugs_IsTrue() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 13, to: state)
		let adjacentUnitClasses = state.units(adjacentTo: state.blackMosquito).map { $0.class }

		HiveEngine.Unit.Class.allCases.forEach {
			if $0 == .mosquito {
				XCTAssertTrue(state.blackMosquito.canMove(as: $0, in: state))
			} else if adjacentUnitClasses.contains($0) {
				XCTAssertTrue(state.blackMosquito.canMove(as: $0, in: state))
			} else {
				XCTAssertFalse(state.blackMosquito.canMove(as: $0, in: state))
			}
		}
	}

	func testMosquito_BesideBeetle_CanMoveAsQueen() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteMosquito, at: .origin),
			.place(unit: state.blackBeetle, at: Position(x: 0, y: 1, z: -1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.whiteMosquito.canMove(as: .queen, in: state))
	}

	func testMosquito_BesidePillBug_CanMoveAsQueen() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			.place(unit: state.whiteMosquito, at: .origin),
			.place(unit: state.blackPillBug, at: Position(x: 0, y: 1, z: -1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertTrue(state.whiteMosquito.canMove(as: .queen, in: state))
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
			.move(unit: state.whiteMosquito, to: .origin)
		]

		stateProvider.apply(moves: setupMoves, to: state)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .beetle, .mosquito:
				XCTAssertTrue(state.whiteMosquito.canMove(as: $0, in: state))
			case .ant, .hopper, .spider, .ladyBug, .pillBug, .queen:
				XCTAssertFalse(state.whiteMosquito.canMove(as: $0, in: state))
			}
		}
	}

	static var allTests = [
		("testMosquito_CanMoveAsAdjacentBugs_IsTrue", testMosquito_CanMoveAsAdjacentBugs_IsTrue),
		("testMosquito_BesideBeetle_CanMoveAsQueen", testMosquito_BesideBeetle_CanMoveAsQueen),
		("testMosquito_BesidePillBug_CanMoveAsQueen", testMosquito_BesidePillBug_CanMoveAsQueen),

		("testMosquitoBesidePillBug_CanUseSpecialAbility_IsTrue", testMosquitoBesidePillBug_CanUseSpecialAbility_IsTrue),
		("testMosquitoNotBesidePillBug_CanUseSpecialAbility_IsFalse", testMosquitoNotBesidePillBug_CanUseSpecialAbility_IsFalse),

		("testMosquito_OnTopOfHive_IsBeetle", testMosquito_OnTopOfHive_IsBeetle)
	]
}
