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
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 16, to: state)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .pillBug, .queen:
				XCTAssertTrue(state.whitePillBug.canCopyMoves(of: $0, in: state))
			case .ant, .hopper, .ladyBug, .mosquito, .beetle, .spider:
				XCTAssertFalse(state.whitePillBug.canCopyMoves(of: $0, in: state))
			}
		}
	}

	func testPillBug_CanUseSpecialAbility_IsTrue() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 16, to: state)
		XCTAssertTrue(state.whitePillBug.canUseSpecialAbility(in: state))
	}

	func testNotPillBug_CanUseSpecialAbility_IsFalse() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 16, to: state)
		XCTAssertFalse(state.whiteQueen.canUseSpecialAbility(in: state))
		XCTAssertFalse(state.blackMosquito.canUseSpecialAbility(in: state))
		XCTAssertFalse(state.whiteBeetle.canUseSpecialAbility(in: state))
		XCTAssertFalse(state.whiteSpider.canUseSpecialAbility(in: state))
		XCTAssertFalse(state.blackHopper.canUseSpecialAbility(in: state))
		XCTAssertFalse(state.blackLadyBug.canUseSpecialAbility(in: state))
		XCTAssertFalse(state.whiteAnt.canUseSpecialAbility(in: state))
	}

	func testPillBugMoves_AreCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 16, to: state)
		let expectedAvailableMoves: Set<Movement> = [
			.move(unit: state.whitePillBug, to: Position(x: -1, y: -1, z: 2)),
			.move(unit: state.whitePillBug, to: Position(x: 1, y: -2, z: 1)),
			.yoink(pillBug: state.whitePillBug, unit: state.whiteMosquito, to: Position(x: -1, y: -1, z: 2)),
			.yoink(pillBug: state.whitePillBug, unit: state.whiteMosquito, to: Position(x: 0, y: -2, z: 2)),
			.yoink(pillBug: state.whitePillBug, unit: state.whiteMosquito, to: Position(x: 1, y: -2, z: 1))
		]

		XCTAssertEqual(expectedAvailableMoves, state.whitePillBug.availableMoves(in: state))
	}

	func testPillBugNotInPlay_CannotMove() {
		let state = stateProvider.initialGameState
		XCTAssertEqual([], state.whitePillBug.availableMoves(in: state))
	}

	func testPillBug_CannotMovePieceJustMoved_IsTrue() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 18, to: state)
		let expectedAvailableMoves: Set<Movement> = [
			.move(unit: state.whitePillBug, to: Position(x: -1, y: -1, z: 2)),
			.move(unit: state.whitePillBug, to: Position(x: 1, y: -2, z: 1))
		]

		XCTAssertEqual(expectedAvailableMoves, state.whitePillBug.availableMoves(in: state))
	}

	func testPillBug_PieceJustYoinkedCannotMove_IsTrue() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 21, to: state)
		XCTAssertEqual(0, state.blackHopper.availableMoves(in: state).count)
	}

	func testPillBug_CannotYoinkAfterBeingYoinked_WithoutOption() {
		let state = GameState(options: [.pillBug])
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whitePillBug, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackPillBug, at: Position(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whitePillBug, to: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackAnt, at: Position(x: -1, y: 2, z: -1)),
			Movement.yoink(pillBug: state.whitePillBug, unit: state.blackPillBug, to: Position(x: 1, y: -1, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertEqual(7, state.move)
		let invalidMove = Movement.yoink(pillBug: state.blackPillBug, unit: state.whitePillBug, to: Position(x: 0, y: -1, z: 1))
		XCTAssertFalse(state.availableMoves.contains(invalidMove))
		state.apply(invalidMove)
		XCTAssertEqual(7, state.move)
	}

	func testPillBug_CanYoinkAfterBeingYoinked_WithOption() {
		let state = GameState(options: [.pillBug, .allowSpecialAbilityAfterYoink])
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whitePillBug, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackPillBug, at: Position(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whitePillBug, to: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackAnt, at: Position(x: -1, y: 2, z: -1)),
			Movement.yoink(pillBug: state.whitePillBug, unit: state.blackPillBug, to: Position(x: 1, y: -1, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		XCTAssertEqual(7, state.move)
		let validMove = Movement.yoink(pillBug: state.blackPillBug, unit: state.whitePillBug, to: Position(x: 0, y: -1, z: 1))
		XCTAssertTrue(state.availableMoves.contains(validMove))
		state.apply(validMove)
		XCTAssertEqual(8, state.move)
	}

	func testPillBug_WithoutFreedomOfMovementToPosition_CannotYoinkToPosition() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whitePillBug, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: -1, y: 2, z: -1)),
			Movement.place(unit: state.whiteLadyBug, at: Position(x: 2, y: -1, z: -1)),
			Movement.move(unit: state.blackSpider, to: Position(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.whiteLadyBug, to: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackBeetle, at: Position(x: 0, y: -2, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 2, y: 0, z: -2)),
			Movement.move(unit: state.blackBeetle, to: Position(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.whiteBeetle, to: Position(x: 1, y: 0, z: -1)),
			Movement.move(unit: state.blackQueen, to: Position(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whiteQueen, to: Position(x: -1, y: 0, z: 1)),
			Movement.move(unit: state.blackQueen, to: Position(x: 2, y: 0, z: -2)),
			Movement.move(unit: state.whiteQueen, to: Position(x: -1, y: -1, z: 2)),
			Movement.move(unit: state.blackQueen, to: Position(x: 2, y: -1, z: -1))
			]

		stateProvider.apply(moves: setupMoves, to: state)
		let yoinkToOriginMoves = state.availableMoves.filter {
			if case let .yoink(_, _, position) = $0 {
				return position == .origin
			} else {
				return false
			}
		}
		XCTAssertTrue(state.currentPlayer == .white)
		XCTAssertEqual(0, yoinkToOriginMoves.count)
	}

	func testPillBug_WithoutFreedomOfMovementFromPosition_CannotYoinkFromPosition() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whitePillBug, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: -1, y: 2, z: -1)),
			Movement.place(unit: state.whiteLadyBug, at: Position(x: 2, y: -1, z: -1)),
			Movement.move(unit: state.blackSpider, to: Position(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.whiteLadyBug, to: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackBeetle, at: Position(x: 0, y: -2, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 2, y: 0, z: -2)),
			Movement.move(unit: state.blackBeetle, to: Position(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.whiteBeetle, to: Position(x: 1, y: 0, z: -1)),
			Movement.move(unit: state.blackQueen, to: Position(x: 1, y: 1, z: -2))
			]

		stateProvider.apply(moves: setupMoves, to: state)
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
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whitePillBug, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: -1, y: 2, z: -1)),
			Movement.move(unit: state.whitePillBug, to: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackPillBug, at: Position(x: 0, y: 2, z: -2))
			]

		stateProvider.apply(moves: setupMoves, to: state)
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
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whitePillBug, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: -1, y: 2, z: -1)),
			Movement.move(unit: state.whitePillBug, to: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackPillBug, at: Position(x: 0, y: 2, z: -2)),
			Movement.move(unit: state.whiteQueen, to: Position(x: -1, y: 1, z: 0)),
			Movement.yoink(pillBug: state.blackPillBug, unit: state.blackSpider, to: Position(x: 1, y: 1, z: -2))
			]

		stateProvider.apply(moves: setupMoves, to: state)
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
		("testPillBugNotInPlay_CannotMove", testPillBugNotInPlay_CannotMove),

		("testPillBug_CannotMovePieceJustMoved_IsTrue", testPillBug_CannotMovePieceJustMoved_IsTrue),
		("testPillBug_PieceJustYoinkedCannotMove_IsTrue", testPillBug_PieceJustYoinkedCannotMove_IsTrue),
		("testPillBug_CannotYoinkAfterBeingYoinked_WithoutOption", testPillBug_CannotYoinkAfterBeingYoinked_WithoutOption),
		("testPillBug_CanYoinkAfterBeingYoinked_WithOption", testPillBug_CanYoinkAfterBeingYoinked_WithOption),

		("testPillBug_WithoutFreedomOfMovementToPosition_CannotYoinkToPosition", testPillBug_WithoutFreedomOfMovementToPosition_CannotYoinkToPosition),
		("testPillBug_WithoutFreedomOfMovementFromPosition_CannotYoinkFromPosition", testPillBug_WithoutFreedomOfMovementFromPosition_CannotYoinkFromPosition),
		("testPillBug_YoinkCannotBreakHive", testPillBug_YoinkCannotBreakHive),
		("testPillBug_CannotYoinkPieceJustYoinked", testPillBug_CannotYoinkPieceJustYoinked)
	]
}
