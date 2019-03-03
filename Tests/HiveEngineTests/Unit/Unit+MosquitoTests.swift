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
		let state = stateProvider.gameState(after: 13)
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
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteMosquito, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: 1, z: -1))
		]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertTrue(state.whiteMosquito.canMove(as: .queen, in: state))
	}

	func testMosquito_BesidePillBug_CanMoveAsQueen() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteMosquito, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackPillBug, at: .inPlay(x: 0, y: 1, z: -1))
		]

		let state = stateProvider.gameState(from: setupMoves)
		XCTAssertTrue(state.whiteMosquito.canMove(as: .queen, in: state))
	}

	func testMosquitoBesidePillBug_CanUseSpecialAbility_IsTrue() {
		let state = stateProvider.gameState(after: 16)
		XCTAssertTrue(state.whiteMosquito.canUseSpecialAbility(in: state))
	}

	func testMosquitoNotBesidePillBug_CanUseSpecialAbility_IsFalse() {
		let state = stateProvider.gameState(after: 18)
		XCTAssertFalse(state.whiteMosquito.canUseSpecialAbility(in: state))
	}

	func testMosquito_OnTopOfHive_IsBeetle() {
		let setupMoves: [Movement] = [
			.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			.place(unit: stateProvider.whiteMosquito, at: .inPlay(x: 0, y: -1, z: 1)),
			.place(unit: stateProvider.blackMosquito, at: .inPlay(x: 0, y: 2, z: -2)),
			.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 1, y: -1, z: 0)),
			.place(unit: stateProvider.blackBeetle, at: .inPlay(x: -1, y: 2, z: -1)),
			.move(unit: stateProvider.whiteMosquito, to: .inPlay(x: 0, y: 0, z: 0))
		]

		let state = stateProvider.gameState(from: setupMoves)
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

		("testMosquitoBesidePillBug_CanUseSpecialAbility_IsTrue", testMosquitoBesidePillBug_CanUseSpecialAbility_IsTrue),
		("testMosquitoNotBesidePillBug_CanUseSpecialAbility_IsFalse", testMosquitoNotBesidePillBug_CanUseSpecialAbility_IsFalse),

		("testMosquito_OnTopOfHive_IsBeetle", testMosquito_OnTopOfHive_IsBeetle)
	]
}
