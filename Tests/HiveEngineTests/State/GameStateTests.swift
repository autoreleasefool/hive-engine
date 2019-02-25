//
//  GameStateTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-16.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
@testable import HiveEngine

final class GameStateTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	// MARK: - Initial Game State

	func testInitialGameState_IsFirstMove() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(0, state.move)
	}

	func testInitialGameState_UnitsAreNotInPlay() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(Set(), state.unitsInPlay)
	}

	func testInitialGameState_PlayerHasAllUnitsAvailable() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(14, state.availablePieces(for: .white).count)
		XCTAssertEqual(14, state.availablePieces(for: .black).count)

		// 3 ants
		XCTAssertEqual(3, state.availablePieces(for: .white).filter { $0.class == .ant }.count)
		XCTAssertEqual(3, state.availablePieces(for: .black).filter { $0.class == .ant }.count)

		// 2 beetles
		XCTAssertEqual(2, state.availablePieces(for: .white).filter { $0.class == .beetle }.count)
		XCTAssertEqual(2, state.availablePieces(for: .black).filter { $0.class == .beetle }.count)

		// 3 hoppers
		XCTAssertEqual(3, state.availablePieces(for: .white).filter { $0.class == .hopper }.count)
		XCTAssertEqual(3, state.availablePieces(for: .black).filter { $0.class == .hopper }.count)

		// 1 lady bug
		XCTAssertEqual(1, state.availablePieces(for: .white).filter { $0.class == .ladyBug }.count)
		XCTAssertEqual(1, state.availablePieces(for: .black).filter { $0.class == .ladyBug }.count)

		// 1 mosquito
		XCTAssertEqual(1, state.availablePieces(for: .white).filter { $0.class == .mosquito }.count)
		XCTAssertEqual(1, state.availablePieces(for: .black).filter { $0.class == .mosquito }.count)

		// 1 pill bug
		XCTAssertEqual(1, state.availablePieces(for: .white).filter { $0.class == .pillBug }.count)
		XCTAssertEqual(1, state.availablePieces(for: .black).filter { $0.class == .pillBug }.count)

		// 1 queen
		XCTAssertEqual(1, state.availablePieces(for: .white).filter { $0.class == .queen }.count)
		XCTAssertEqual(1, state.availablePieces(for: .black).filter { $0.class == .queen }.count)

		// 2 spiders
		XCTAssertEqual(2, state.availablePieces(for: .white).filter { $0.class == .spider }.count)
		XCTAssertEqual(2, state.availablePieces(for: .black).filter { $0.class == .spider }.count)
	}

	func testInitialGameState_WhitePlayerIsFirst() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(Player.white, state.currentPlayer)
	}

	func testInitialGameState_HasNoWinner() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(0, state.winner.count)
	}

	func testInitialGameState_HasNoStacks() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(0, state.stacks.keys.count)
	}

	func testInitialGameState_OnlyHasPlaceMovesAvailable() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(0, state.availableMoves.filter {
			switch $0 {
			case .place: return false
			case .move: return true
			case .yoink: return true
			}
		}.count)
	}

	// MARK: - Partial Game State

	func testPartialGameState_MustPlayQueenInFirstFourMoves() {
		let whiteMoveState = stateProvider.gameState(after: 6)
		XCTAssertEqual(0, whiteMoveState.availableMoves.filter { $0.movedUnit != whiteMoveState.whiteQueen }.count)

		let blackMoveState = stateProvider.gameState(after: 7)
		XCTAssertEqual(0, blackMoveState.availableMoves.filter { $0.movedUnit != blackMoveState.blackQueen }.count)
	}

	func testPartialGameState_Move_IncrementsCorrectly() {
		let state = stateProvider.gameState(after: 8)
		XCTAssertEqual(8, state.move)

		let move: Movement = .place(unit: state.whiteLadyBug, at: .inPlay(x: 0, y: -2, z: 2))
		let nextState = state.apply(move)
		XCTAssertEqual(9, nextState.move)
	}

	func testPartialGameState_PlayableSpaces_AreCorrect() {
		let state = stateProvider.gameState(after: 8)
		let playableSpaces: Set<Position> = Set([
			.inPlay(x: 0, y: 3, z: -3), .inPlay(x: 1, y: 2, z: -3),
			.inPlay(x: 2, y: 1, z: -3), .inPlay(x: 2, y: 0, z: -2),
			.inPlay(x: 1, y: 0, z: -1), .inPlay(x: 2, y: -1, z: -1),
			.inPlay(x: 2, y: -2, z: 0), .inPlay(x: 1, y: -2, z: 1),
			.inPlay(x: 0, y: -2, z: 2), .inPlay(x: -1, y: -1, z: 2),
			.inPlay(x: -2, y: 0, z: 2), .inPlay(x: -2, y: 1, z: 1),
			.inPlay(x: -1, y: 1, z: 0), .inPlay(x: -2, y: 2, z: 0),
			.inPlay(x: -2, y: 3, z: -1), .inPlay(x: -1, y: 3, z: -2),
			])

		XCTAssertEqual(playableSpaces, state.playableSpaces())
	}

	func testPartialGameState_IsNotEndGame() {
		let state = stateProvider.gameState(after: 8)
		XCTAssertFalse(state.isEndGame)
	}

	func testParialGameState_ApplyMovement_ValidMoveReturnsState() {
		let state = stateProvider.gameState(after: 8)
		let move: Movement = .place(unit: state.whiteLadyBug, at: .inPlay(x: 0, y: -2, z: 2))
		XCTAssertTrue(state.availableMoves.contains(move))
		XCTAssertNotEqual(state, state.apply(move))
	}

	func testPartialGameState_ApplyMovement_InvalidMoveReturnsSelf() {
		let state = stateProvider.gameState(after: 8)
		let invalidMove: Movement = .place(unit: state.whiteLadyBug, at: .inPlay(x: 0, y: -3, z: 3))
		XCTAssertFalse(state.availableMoves.contains(invalidMove))
		XCTAssertEqual(state, state.apply(invalidMove))
	}

	func testPartialGameState_AvailablePieces_ExcludesPlayedPieces() {
		let state = stateProvider.gameState(after: 8)

		let whitePieces: Set<HiveEngine.Unit> = Set([
			state.whiteSpider, state.whiteAnt,
			state.whiteQueen, state.whitePillBug
			])
		XCTAssertEqual(0, state.availablePieces(for: .white).intersection(whitePieces).count)

		let blackPieces: Set<HiveEngine.Unit> = Set([
			state.blackHopper, state.blackSpider,
			state.blackLadyBug, state.blackQueen
			])
		XCTAssertEqual(0, state.availablePieces(for: .black).intersection(blackPieces).count)
	}

	func testPartialGameState_AdjacentUnits_ToUnit_IsCorrect() {
		let state = stateProvider.gameState(after: 13)
		let adjacentUnits: Set<HiveEngine.Unit> = Set([state.blackMosquito, state.whiteBeetle, state.whitePillBug])
		XCTAssertEqual(adjacentUnits, state.units(adjacentTo: state.whiteQueen))
	}

	func testPartialGameState_AdjacentUnits_ToPosition_IsCorrect() {
		let state = stateProvider.gameState(after: 13)
		let adjacentUnits: Set<HiveEngine.Unit> = Set([state.blackHopper, state.blackQueen, state.blackLadyBug, state.blackMosquito, state.whiteBeetle])
		XCTAssertEqual(adjacentUnits, state.units(adjacentTo: .inPlay(x: 0, y: 1, z: -1)))
	}

	func testPartialGameState_OneHive_IsCorrect() {
		let state = stateProvider.gameState(after: 8)
		XCTAssertTrue(state.oneHive())
	}

	func testPartialGameState_OneHive_ExcludingUnit_IsCorrect() {
		let state = stateProvider.gameState(after: 8)
		XCTAssertFalse(state.oneHive(excluding: state.whiteSpider))
	}

	// MARK: - Won Game State

	func testFinishedGameState_HasOneWinner() {
		let state = stateProvider.wonGameState
		XCTAssertEqual(1, state.winner.count)
	}

	func testFinishedGameState_HasNoMoves() {
		let state = stateProvider.wonGameState
		XCTAssertEqual(0, state.availableMoves.count)
	}

	func testFinishedGameState_IsEndGame() {
		let state = stateProvider.wonGameState
		XCTAssertTrue(state.isEndGame)
	}

	func testFinishedGameState_ApplyMovement_ReturnsSelf() {
		let state = stateProvider.wonGameState
		XCTAssertEqual(state, state.apply(.move(unit: state.whiteAnt, to: .inPlay(x: 0, y: 0, z: 0))))
	}

	// MARK: - Tied Game State

	func testTiedGameState_HasTwoWinners() {
		let state = stateProvider.tiedGameState
		XCTAssertEqual(2, state.winner.count)
	}

	// MARK: - Linux Tests

	static var allTests = [
		("testInitialGameState_IsFirstMove", testInitialGameState_IsFirstMove),
		("testInitialGameState_UnitsAreNotInPlay", testInitialGameState_UnitsAreNotInPlay),
		("testInitialGameState_PlayerHasAllUnitsAvailable", testInitialGameState_PlayerHasAllUnitsAvailable),
		("testInitialGameState_WhitePlayerIsFirst", testInitialGameState_WhitePlayerIsFirst),
		("testInitialGameState_HasNoWinner", testInitialGameState_HasNoWinner),
		("testInitialGameState_HasNoStacks", testInitialGameState_HasNoStacks),
		("testInitialGameState_OnlyHasPlaceMovesAvailable", testInitialGameState_OnlyHasPlaceMovesAvailable),

		("testPartialGameState_Move_IncrementsCorrectly", testPartialGameState_Move_IncrementsCorrectly),
		("testPartialGameState_MustPlayQueenInFirstFourMoves", testPartialGameState_MustPlayQueenInFirstFourMoves),
		("testPartialGameState_PlayableSpaces_AreCorrect", testPartialGameState_PlayableSpaces_AreCorrect),
		("testPartialGameState_IsNotEndGame", testPartialGameState_IsNotEndGame),
		("testParialGameState_ApplyMovement_ValidMoveReturnsState", testParialGameState_ApplyMovement_ValidMoveReturnsState),
		("testPartialGameState_ApplyMovement_InvalidMoveReturnsSelf", testPartialGameState_ApplyMovement_InvalidMoveReturnsSelf),
		("testPartialGameState_AvailablePieces_ExcludesPlayedPieces", testPartialGameState_AvailablePieces_ExcludesPlayedPieces),
		("testPartialGameState_AdjacentUnits_ToUnit_IsCorrect", testPartialGameState_AdjacentUnits_ToUnit_IsCorrect),
		("testPartialGameState_AdjacentUnits_ToPosition_IsCorrect", testPartialGameState_AdjacentUnits_ToPosition_IsCorrect),
		("testPartialGameState_OneHive_IsCorrect", testPartialGameState_OneHive_IsCorrect),
		("testPartialGameState_OneHive_ExcludingUnit_IsCorrect", testPartialGameState_OneHive_ExcludingUnit_IsCorrect),

		("testFinishedGameState_HasOneWinner", testFinishedGameState_HasOneWinner),
		("testFinishedGameState_HasNoMoves", testFinishedGameState_HasNoMoves),
		("testFinishedGameState_IsEndGame", testFinishedGameState_IsEndGame),
		("testFinishedGameState_ApplyMovement_ReturnsSelf", testFinishedGameState_ApplyMovement_ReturnsSelf),

		("testTiedGameState_HasTwoWinners", testTiedGameState_HasTwoWinners)
	]
}
