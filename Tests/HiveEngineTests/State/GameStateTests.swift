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
		XCTAssertEqual([:], state.unitsInPlay[Player.white])
		XCTAssertEqual([:], state.unitsInPlay[Player.black])
	}

	func testInitialGameState_NoOptionsHasNoExtensionUnits() {
		let state = GameState(options: [])
		XCTAssertEqual(11, state.unitsInHand[Player.white]!.count)
		XCTAssertEqual(11, state.unitsInHand[Player.black]!.count)

		XCTAssertEqual(0, state.unitsInHand[Player.white]!.filter { $0.class == .ladyBug }.count)
		XCTAssertEqual(0, state.unitsInHand[Player.black]!.filter { $0.class == .ladyBug }.count)
		XCTAssertEqual(0, state.unitsInHand[Player.white]!.filter { $0.class == .mosquito }.count)
		XCTAssertEqual(0, state.unitsInHand[Player.black]!.filter { $0.class == .mosquito }.count)
		XCTAssertEqual(0, state.unitsInHand[Player.white]!.filter { $0.class == .pillBug }.count)
		XCTAssertEqual(0, state.unitsInHand[Player.black]!.filter { $0.class == .pillBug }.count)
	}

	func testInitialGameState_LadyBugOptionAddsLadyBugUnit() {
		let state = GameState(options: [.ladyBug])
		XCTAssertEqual(12, state.unitsInHand[Player.white]!.count)
		XCTAssertEqual(12, state.unitsInHand[Player.black]!.count)

		XCTAssertEqual(1, state.unitsInHand[Player.white]!.filter { $0.class == .ladyBug }.count)
		XCTAssertEqual(1, state.unitsInHand[Player.black]!.filter { $0.class == .ladyBug }.count)
	}

	func testInitialGameState_MosquitoOptionAddsMosquitoUnit() {
		let state = GameState(options: [.mosquito])
		XCTAssertEqual(12, state.unitsInHand[Player.white]!.count)
		XCTAssertEqual(12, state.unitsInHand[Player.black]!.count)

		XCTAssertEqual(1, state.unitsInHand[Player.white]!.filter { $0.class == .mosquito }.count)
		XCTAssertEqual(1, state.unitsInHand[Player.black]!.filter { $0.class == .mosquito }.count)
	}

	func testInitialGameState_PillBugOptionAddsPillBugUnit() {
		let state = GameState(options: [.pillBug])
		XCTAssertEqual(12, state.unitsInHand[Player.white]!.count)
		XCTAssertEqual(12, state.unitsInHand[Player.black]!.count)

		XCTAssertEqual(1, state.unitsInHand[Player.white]!.filter { $0.class == .pillBug }.count)
		XCTAssertEqual(1, state.unitsInHand[Player.black]!.filter { $0.class == .pillBug }.count)
	}

	func testInitialGameState_PlayerHasAllUnitsAvailable() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(14, state.unitsInHand[Player.white]!.count)
		XCTAssertEqual(14, state.unitsInHand[Player.black]!.count)

		// 3 ants
		XCTAssertEqual(3, state.unitsInHand[Player.white]!.filter { $0.class == .ant }.count)
		XCTAssertEqual(3, state.unitsInHand[Player.black]!.filter { $0.class == .ant }.count)

		// 2 beetles
		XCTAssertEqual(2, state.unitsInHand[Player.white]!.filter { $0.class == .beetle }.count)
		XCTAssertEqual(2, state.unitsInHand[Player.black]!.filter { $0.class == .beetle }.count)

		// 3 hoppers
		XCTAssertEqual(3, state.unitsInHand[Player.white]!.filter { $0.class == .hopper }.count)
		XCTAssertEqual(3, state.unitsInHand[Player.black]!.filter { $0.class == .hopper }.count)

		// 1 lady bug
		XCTAssertEqual(1, state.unitsInHand[Player.white]!.filter { $0.class == .ladyBug }.count)
		XCTAssertEqual(1, state.unitsInHand[Player.black]!.filter { $0.class == .ladyBug }.count)

		// 1 mosquito
		XCTAssertEqual(1, state.unitsInHand[Player.white]!.filter { $0.class == .mosquito }.count)
		XCTAssertEqual(1, state.unitsInHand[Player.black]!.filter { $0.class == .mosquito }.count)

		// 1 pill bug
		XCTAssertEqual(1, state.unitsInHand[Player.white]!.filter { $0.class == .pillBug }.count)
		XCTAssertEqual(1, state.unitsInHand[Player.black]!.filter { $0.class == .pillBug }.count)

		// 1 queen
		XCTAssertEqual(1, state.unitsInHand[Player.white]!.filter { $0.class == .queen }.count)
		XCTAssertEqual(1, state.unitsInHand[Player.black]!.filter { $0.class == .queen }.count)

		// 2 spiders
		XCTAssertEqual(2, state.unitsInHand[Player.white]!.filter { $0.class == .spider }.count)
		XCTAssertEqual(2, state.unitsInHand[Player.black]!.filter { $0.class == .spider }.count)
	}

	func testInitialGameState_UnitIndicesAreCorrect() {
		let state = stateProvider.initialGameState
		let unitIndices = state.unitsInHand[Player.white]!.sorted().map { $0.index }
		XCTAssertEqual([1, 2, 3, 1, 2, 1, 2, 3, 1, 1, 1, 1, 1, 2], unitIndices)
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

	func testInitialGameState_HasNoLastPlayer() {
		let state = stateProvider.initialGameState
		XCTAssertNil(state.lastPlayer)
	}

	func testInitialGameState_OnlyHasPlaceMovesAvailable() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(0, state.availableMoves.filter {
			switch $0 {
			case .place: return false
			case .move: return true
			case .yoink: return true
			case .pass: return true
			}
		}.count)
	}

	func testInitialGameState_OnlyLowestIndexUnitCanBePlayed() {
		let state = stateProvider.initialGameState
		var unitsWithIndexGreaterThanOne = Set(state.availableMoves.compactMap { $0.movedUnit!.index > 1 ? $0.movedUnit : nil })
		XCTAssertEqual(0, unitsWithIndexGreaterThanOne.count)

		let moves: [Movement] = [
			.place(unit: state.whiteAnt, at: .origin),
			.place(unit: state.blackAnt, at: Position(x: 1, y: -1, z: 0)),
		]
		stateProvider.apply(moves: moves, to: state)
		unitsWithIndexGreaterThanOne = Set(state.availableMoves.compactMap { $0.movedUnit!.index > 1 ? $0.movedUnit : nil })
		XCTAssertEqual(1, unitsWithIndexGreaterThanOne.count)
	}

	func testInitialGameState_HasNoPreviousMoves() {
		let state = stateProvider.initialGameState
		XCTAssertEqual(0, state.previousMoves.count)
	}

	func testInitialGameState_ValidatesMoves() {
		let state = stateProvider.initialGameState
		XCTAssertFalse(state.options.contains(.disableMovementValidation))
		XCTAssertFalse(state.apply(.place(unit: state.whiteAnt, at: Position(x: 1, y: 1, z: 1))))
	}

	func testInitialGameState_WithoutMoveValidation_AcceptsInvalidMoves() {
		let state = GameState(options: [.disableMovementValidation])
		XCTAssertTrue(state.apply(.place(unit: state.whiteAnt, at: Position(x: 1, y: 1, z: 1))))

		let expectedUnits = Set([state.whiteAnt])
		XCTAssertEqual(expectedUnits, Set(state.allUnitsInPlay.keys))
		XCTAssertEqual(Position(x: 1, y: 1, z: 1), state.unitsInPlay[Player.white]?[state.whiteAnt])
	}

	// MARK: - Partial Game State

	func testPartialGameState_PreviousMove_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 9, to: state)
		let expectedUpdate = GameStateUpdate(
			player: .white,
			movement: .move(unit: state.whiteAnt, to: Position(x: 0, y: 3, z: -3)),
			previousPosition: Position(x: -1, y: 0, z: 1),
			move: 8,
			notation: "wA1 \\bQ"
		)
		XCTAssertEqual(expectedUpdate, state.previousMoves.last)
	}

	func testPartialGameState_LastPlayer_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 9, to: state)
		XCTAssertEqual(Player.white, state.lastPlayer)
	}

	func testPartialGameState_MustPlayQueenInFirstFourMoves() {
		let whiteMoveState = stateProvider.initialGameState
		stateProvider.apply(moves: 6, to: whiteMoveState)
		XCTAssertEqual(0, whiteMoveState.availableMoves.filter { $0.movedUnit != whiteMoveState.whiteQueen }.count)

		let blackMoveState = stateProvider.initialGameState
		stateProvider.apply(moves: 7, to: blackMoveState)
		XCTAssertEqual(0, blackMoveState.availableMoves.filter { $0.movedUnit != blackMoveState.blackQueen }.count)
	}

	func testPartialGameState_Move_IncrementsCorrectly() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)
		XCTAssertEqual(8, state.move)

		let move: Movement = .place(unit: state.whiteLadyBug, at: Position(x: 0, y: -2, z: 2))
		state.apply(move)
		XCTAssertEqual(9, state.move)
	}

	func testPartialGameState_PlayableSpaces_AreCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)
		let playableSpaces: Set<Position> = Set([
			Position(x: 0, y: 3, z: -3), Position(x: 1, y: 2, z: -3),
			Position(x: 2, y: 1, z: -3), Position(x: 2, y: 0, z: -2),
			Position(x: 1, y: 0, z: -1), Position(x: 2, y: -1, z: -1),
			Position(x: 2, y: -2, z: 0), Position(x: 1, y: -2, z: 1),
			Position(x: 0, y: -2, z: 2), Position(x: -1, y: -1, z: 2),
			Position(x: -2, y: 0, z: 2), Position(x: -2, y: 1, z: 1),
			Position(x: -1, y: 1, z: 0), Position(x: -2, y: 2, z: 0),
			Position(x: -2, y: 3, z: -1), Position(x: -1, y: 3, z: -2),
			])

		XCTAssertEqual(playableSpaces, state.playableSpaces())
	}

	func testPartialGameState_IsNotEndGame() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)
		XCTAssertFalse(state.isEndGame)
	}

	func testPartialGameState_ApplyMovement_ValidMoveUpdatesState() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)
		let move: Movement = .place(unit: state.whiteLadyBug, at: Position(x: 0, y: -2, z: 2))
		XCTAssertTrue(state.availableMoves.contains(move))
		state.apply(move)
		XCTAssertEqual(9, state.move)
	}

	func testPartialGameState_ApplyMovement_InvalidMoveDoesNotModify() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)
		let invalidMove: Movement = .place(unit: state.whiteLadyBug, at: Position(x: 0, y: -3, z: 3))
		XCTAssertFalse(state.availableMoves.contains(invalidMove))
		state.apply(invalidMove)
		XCTAssertEqual(8, state.move)
	}

	func testPartialGameState_AvailablePieces_ExcludesPlayedPieces() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)

		let whitePieces: Set<HiveEngine.Unit> = Set([
			state.whiteSpider, state.whiteAnt,
			state.whiteQueen, state.whitePillBug,
			])
		XCTAssertEqual(0, state.unitsInHand[Player.white]!.intersection(whitePieces).count)

		let blackPieces: Set<HiveEngine.Unit> = Set([
			state.blackHopper, state.blackSpider,
			state.blackLadyBug, state.blackQueen,
			])
		XCTAssertEqual(0, state.unitsInHand[Player.black]!.intersection(blackPieces).count)
	}

	func testPartialGameState_AdjacentUnits_ToUnit_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 13, to: state)
		let adjacentUnits: [HiveEngine.Unit] = [state.blackMosquito, state.whitePillBug, state.whiteBeetle]
		XCTAssertEqual(adjacentUnits, state.units(adjacentTo: state.whiteQueen))
	}

	func testPartialGameState_AdjacentUnits_ToPosition_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 13, to: state)
		let adjacentUnits: [HiveEngine.Unit] = [state.blackQueen, state.blackLadyBug, state.blackMosquito, state.whiteBeetle, state.blackHopper]
		XCTAssertEqual(adjacentUnits, state.units(adjacentTo: Position(x: 0, y: 1, z: -1)))
	}

	func testPartialGameState_OneHive_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)
		XCTAssertTrue(state.oneHive())
	}

	func testPartialGameState_OneHive_ExcludingUnit_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 8, to: state)
		XCTAssertFalse(state.oneHive(excluding: state.whiteSpider))
		XCTAssertTrue(state.oneHive(excluding: state.whiteQueen))
	}

	func testPartialGameState_PlayableSpacesForBlackPlayer_OnlyBesideBlackUnits() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 3, to: state)
		let expectedPositions: Set<Position> = [
			Position(x: -1, y: 2, z: -1),
			Position(x: 0, y: 2, z: -2),
			Position(x: 1, y: 1, z: -2),
		]

		XCTAssertEqual(expectedPositions, state.playableSpaces(for: .black))
	}

	func testPartialGameState_PlayableSpacesForBlackPlayerOnFirstMove_BesideWhiteUnits() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 1, to: state)
		let expectedPositions: Set<Position> = [
			Position(x: 0, y: 1, z: -1),
			Position(x: 1, y: 0, z: -1),
			Position(x: 1, y: -1, z: 0),
			Position(x: 0, y: -1, z: 1),
			Position(x: -1, y: 0, z: 1),
			Position(x: -1, y: 1, z: 0),
		]

		XCTAssertEqual(expectedPositions, state.playableSpaces(for: .black))
	}

	func testPartialGameState_ShutOutPlayer_HasOnlyPassMove() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.blackQueen, to: Position(x: 1, y: 0, z: -1)),
			Movement.move(unit: state.whiteAnt, to: Position(x: 2, y: 0, z: -2)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMoves: Set<Movement> = [.pass]
		XCTAssertEqual(expectedMoves, state.availableMoves)
	}

	func testPartialGameState_ApplyAndUndoPassMove() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.blackQueen, to: Position(x: 1, y: 0, z: -1)),
			Movement.move(unit: state.whiteAnt, to: Position(x: 2, y: 0, z: -2)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMoves: Set<Movement> = [.pass]
		XCTAssertEqual(expectedMoves, state.availableMoves)
		XCTAssertEqual(5, state.move)
		state.apply(.pass)
		XCTAssertEqual(6, state.move)

		let expectedUpdate = GameStateUpdate(player: .black, movement: .pass, previousPosition: nil, move: 5, notation: "pass")
		XCTAssertEqual(expectedUpdate, state.previousMoves.last)

		state.undoMove()
		XCTAssertEqual(5, state.move)
	}

	func testPartialGameState_PlayerHasAvailableMoves() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 1, to: state)
		XCTAssertTrue(state.availableMoves.count > 0)
		XCTAssertNotEqual(Movement.pass, state.availableMoves.first)
	}

	func testPartialGameState_UndoPlace_CreatesOldGameState() {
		let state = stateProvider.initialGameState
		let stateAfterUndo = GameState(from: state)
		stateProvider.apply(moves: 6, to: state)
		stateProvider.apply(moves: 5, to: stateAfterUndo)

		state.undoMove()
		XCTAssertEqual(stateAfterUndo, state)
	}

	func testPartialGameState_UndoMove_CreatesOldGameState() {
		let state = stateProvider.initialGameState
		let stateAfterUndo = GameState(from: state)
		stateProvider.apply(moves: 24, to: state)
		stateProvider.apply(moves: 23, to: stateAfterUndo)

		state.undoMove()
		XCTAssertEqual(stateAfterUndo, state)
	}

	func testPartialGameState_UndoYoink_CreatesOldGameState() {
		let state = stateProvider.initialGameState
		let stateAfterUndo = GameState(from: state)
		stateProvider.apply(moves: 21, to: state)
		stateProvider.apply(moves: 20, to: stateAfterUndo)

		state.undoMove()
		XCTAssertEqual(stateAfterUndo, state)
	}

	func testPartialGameState_CannotMoveUntilQueenPlaced() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 5, to: state)

		let moveMovements = state.availableMoves.filter {
			switch $0 {
			case .move: return true
			case .yoink: return true
			case .place: return false
			case .pass: return true
			}
		}

		XCTAssertEqual(0, moveMovements.count)
	}

	func testPartialGameState_QueenPlayed_IsCorrect() {
		let state = stateProvider.initialGameState

		XCTAssertFalse(state.queenPlayed(for: .white))
		XCTAssertFalse(state.queenPlayed(for: .black))

		stateProvider.apply(moves: 8, to: state)

		XCTAssertTrue(state.queenPlayed(for: .white))
		XCTAssertTrue(state.queenPlayed(for: .black))
	}

	// MARK: - Won Game State

	func testFinishedGameState_PlayerHasNoAvailableMoves() {
		let state = stateProvider.wonGameState
		XCTAssertEqual([], state.availableMoves)
	}

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

	func testFinishedGameState_ApplyMovement_DoesNotModifyState() {
		let state = stateProvider.wonGameState
		let expectedMove = state.move
		state.apply(.move(unit: state.whiteAnt, to: .origin))
		XCTAssertEqual(expectedMove, state.move)
	}

	// MARK: - Tied Game State

	func testTiedGameState_HasTwoWinners() {
		let state = stateProvider.tiedGameState
		XCTAssertEqual(2, state.winner.count)
	}

	// MARK: - Other tests

	func testIdenticalGameStateHashesAreIdentical() {
		var firstHasher = Hasher()
		let firstState = GameState()
		firstState.hash(into: &firstHasher)

		var secondHasher = Hasher()
		let secondState = GameState()
		secondState.hash(into: &secondHasher)

		XCTAssertEqual(firstHasher.finalize(), secondHasher.finalize())
	}

	func testCopyingGameState_IsCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 4, to: state)

		let copiedState = GameState(from: state)

		state.apply(state.availableMoves.first!)
		state.apply(state.availableMoves.first!)
		state.apply(state.availableMoves.first!)

		XCTAssertNotEqual(copiedState.unitsInHand[Player.white], state.unitsInHand[Player.white])
		XCTAssertNotEqual(copiedState.unitsInPlay[Player.white], state.unitsInPlay[Player.white])

		XCTAssertNotEqual(copiedState.unitsInHand[Player.black], state.unitsInHand[Player.black])
		XCTAssertNotEqual(copiedState.unitsInPlay[Player.black], state.unitsInPlay[Player.black])

		XCTAssertNotEqual(copiedState.stacks, state.stacks)

		XCTAssertNotEqual(copiedState.move, state.move)
		XCTAssertNotEqual(copiedState.currentPlayer, state.currentPlayer)
	}

	func testGameStateUpdate_Notation_IsCorrect() {
		let state = GameState(options: [.ladyBug, .pillBug, .mosquito, .disableMovementValidation])

		state.apply(.place(unit: state.whiteQueen, at: .origin))
		XCTAssertEqual("wQ", state.previousMoves.last!.notation)

		state.apply(.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)))
		XCTAssertEqual("bQ \\wQ", state.previousMoves.last!.notation)

		state.undoMove()
		state.apply(.place(unit: state.whiteBeetle, at: Position(x: 1, y: 0, z: -1)))
		XCTAssertEqual("wB1 wQ/", state.previousMoves.last!.notation)

		state.undoMove()
		state.apply(.place(unit: state.blackHopper, at: Position(x: 1, y: -1, z: 0)))
		XCTAssertEqual("bG1 wQ-", state.previousMoves.last!.notation)

		state.undoMove()
		state.apply(.place(unit: state.whiteLadyBug, at: Position(x: 0, y: -1, z: 1)))
		XCTAssertEqual("wL wQ\\", state.previousMoves.last!.notation)

		state.undoMove()
		state.apply(.place(unit: state.blackSpider, at: Position(x: -1, y: 0, z: 1)))
		XCTAssertEqual("bS1 /wQ", state.previousMoves.last!.notation)

		state.undoMove()
		state.apply(.place(unit: state.whitePillBug, at: Position(x: -1, y: 1, z: 0)))
		XCTAssertEqual("wP -wQ", state.previousMoves.last!.notation)

		state.undoMove()
		state.apply(.place(unit: state.whiteBeetle, at: Position(x: 1, y: 0, z: -1)))
		state.apply(.move(unit: state.whiteBeetle, to: .origin))
		XCTAssertEqual("wB1 wQ", state.previousMoves.last!.notation)

		state.undoMove()
		state.apply(.place(unit: state.whiteAnt, at: Position(x: 1, y: 1, z: -2)))
		XCTAssertEqual("wA1 \\wB1", state.previousMoves.last!.notation)

		state.apply(.place(unit: state.blackHopper, at: Position(x: 1, y: -1, z: 0)))
		XCTAssertEqual("bG1 wB1\\", state.previousMoves.last!.notation)
	}

	// MARK: - GameState.Option

	func testGameStateOptions_RestrictedOpenings_IsCorrect() {
		let openState = GameState(options: [])
		openState.apply(.place(unit: openState.whiteQueen, at: .origin))
		// Can place 5 pieces in 6 positions each
		XCTAssertEqual(30, openState.availableMoves.count)

		let restrictedState = GameState(options: [.restrictedOpening])
		restrictedState.apply(.place(unit: restrictedState.whiteQueen, at: .origin))
		// Can only place 5 pieces in 1 possible position
		XCTAssertEqual(5, restrictedState.availableMoves.count)
	}

	func testGameStateOptions_NoFirstQueenMove_IsCorrect() {
		let openState = GameState(options: [])
		XCTAssertEqual(0, openState.move)
		// White can play 5 pieces at origin
		XCTAssertEqual(5, openState.availableMoves.count)
		openState.apply(.place(unit: openState.whiteQueen, at: .origin))
		openState.apply(.place(unit: openState.blackQueen, at: Position(x: 0, y: 1, z: -1)))
		// Both moves were valid, move count increased
		XCTAssertEqual(2, openState.move)

		let restrictedState = GameState(options: [.noFirstMoveQueen])
		XCTAssertEqual(0, restrictedState.move)
		// White can play only 4 pieces at origin
		XCTAssertEqual(4, restrictedState.availableMoves.count)
		restrictedState.apply(.place(unit: restrictedState.whiteQueen, at: .origin))
		// Move was not valid, move count not incremented
		XCTAssertEqual(0, restrictedState.move)
		restrictedState.apply(.place(unit: restrictedState.whiteAnt, at: .origin))
		// Black can play 4 pieces, in 6 possible places
		XCTAssertEqual(24, restrictedState.availableMoves.count)
		XCTAssertEqual(1, restrictedState.move)
		restrictedState.apply(.place(unit: restrictedState.blackQueen, at: .origin))
		// Move was not valid, move count not incremented
		XCTAssertEqual(1, restrictedState.move)
	}

	func testGameStateOptions_CanSetModifiableOptions() {
		let state = GameState(options: [])

		for option in GameState.Option.allCases where option.isModifiable {
			XCTAssertTrue(state.set(option: option, to: true))
		}

		let expectedState = GameState(options: Set(GameState.Option.allCases.filter { $0.isModifiable }))
		XCTAssertEqual(expectedState, state)
	}

	func testGameStateOptions_CannotSetNonModifiableOptions() {
		let state = GameState(options: [])

		for option in GameState.Option.allCases where !option.isModifiable {
			XCTAssertFalse(state.set(option: option, to: true))
		}

		let expectedState = GameState(options: [])
		XCTAssertEqual(expectedState, state)
	}

	func testGameStateOptions_CannotSetOptions_AfterGameStarts() {
		let state = GameState(options: [])
		state.apply(.place(unit: state.whiteQueen, at: .origin))
		let expectedState = GameState(from: state)

		for option in GameState.Option.allCases {
			XCTAssertFalse(state.set(option: option, to: true))
		}

		XCTAssertEqual(expectedState, state)
	}

	// MARK: - Linux Tests

	static var allTests = [
		("testInitialGameState_IsFirstMove", testInitialGameState_IsFirstMove),
		("testInitialGameState_NoOptionsHasNoExtensionUnits", testInitialGameState_NoOptionsHasNoExtensionUnits),
		("testInitialGameState_LadyBugOptionAddsLadyBugUnit", testInitialGameState_LadyBugOptionAddsLadyBugUnit),
		("testInitialGameState_MosquitoOptionAddsMosquitoUnit", testInitialGameState_MosquitoOptionAddsMosquitoUnit),
		("testInitialGameState_PillBugOptionAddsPillBugUnit", testInitialGameState_PillBugOptionAddsPillBugUnit),
		("testInitialGameState_UnitsAreNotInPlay", testInitialGameState_UnitsAreNotInPlay),
		("testInitialGameState_PlayerHasAllUnitsAvailable", testInitialGameState_PlayerHasAllUnitsAvailable),
		("testInitialGameState_WhitePlayerIsFirst", testInitialGameState_WhitePlayerIsFirst),
		("testInitialGameState_HasNoWinner", testInitialGameState_HasNoWinner),
		("testInitialGameState_HasNoStacks", testInitialGameState_HasNoStacks),
		("testInitialGameState_HasNoLastPlayer", testInitialGameState_HasNoLastPlayer),
		("testInitialGameState_OnlyHasPlaceMovesAvailable", testInitialGameState_OnlyHasPlaceMovesAvailable),
		("testInitialGameState_OnlyLowestIndexUnitCanBePlayed", testInitialGameState_OnlyLowestIndexUnitCanBePlayed),
		("testInitialGameState_HasNoPreviousMoves", testInitialGameState_HasNoPreviousMoves),
		("testInitialGameState_ValidatesMoves", testInitialGameState_ValidatesMoves),
		("testInitialGameState_WithoutMoveValidation_AcceptsInvalidMoves", testInitialGameState_WithoutMoveValidation_AcceptsInvalidMoves),
		("testInitialGameState_UnitIndicesAreCorrect", testInitialGameState_UnitIndicesAreCorrect),

		("testPartialGameState_PreviousMove_IsCorrect", testPartialGameState_PreviousMove_IsCorrect),
		("testPartialGameState_LastPlayer_IsCorrect", testPartialGameState_LastPlayer_IsCorrect),
		("testPartialGameState_Move_IncrementsCorrectly", testPartialGameState_Move_IncrementsCorrectly),
		("testPartialGameState_MustPlayQueenInFirstFourMoves", testPartialGameState_MustPlayQueenInFirstFourMoves),
		("testPartialGameState_PlayableSpaces_AreCorrect", testPartialGameState_PlayableSpaces_AreCorrect),
		("testPartialGameState_IsNotEndGame", testPartialGameState_IsNotEndGame),
		("testPartialGameState_ApplyMovement_ValidMoveUpdatesState", testPartialGameState_ApplyMovement_ValidMoveUpdatesState),
		("testPartialGameState_ApplyMovement_InvalidMoveDoesNotModify", testPartialGameState_ApplyMovement_InvalidMoveDoesNotModify),
		("testPartialGameState_AvailablePieces_ExcludesPlayedPieces", testPartialGameState_AvailablePieces_ExcludesPlayedPieces),
		("testPartialGameState_AdjacentUnits_ToUnit_IsCorrect", testPartialGameState_AdjacentUnits_ToUnit_IsCorrect),
		("testPartialGameState_AdjacentUnits_ToPosition_IsCorrect", testPartialGameState_AdjacentUnits_ToPosition_IsCorrect),
		("testPartialGameState_OneHive_IsCorrect", testPartialGameState_OneHive_IsCorrect),
		("testPartialGameState_OneHive_ExcludingUnit_IsCorrect", testPartialGameState_OneHive_ExcludingUnit_IsCorrect),
		("testPartialGameState_PlayableSpacesForBlackPlayer_OnlyBesideBlackUnits", testPartialGameState_PlayableSpacesForBlackPlayer_OnlyBesideBlackUnits),
		("testPartialGameState_PlayableSpacesForBlackPlayerOnFirstMove_BesideWhiteUnits", testPartialGameState_PlayableSpacesForBlackPlayerOnFirstMove_BesideWhiteUnits),
		("testPartialGameState_ShutOutPlayer_HasOnlyPassMove", testPartialGameState_ShutOutPlayer_HasOnlyPassMove),
		("testPartialGameState_ApplyAndUndoPassMove", testPartialGameState_ApplyAndUndoPassMove),
		("testPartialGameState_PlayerHasAvailableMoves", testPartialGameState_PlayerHasAvailableMoves),

		("testPartialGameState_UndoPlace_CreatesOldGameState", testPartialGameState_UndoPlace_CreatesOldGameState),
		("testPartialGameState_UndoMove_CreatesOldGameState", testPartialGameState_UndoMove_CreatesOldGameState),
		("testPartialGameState_UndoYoink_CreatesOldGameState", testPartialGameState_UndoYoink_CreatesOldGameState),

		("testPartialGameState_CannotMoveUntilQueenPlaced", testPartialGameState_CannotMoveUntilQueenPlaced),
		("testPartialGameState_QueenPlayed_IsCorrect", testPartialGameState_QueenPlayed_IsCorrect),

		("testFinishedGameState_PlayerHasNoAvailableMoves", testFinishedGameState_PlayerHasNoAvailableMoves),
		("testFinishedGameState_HasOneWinner", testFinishedGameState_HasOneWinner),
		("testFinishedGameState_HasNoMoves", testFinishedGameState_HasNoMoves),
		("testFinishedGameState_IsEndGame", testFinishedGameState_IsEndGame),
		("testFinishedGameState_ApplyMovement_DoesNotModifyState", testFinishedGameState_ApplyMovement_DoesNotModifyState),

		("testTiedGameState_HasTwoWinners", testTiedGameState_HasTwoWinners),

		("testIdenticalGameStateHashesAreIdentical", testIdenticalGameStateHashesAreIdentical),
		("testCopyingGameState_IsCorrect", testCopyingGameState_IsCorrect),
		("testGameStateUpdate_Notation_IsCorrect", testGameStateUpdate_Notation_IsCorrect),

		("testGameStateOptions_RestrictedOpenings_IsCorrect", testGameStateOptions_RestrictedOpenings_IsCorrect),
		("testGameStateOptions_NoFirstQueenMove_IsCorrect", testGameStateOptions_NoFirstQueenMove_IsCorrect),
		("testGameStateOptions_CanSetModifiableOptions", testGameStateOptions_CanSetModifiableOptions),
		("testGameStateOptions_CannotSetNonModifiableOptions", testGameStateOptions_CannotSetNonModifiableOptions),
		("testGameStateOptions_CannotSetOptions_AfterGameStarts", testGameStateOptions_CannotSetOptions_AfterGameStarts),
	]
}
