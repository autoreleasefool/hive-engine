//
//  Unit+PillBugTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitPillBugTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testPillBug_CanMoveAsPillBugOrQueen() {
		let state = stateProvider.gameState(after: 16)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .pillBug, .queen:
				XCTAssertTrue(state.whitePillBug.canMove(as: $0, in: state))
			case .ant, .hopper, .ladyBug, .mosquito, .beetle, .spider:
				XCTAssertFalse(state.whitePillBug.canMove(as: $0, in: state))
			}
		}
	}

	func testPillBug_CanUseSpecialAbility_IsTrue() {
		let state = stateProvider.gameState(after: 16)
		XCTAssertTrue(stateProvider.whitePillBug.canUseSpecialAbility(in: state))
	}

	func testNotPillBug_CanUseSpecialAbility_IsFalse() {
		let state = stateProvider.gameState(after: 16)
		XCTAssertFalse(stateProvider.whiteQueen.canUseSpecialAbility(in: state))
		XCTAssertFalse(stateProvider.blackMosquito.canUseSpecialAbility(in: state))
		XCTAssertFalse(stateProvider.whiteBeetle.canUseSpecialAbility(in: state))
		XCTAssertFalse(stateProvider.whiteSpider.canUseSpecialAbility(in: state))
		XCTAssertFalse(stateProvider.blackHopper.canUseSpecialAbility(in: state))
		XCTAssertFalse(stateProvider.blackLadyBug.canUseSpecialAbility(in: state))
		XCTAssertFalse(stateProvider.whiteAnt.canUseSpecialAbility(in: state))
	}

	func testPillBugMoves_AreCorrect() {
		let state = stateProvider.gameState(after: 16)
		let expectedAvailableMoves: Set<Movement> = [
			.move(unit: state.whitePillBug, to: .inPlay(x: -1, y: -1, z: 2)),
			.move(unit: state.whitePillBug, to: .inPlay(x: 1, y: -2, z: 1)),
			.yoink(pillBug: state.whitePillBug, unit: state.whiteMosquito, to: .inPlay(x: -1, y: -1, z: 2)),
			.yoink(pillBug: state.whitePillBug, unit: state.whiteMosquito, to: .inPlay(x: 0, y: -2, z: 2)),
			.yoink(pillBug: state.whitePillBug, unit: state.whiteMosquito, to: .inPlay(x: 1, y: -2, z: 1))
		]

		XCTAssertEqual(expectedAvailableMoves, state.whitePillBug.availableMoves(in: state))
	}

	func testPillBug_CannotMovePieceJustMoved_IsTrue() {
		let state = stateProvider.gameState(after: 18)
		let expectedAvailableMoves: Set<Movement> = [
			.move(unit: state.whitePillBug, to: .inPlay(x: -1, y: -1, z: 2)),
			.move(unit: state.whitePillBug, to: .inPlay(x: 1, y: -2, z: 1))
		]

		XCTAssertEqual(expectedAvailableMoves, state.whitePillBug.availableMoves(in: state))
	}

	func testPillBug_PieceJustYoinkedCannotMove_IsTrue() {
		let state = stateProvider.gameState(after: 21)
		XCTAssertEqual(0, state.blackHopper.availableMoves(in: state).count)
	}

	func testPillBug_WithoutFreedomOfMovementToPosition_CannotYoinkToPosition() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whitePillBug, at: .inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: .inPlay(x: -1, y: 2, z: -1)),
			Movement.place(unit: stateProvider.whiteLadyBug, at: .inPlay(x: 2, y: -1, z: -1)),
			Movement.move(unit: stateProvider.blackSpider, to: .inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: stateProvider.whiteLadyBug, to: .inPlay(x: 1, y: 0, z: -1)),
			Movement.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: -2, z: 2)),
			Movement.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 2, y: 0, z: -2)),
			Movement.move(unit: stateProvider.blackBeetle, to: .inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 1, y: 0, z: -1)),
			Movement.move(unit: stateProvider.blackQueen, to: .inPlay(x: 1, y: 1, z: -2)),
			Movement.move(unit: stateProvider.whiteQueen, to: .inPlay(x: -1, y: 0, z: 1)),
			Movement.move(unit: stateProvider.blackQueen, to: .inPlay(x: 2, y: 0, z: -2)),
			Movement.move(unit: stateProvider.whiteQueen, to: .inPlay(x: -1, y: -1, z: 2)),
			Movement.move(unit: stateProvider.blackQueen, to: .inPlay(x: 2, y: -1, z: -1))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let yoinkToOriginMoves = state.availableMoves.filter {
			if case let .yoink(_, _, position) = $0 {
				return position == .inPlay(x: 0, y: 0, z: 0)
			} else {
				return false
			}
		}
		XCTAssertTrue(state.currentPlayer == .white)
		XCTAssertEqual(0, yoinkToOriginMoves.count)
	}

	func testPillBug_WithoutFreedomOfMovementFromPosition_CannotYoinkFromPosition() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whitePillBug, at: .inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: .inPlay(x: -1, y: 2, z: -1)),
			Movement.place(unit: stateProvider.whiteLadyBug, at: .inPlay(x: 2, y: -1, z: -1)),
			Movement.move(unit: stateProvider.blackSpider, to: .inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: stateProvider.whiteLadyBug, to: .inPlay(x: 1, y: 0, z: -1)),
			Movement.place(unit: stateProvider.blackBeetle, at: .inPlay(x: 0, y: -2, z: 2)),
			Movement.place(unit: stateProvider.whiteBeetle, at: .inPlay(x: 2, y: 0, z: -2)),
			Movement.move(unit: stateProvider.blackBeetle, to: .inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: stateProvider.whiteBeetle, to: .inPlay(x: 1, y: 0, z: -1)),
			Movement.move(unit: stateProvider.blackQueen, to: .inPlay(x: 1, y: 1, z: -2))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let pillBugAvailableMoves = state.whitePillBug.availableMoves(in: state)
		let yoinkQueenMoves = pillBugAvailableMoves.filter {
			if case let .yoink(_, unit, _) = $0 {
				return unit == state.whiteQueen
			} else {
				return false
			}
		}
		XCTAssertNotEqual(0, pillBugAvailableMoves.count)
		XCTAssertEqual(0, yoinkQueenMoves.count)
	}

	func testPillBug_YoinkCannotBreakHive() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whitePillBug, at: .inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: .inPlay(x: -1, y: 2, z: -1)),
			Movement.move(unit: stateProvider.whitePillBug, to: .inPlay(x: 1, y: 0, z: -1)),
			Movement.place(unit: stateProvider.blackPillBug, at: .inPlay(x: 0, y: 2, z: -2))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let pillBugAvailableMoves = state.whitePillBug.availableMoves(in: state)
		let yoinkQueenMoves = pillBugAvailableMoves.filter {
			if case let .yoink(_, unit, _) = $0 {
				return unit == state.blackQueen
			} else {
				return false
			}
		}
		XCTAssertNotEqual(0, pillBugAvailableMoves.count)
		XCTAssertEqual(0, yoinkQueenMoves.count)
	}

	func testPillBug_CannotYoinkPieceJustYoinked() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: .inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: .inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whitePillBug, at: .inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: .inPlay(x: -1, y: 2, z: -1)),
			Movement.move(unit: stateProvider.whitePillBug, to: .inPlay(x: 1, y: 0, z: -1)),
			Movement.place(unit: stateProvider.blackPillBug, at: .inPlay(x: 0, y: 2, z: -2)),
			Movement.move(unit: stateProvider.whiteQueen, to: .inPlay(x: -1, y: 1, z: 0)),
			Movement.yoink(pillBug: stateProvider.blackPillBug, unit: stateProvider.blackSpider, to: .inPlay(x: 1, y: 1, z: -2))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let pillBugAvailableMoves = state.whitePillBug.availableMoves(in: state)
		let yoinkSpiderMoves = pillBugAvailableMoves.filter {
			if case let .yoink(_, unit, _) = $0 {
				return unit == state.blackSpider
			} else {
				return false
			}
		}
		XCTAssertNotEqual(0, pillBugAvailableMoves.count)
		XCTAssertEqual(0, yoinkSpiderMoves.count)
	}

	static var allTests = [
		("testPillBug_CanMoveAsPillBugOrQueen", testPillBug_CanMoveAsPillBugOrQueen),
		("testPillBug_CanUseSpecialAbility_IsTrue", testPillBug_CanUseSpecialAbility_IsTrue),
		("testNotPillBug_CanUseSpecialAbility_IsFalse", testNotPillBug_CanUseSpecialAbility_IsFalse),
		("testPillBugMoves_AreCorrect", testPillBugMoves_AreCorrect),

		("testPillBug_CannotMovePieceJustMoved_IsTrue", testPillBug_CannotMovePieceJustMoved_IsTrue),
		("testPillBug_PieceJustYoinkedCannotMove_IsTrue", testPillBug_PieceJustYoinkedCannotMove_IsTrue),

		("testPillBug_WithoutFreedomOfMovementToPosition_CannotYoinkToPosition", testPillBug_WithoutFreedomOfMovementToPosition_CannotYoinkToPosition),
		("testPillBug_WithoutFreedomOfMovementFromPosition_CannotYoinkFromPosition", testPillBug_WithoutFreedomOfMovementFromPosition_CannotYoinkFromPosition),
		("testPillBug_YoinkCannotBreakHive", testPillBug_YoinkCannotBreakHive),
		("testPillBug_CannotYoinkPieceJustYoinked", testPillBug_CannotYoinkPieceJustYoinked)
	]
}
