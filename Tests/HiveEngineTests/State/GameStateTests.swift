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
		XCTFail("Not implemented")
	}

	func testPartialGameState_PlayablSpaces_AreCorrect() {
		XCTFail("Not implemented")
	}

	func testPartialGameState_IsNotEndGame() {
		XCTFail("Not implemented")
	}

	func testParialGameState_ApplyMovement_ValidMoveReturnsState() {
		XCTFail("Not implemented")
	}

	func testPartialGameState_ApplyMovement_InvalidMoveReturnsSelf() {
		XCTFail("Not implemented")
	}

	func testPartialGameState_AvailablePieces_ExcludesPlayedPieces() {
		XCTFail("Not implemented")
	}

	func testPartialGameState_AdjacentUnits_IsCorrect() {
		XCTFail("Not implemented")
	}

	func testPartialGameState_AdjacentPositions_IsCorrect() {
		XCTFail("Not implemented")
	}

	func testPartialGameState_OneHive_IsCorrect() {
		XCTFail("Not implemented")
	}

	func testPartialGameState_OneHive_ExcludingUnit_IsCorrect() {
		XCTFail("Not implemented")
	}

	// MARK: - Won Game State

	func testFinishedGameState_HasOneWinner() {
		XCTFail("Not implemented")
	}

	func testFinishedGameState_HasNoMoves() {
		XCTFail("Not implemented")
	}

	func testFinishedGameState_IsEndGame() {
		XCTFail("Not implemented")
	}

	func testFinishedGameState_ApplyMovement_ReturnsSelf() {
		XCTFail("Not implemented")
	}

	// MARK: - Tied Game State

	func testTiedGameState_HasTwoWinners() {
		XCTFail("Not implemented")
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
		("testPartialGameState_MustPlayQueenInFirstFourMoves", testPartialGameState_MustPlayQueenInFirstFourMoves),
		("testPartialGameState_PlayablSpaces_AreCorrect", testPartialGameState_PlayablSpaces_AreCorrect),
		("testPartialGameState_IsNotEndGame", testPartialGameState_IsNotEndGame),
		("testParialGameState_ApplyMovement_ValidMoveReturnsState", testParialGameState_ApplyMovement_ValidMoveReturnsState),
		("testPartialGameState_ApplyMovement_InvalidMoveReturnsSelf", testPartialGameState_ApplyMovement_InvalidMoveReturnsSelf),
		("testPartialGameState_AvailablePieces_ExcludesPlayedPieces", testPartialGameState_AvailablePieces_ExcludesPlayedPieces),
		("testPartialGameState_AdjacentUnits_IsCorrect", testPartialGameState_AdjacentUnits_IsCorrect),
		("testPartialGameState_AdjacentPositions_IsCorrect", testPartialGameState_AdjacentPositions_IsCorrect),
		("testPartialGameState_OneHive_IsCorrect", testPartialGameState_OneHive_IsCorrect),
		("testPartialGameState_OneHive_ExcludingUnit_IsCorrect", testPartialGameState_OneHive_ExcludingUnit_IsCorrect),
		("testFinishedGameState_HasOneWinner", testFinishedGameState_HasOneWinner),
		("testFinishedGameState_HasNoMoves", testFinishedGameState_HasNoMoves),
		("testFinishedGameState_IsEndGame", testFinishedGameState_IsEndGame),
		("testFinishedGameState_ApplyMovement_ReturnsSelf", testFinishedGameState_ApplyMovement_ReturnsSelf),
		("testTiedGameState_HasTwoWinners", testTiedGameState_HasTwoWinners)
	]
}
