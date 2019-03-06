//
//  PositionTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import XCTest
@testable import HiveEngine

final class PositionTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testAdjacentPositions_InPlay_IsCorrect() {
		let position: Position = .inPlay(x: 22, y: 11, z: -13)

		let expectedAdjacent: Set<Position> = [
			.inPlay(x: 21, y: 12, z: -13),
			.inPlay(x: 23, y: 10, z: -13),
			.inPlay(x: 21, y: 11, z: -12),
			.inPlay(x: 23, y: 11, z: -14),
			.inPlay(x: 22, y: 12, z: -14),
			.inPlay(x: 22, y: 10, z: -12)
		]

		XCTAssertEqual(expectedAdjacent, position.adjacent())
	}

	func testAdjacentPositions_InHand_IsEmpty() {
		let position: Position = .inHand
		XCTAssertTrue(position.adjacent().isEmpty)
	}

	func testAddingInHandToInPlay_IsUnchanged() {
		let position: Position = .inPlay(x: 22, y: 11, z: -13)
		let inHand: Position = .inHand

		XCTAssertEqual(position, position.adding(inHand))
	}

	func testAddingInHandToInHand_IsUnchanged() {
		let position: Position = .inHand
		let inHand: Position = .inHand

		XCTAssertEqual(position, position.adding(inHand))
	}

	func testAddingInPlayToInHand_IsInHand() {
		let position: Position = .inHand
		let inPlay: Position = .inPlay(x: 22, y: 11, z: -13)

		XCTAssertEqual(position, position.adding(inPlay))
	}

	func testAddingInPlayToInPlay_IsCorrect() {
		let position: Position = .inPlay(x: 4, y: -8, z: 2)
		let inPlay: Position = .inPlay(x: 22, y: 11, z: -13)
		let expectedPosition: Position = .inPlay(x: 26, y: 3, z: -11)

		XCTAssertEqual(expectedPosition, position.adding(inPlay))
	}

	func testSubtractingInHandFromInPlay_IsUnchanged() {
		let position: Position = .inPlay(x: 22, y: 11, z: -13)
		let inHand: Position = .inHand

		XCTAssertEqual(position, position.subtracting(inHand))
	}

	func testSubtractingInHandFromInHand_IsUnchanged() {
		let position: Position = .inHand
		let inHand: Position = .inHand

		XCTAssertEqual(position, position.subtracting(inHand))
	}

	func testSubtractingInPlayFromInHand_IsInHand() {
		let position: Position = .inHand
		let inPlay: Position = .inPlay(x: 22, y: 11, z: -13)

		XCTAssertEqual(position, position.subtracting(inPlay))
	}

	func testSubtractingInPlayFromInPlay_IsCorrect() {
		let position: Position = .inPlay(x: 4, y: -8, z: 2)
		let inPlay: Position = .inPlay(x: 22, y: 11, z: -13)
		let expectedPosition: Position = .inPlay(x: -18, y: -19, z: 15)

		XCTAssertEqual(expectedPosition, position.subtracting(inPlay))
	}

	func testCodingInPlayPosition() throws {
		let position: Position = .inPlay(x: 1, y: -1, z: 0)
		XCTAssertEncodable(position)
		XCTAssertDecodable(position)
	}

	func testCodingInHandPosition() throws {
		let position: Position = .inHand
		XCTAssertEncodable(position)
		XCTAssertDecodable(position)
	}

	// MARK: Moving across 1 to 1

	func testWhenMovingAcrossYAxis_EqualOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteSpider, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 2, y: -1, z: -1))
			]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 2, y: 0, z: -2)
		let secondPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossYAxis_FreeOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteSpider, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 2, y: 0, z: -2)
		let secondPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossZAxis_EqualOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteSpider, at: Position.inPlay(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: -1, y: 2, z: -1)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: -2, y: 1, z: 1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: -2, y: 2, z: 0)
		let secondPosition: Position = .inPlay(x: -1, y: 1, z: 0)
		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossZAxis_FreeOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteSpider, at: Position.inPlay(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: -1, y: 2, z: -1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: -2, y: 2, z: 0)
		let secondPosition: Position = .inPlay(x: -1, y: 1, z: 0)
		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossXAxis_EqualOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.whiteSpider, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: -1, y: -1, z: 2)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 1, y: -2, z: 1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: -1, z: 1)
		let secondPosition: Position = .inPlay(x: 0, y: -2, z: 2)
		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossXAxis_FreeOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.whiteSpider, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: -1, y: -1, z: 2))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: -1, z: 1)
		let secondPosition: Position = .inPlay(x: 0, y: -2, z: 2)
		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	// MARK: - Moving up 1 to 2 or down 2 to 1

	// MARK: Z Axis

	func testWhenMovingAcrossZAxis_HigherYHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whiteBeetle, to: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: 2, y: 1, z: -3)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: 1, y: 1, z: -2))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testWhenMovingAcrossZAxis_HigherYHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whiteBeetle, to: Position.inPlay(x: 0, y: 0, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testWhenMovingAcrossZAxis_LowerYHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whiteBeetle, to: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: 2, y: 1, z: -3)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: 1, y: 1, z: -2))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let firstPositionHeight = 1
		let secondPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let secondPositionHeight = 2

		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testWhenMovingAcrossZAxis_LowerYHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whiteBeetle, to: Position.inPlay(x: 0, y: 0, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let firstPositionHeight = 1
		let secondPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let secondPositionHeight = 2

		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	// MARK: Y Axis

	func testWhenMovingAcrossYAxis_LowerXHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: 2, y: -2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.move(unit: state.whiteBeetle, to: Position.inPlay(x: 1, y: -1, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 0, z: 0)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testWhenMovingAcrossYAxis_LowerXHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: 2, y: -2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: 0, y: 1, z: -1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 0, z: 0)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testWhenMovingAcrossYAxis_HigherXHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: -1, z: 1)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: -1, y: -1, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: -2, y: 2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.whiteBeetle, to: Position.inPlay(x: -1, y: 1, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 0, z: 0)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: -1, y: 0, z: 1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testWhenMovingAcrossYAxis_HigherXHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: 0, y: -1, z: 1)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: -1, y: -1, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: -2, y: 2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: 0, y: -1, z: 1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 0, z: 0)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: -1, y: 0, z: 1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	// MARK: X Axis

	func testWhenMovingAcrossXAxis_LowerYHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: -2, y: 2, z: 0)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: 2, y: 0, z: -2)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: -1, y: 1, z: 0)),
			Movement.move(unit: state.whiteBeetle, to: Position.inPlay(x: 1, y: 0, z: -1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 0, z: 0)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testWhenMovingAcrossXAxis_LowerYHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: -2, y: 2, z: 0)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: 2, y: 0, z: -2)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: -1, y: 1, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 0, z: 0)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testWhenMovingAcrossXAxis_HigherYHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: -2, y: 0, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: 2, y: -2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: -1, y: 0, z: 1)),
			Movement.move(unit: state.whiteBeetle, to: Position.inPlay(x: 1, y: -1, z: 0))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 0, z: 0)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: 0, y: -1, z: 1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testWhenMovingAcrossXAxis_HigherYHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: state.blackQueen, at: Position.inPlay(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.whiteAnt, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position.inPlay(x: -2, y: 0, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position.inPlay(x: 2, y: -2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position.inPlay(x: -1, y: 0, z: 1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .inPlay(x: 0, y: 0, z: 0)
		let firstPositionHeight = 2
		let secondPosition: Position = .inPlay(x: 0, y: -1, z: 1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, startingHeight: firstPositionHeight, endingHeight: secondPositionHeight, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, startingHeight: secondPositionHeight, endingHeight: firstPositionHeight, in: state))
	}

	func testInHandDescription_IsCorrect() {
		let position: Position = .inHand
		XCTAssertEqual("In Hand", position.description)
	}

	func testInPlayDescription_IsCorrect() {
		let position: Position = .inPlay(x: 0, y: 1, z: -1)
		XCTAssertEqual("(0, 1, -1)", position.description)
	}

	static var allTests = [
		("testAdjacentPositions_InPlay_IsCorrect", testAdjacentPositions_InPlay_IsCorrect),
		("testAdjacentPositions_InHand_IsEmpty", testAdjacentPositions_InHand_IsEmpty),

		("testAddingInHandToInPlay_IsUnchanged", testAddingInHandToInPlay_IsUnchanged),
		("testAddingInHandToInHand_IsUnchanged", testAddingInHandToInHand_IsUnchanged),
		("testAddingInPlayToInHand_IsInHand", testAddingInPlayToInHand_IsInHand),
		("testAddingInPlayToInPlay_IsCorrect", testAddingInPlayToInPlay_IsCorrect),

		("testSubtractingInHandFromInPlay_IsUnchanged", testSubtractingInHandFromInPlay_IsUnchanged),
		("testSubtractingInHandFromInHand_IsUnchanged", testSubtractingInHandFromInHand_IsUnchanged),
		("testSubtractingInPlayFromInHand_IsInHand", testSubtractingInPlayFromInHand_IsInHand),
		("testSubtractingInPlayFromInPlay_IsCorrect", testSubtractingInPlayFromInPlay_IsCorrect),

		("testCodingInPlayPosition", testCodingInPlayPosition),
		("testCodingInHandPosition", testCodingInHandPosition),

		("testWhenMovingAcrossYAxis_EqualOnBothSides_NoFreedomOfMovement", testWhenMovingAcrossYAxis_EqualOnBothSides_NoFreedomOfMovement),
		("testWhenMovingAcrossYAxis_FreeOnOneSide_FreedomOfMovement", testWhenMovingAcrossYAxis_FreeOnOneSide_FreedomOfMovement),
		("testWhenMovingAcrossZAxis_EqualOnBothSides_NoFreedomOfMovement", testWhenMovingAcrossZAxis_EqualOnBothSides_NoFreedomOfMovement),
		("testWhenMovingAcrossZAxis_FreeOnOneSide_FreedomOfMovement", testWhenMovingAcrossZAxis_FreeOnOneSide_FreedomOfMovement),
		("testWhenMovingAcrossXAxis_EqualOnBothSides_NoFreedomOfMovement", testWhenMovingAcrossXAxis_EqualOnBothSides_NoFreedomOfMovement),
		("testWhenMovingAcrossXAxis_FreeOnOneSide_FreedomOfMovement", testWhenMovingAcrossXAxis_FreeOnOneSide_FreedomOfMovement),

		("testWhenMovingAcrossZAxis_HigherYHigherHeight_HigherOnBothSides_NoFreedomOfMovement", testWhenMovingAcrossZAxis_HigherYHigherHeight_HigherOnBothSides_NoFreedomOfMovement),
		("testWhenMovingAcrossZAxis_HigherYHigherHeight_HigherOnOneSide_FreedomOfMovement", testWhenMovingAcrossZAxis_HigherYHigherHeight_HigherOnOneSide_FreedomOfMovement),
		("testWhenMovingAcrossZAxis_LowerYHigherHeight_HigherOnBothSides_NoFreedomOfMovement", testWhenMovingAcrossZAxis_LowerYHigherHeight_HigherOnBothSides_NoFreedomOfMovement),
		("testWhenMovingAcrossZAxis_LowerYHigherHeight_HigherOnOneSide_FreedomOfMovement", testWhenMovingAcrossZAxis_LowerYHigherHeight_HigherOnOneSide_FreedomOfMovement),

		("testWhenMovingAcrossYAxis_LowerXHigherHeight_HigherOnBothSides_NoFreedomOfMovement", testWhenMovingAcrossYAxis_LowerXHigherHeight_HigherOnBothSides_NoFreedomOfMovement),
		("testWhenMovingAcrossYAxis_LowerXHigherHeight_HigherOnOneSide_FreedomOfMovement", testWhenMovingAcrossYAxis_LowerXHigherHeight_HigherOnOneSide_FreedomOfMovement),
		("testWhenMovingAcrossYAxis_HigherXHigherHeight_HigherOnBothSides_NoFreedomOfMovement", testWhenMovingAcrossYAxis_HigherXHigherHeight_HigherOnBothSides_NoFreedomOfMovement),
		("testWhenMovingAcrossYAxis_HigherXHigherHeight_HigherOnOneSide_FreedomOfMovement", testWhenMovingAcrossYAxis_HigherXHigherHeight_HigherOnOneSide_FreedomOfMovement),

		("testWhenMovingAcrossXAxis_LowerYHigherHeight_HigherOnBothSides_NoFreedomOfMovement", testWhenMovingAcrossXAxis_LowerYHigherHeight_HigherOnBothSides_NoFreedomOfMovement),
		("testWhenMovingAcrossXAxis_LowerYHigherHeight_HigherOnOneSide_FreedomOfMovement", testWhenMovingAcrossXAxis_LowerYHigherHeight_HigherOnOneSide_FreedomOfMovement),
		("testWhenMovingAcrossXAxis_HigherYHigherHeight_HigherOnBothSides_NoFreedomOfMovement", testWhenMovingAcrossXAxis_HigherYHigherHeight_HigherOnBothSides_NoFreedomOfMovement),
		("testWhenMovingAcrossXAxis_HigherYHigherHeight_HigherOnOneSide_FreedomOfMovement", testWhenMovingAcrossXAxis_HigherYHigherHeight_HigherOnOneSide_FreedomOfMovement),

		("testInHandDescription_IsCorrect", testInHandDescription_IsCorrect),
		("testInPlayDescription_IsCorrect", testInPlayDescription_IsCorrect)
	]
}
