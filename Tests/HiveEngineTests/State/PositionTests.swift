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

	func testWhenMovingAcross_EqualOnBothSides_FreedomOfMovement_IsFalse() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteSpider, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.place(unit: stateProvider.whiteAnt, at: Position.inPlay(x: 2, y: -1, z: -1))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let startPosition: Position = .inPlay(x: 2, y: 0, z: -2)
		let endPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		XCTAssertFalse(startPosition.freedomOfMovement(to: endPosition, in: state))
	}

	func testWhenMovingAcross__FreeOnOneSide_FreedomOfMovement_IsTrue() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteSpider, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2))
		]

		let state = stateProvider.gameState(from: setupMoves)
		let startPosition: Position = .inPlay(x: 2, y: 0, z: -2)
		let endPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		XCTAssertTrue(startPosition.freedomOfMovement(to: endPosition, in: state))
	}

	func testWhenMovingDown_HigherOnBothSides_FreedomOfMovement_IsFalse() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.move(unit: stateProvider.whiteBeetle, to: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackBeetle, at: Position.inPlay(x: 2, y: 1, z: -3)),
			Movement.place(unit: stateProvider.whiteAnt, at: Position.inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: stateProvider.blackBeetle, to: Position.inPlay(x: 1, y: 1, z: -2))
		]

		let state = stateProvider.gameState(from: setupMoves)
		let startPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let startHeight = 1
		let endPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let endHeight = 2
		XCTAssertFalse(startPosition.freedomOfMovement(to: endPosition, startingHeight: startHeight, endingHeight: endHeight, in: state))
	}

	func testWhenMovingDown_HigherOnOneSide_FreedomOfMovement_IsTrue() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.move(unit: stateProvider.whiteBeetle, to: Position.inPlay(x: 0, y: 0, z: 0))
		]

		let state = stateProvider.gameState(from: setupMoves)
		let startPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let startHeight = 2
		let endPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let endHeight = 1
		XCTAssertTrue(startPosition.freedomOfMovement(to: endPosition, startingHeight: startHeight, endingHeight: endHeight, in: state))
	}

	func testWhenMovingUp_HigherOnBothSides_FreedomOfMovement_IsFalse() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.move(unit: stateProvider.whiteBeetle, to: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackBeetle, at: Position.inPlay(x: 2, y: 1, z: -3)),
			Movement.place(unit: stateProvider.whiteAnt, at: Position.inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: stateProvider.blackBeetle, to: Position.inPlay(x: 1, y: 1, z: -2))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let startPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let startHeight = 1
		let endPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let endHeight = 2
		XCTAssertFalse(startPosition.freedomOfMovement(to: endPosition, startingHeight: startHeight, endingHeight: endHeight, in: state))
	}

	func testWhenMovingUp_HigherOnOneSide_FreedomOfMovement_IsTrue() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteBeetle, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackSpider, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.move(unit: stateProvider.whiteBeetle, to: Position.inPlay(x: 0, y: 0, z: 0))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let startPosition: Position = .inPlay(x: 1, y: 0, z: -1)
		let startHeight = 1
		let endPosition: Position = .inPlay(x: 0, y: 1, z: -1)
		let endHeight = 2
		XCTAssertTrue(startPosition.freedomOfMovement(to: endPosition, startingHeight: startHeight, endingHeight: endHeight, in: state))
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

		("testWhenMovingAcross_EqualOnBothSides_FreedomOfMovement_IsFalse", testWhenMovingAcross_EqualOnBothSides_FreedomOfMovement_IsFalse),
		("testWhenMovingAcross__FreeOnOneSide_FreedomOfMovement_IsTrue", testWhenMovingAcross__FreeOnOneSide_FreedomOfMovement_IsTrue),
		("testWhenMovingDown_HigherOnBothSides_FreedomOfMovement_IsFalse", testWhenMovingDown_HigherOnBothSides_FreedomOfMovement_IsFalse),
		("testWhenMovingDown_HigherOnOneSide_FreedomOfMovement_IsTrue", testWhenMovingDown_HigherOnOneSide_FreedomOfMovement_IsTrue),
		("testWhenMovingUp_HigherOnBothSides_FreedomOfMovement_IsFalse", testWhenMovingUp_HigherOnBothSides_FreedomOfMovement_IsFalse),
		("testWhenMovingUp_HigherOnOneSide_FreedomOfMovement_IsTrue", testWhenMovingUp_HigherOnOneSide_FreedomOfMovement_IsTrue)
	]
}
