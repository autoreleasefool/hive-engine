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

	func testAdjacentPositions_IsCorrect() {
		let position: Position = Position(x: 22, y: 11, z: -13)

		let expectedAdjacent = [
			Position(x: 22, y: 12, z: -14),
			Position(x: 23, y: 11, z: -14),
			Position(x: 23, y: 10, z: -13),
			Position(x: 22, y: 10, z: -12),
			Position(x: 21, y: 11, z: -12),
			Position(x: 21, y: 12, z: -13),
		]

		XCTAssertEqual(expectedAdjacent, position.adjacent())
	}

	func testAddingPositionToPosition_IsCorrect() {
		let position: Position = Position(x: 4, y: -8, z: 2)
		let otherPosition: Position = Position(x: 22, y: 11, z: -13)
		let expectedPosition: Position = Position(x: 26, y: 3, z: -11)

		XCTAssertEqual(expectedPosition, position.adding(otherPosition))
	}

	func testSubtractingPositionFromPosition_IsCorrect() {
		let position: Position = Position(x: 4, y: -8, z: 2)
		let otherPosition: Position = Position(x: 22, y: 11, z: -13)
		let expectedPosition: Position = Position(x: -18, y: -19, z: 15)

		XCTAssertEqual(expectedPosition, position.subtracting(otherPosition))
	}

	func testCommonPositionsBetweenAdjacentPositions() {
		let position: Position = .origin
		let otherPosition: Position = Position(x: 0, y: 1, z: -1)
		let expectedCommonPositions = (Position(x: 1, y: 0, z: -1), Position(x: -1, y: 1, z: 0))

		guard let commonPositions = position.commonPositions(to: otherPosition) else {
			XCTFail("commonPositions was nil")
			return
		}
		XCTAssertEqual(expectedCommonPositions.0, commonPositions.0)
		XCTAssertEqual(expectedCommonPositions.1, commonPositions.1)
	}

	func testCommonPositionsBetweenNonAdjacentPositions() {
		let position: Position = .origin
		let otherPosition: Position = Position(x: 2, y: 0, z: -2)
		XCTAssertNil(position.commonPositions(to: otherPosition))
	}

	func testCommonPositionsBetweenInvalidPositions() {
		let position: Position = .origin
		let otherPosition: Position = Position(x: 1, y: 1, z: 1)
		XCTAssertNil(position.commonPositions(to: otherPosition))
	}

	// MARK: - Freedom of movement

	func testNonAdjacentFreedomOfMovement_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteSpider, at: Position(x: 0, y: -1, z: 1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: 0, y: 1, z: -1)
		let secondPosition: Position = Position(x: 0, y: -1, z: 1)
		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testFreedomOfMovement_BetweenIdenticalPositions_IsFalse() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .origin
		let secondPosition: Position = .origin
		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	// MARK: Moving across 1 to 1

	func testWhenMovingAcrossYAxis_EqualOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteSpider, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 2, y: -1, z: -1)),
			]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: 2, y: 0, z: -2)
		let secondPosition: Position = Position(x: 1, y: 0, z: -1)
		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossYAxis_FreeOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteSpider, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: 1, y: 1, z: -2)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: 2, y: 0, z: -2)
		let secondPosition: Position = Position(x: 1, y: 0, z: -1)
		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossZAxis_EqualOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteSpider, at: Position(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.blackSpider, at: Position(x: -1, y: 2, z: -1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: -2, y: 1, z: 1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: -2, y: 2, z: 0)
		let secondPosition: Position = Position(x: -1, y: 1, z: 0)
		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossZAxis_FreeOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteSpider, at: Position(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.blackSpider, at: Position(x: -1, y: 2, z: -1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: -2, y: 2, z: 0)
		let secondPosition: Position = Position(x: -1, y: 1, z: 0)
		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossXAxis_EqualOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.whiteSpider, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: -1, y: -1, z: 2)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 1, y: -2, z: 1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: 0, y: -1, z: 1)
		let secondPosition: Position = Position(x: 0, y: -2, z: 2)
		XCTAssertFalse(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertFalse(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	func testWhenMovingAcrossXAxis_FreeOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.whiteSpider, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: -1, y: -1, z: 2)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: 0, y: -1, z: 1)
		let secondPosition: Position = Position(x: 0, y: -2, z: 2)
		XCTAssertTrue(firstPosition.freedomOfMovement(to: secondPosition, in: state))
		XCTAssertTrue(secondPosition.freedomOfMovement(to: firstPosition, in: state))
	}

	// MARK: Moving up 1 to 2 or down 2 to 1

	// MARK: Z Axis

	func testWhenMovingAcrossZAxis_HigherYHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whiteBeetle, to: .origin),
			Movement.place(unit: state.blackBeetle, at: Position(x: 2, y: 1, z: -3)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.blackBeetle, to: Position(x: 1, y: 1, z: -2)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: 0, y: 1, z: -1)
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: 1, y: 0, z: -1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertFalse(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	func testWhenMovingAcrossZAxis_HigherYHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whiteBeetle, to: .origin),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: 0, y: 1, z: -1)
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: 1, y: 0, z: -1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertTrue(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	func testWhenMovingAcrossZAxis_LowerYHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whiteBeetle, to: .origin),
			Movement.place(unit: state.blackBeetle, at: Position(x: 2, y: 1, z: -3)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.blackBeetle, to: Position(x: 1, y: 1, z: -2)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: 0, y: 1, z: -1)
		let firstPositionHeight = 1
		let secondPosition: Position = Position(x: 1, y: 0, z: -1)
		let secondPositionHeight = 2

		XCTAssertFalse(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertFalse(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	func testWhenMovingAcrossZAxis_LowerYHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.blackSpider, at: Position(x: 1, y: 1, z: -2)),
			Movement.move(unit: state.whiteBeetle, to: .origin),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = Position(x: 0, y: 1, z: -1)
		let firstPositionHeight = 1
		let secondPosition: Position = Position(x: 1, y: 0, z: -1)
		let secondPositionHeight = 2

		XCTAssertTrue(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertTrue(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	// MARK: Y Axis

	func testWhenMovingAcrossYAxis_LowerXHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 2, y: -2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position(x: 0, y: 1, z: -1)),
			Movement.move(unit: state.whiteBeetle, to: Position(x: 1, y: -1, z: 0)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .origin
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: 1, y: 0, z: -1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertFalse(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	func testWhenMovingAcrossYAxis_LowerXHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 2, y: -2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position(x: 0, y: 1, z: -1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .origin
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: 1, y: 0, z: -1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertTrue(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	func testWhenMovingAcrossYAxis_HigherXHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: -1, z: 1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position(x: -1, y: -1, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: -2, y: 2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position(x: 0, y: -1, z: 1)),
			Movement.move(unit: state.whiteBeetle, to: Position(x: -1, y: 1, z: 0)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .origin
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: -1, y: 0, z: 1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertFalse(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	func testWhenMovingAcrossYAxis_HigherXHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: -1, z: 1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position(x: -1, y: -1, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: -2, y: 2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position(x: 0, y: -1, z: 1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .origin
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: -1, y: 0, z: 1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertTrue(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	// MARK: X Axis

	func testWhenMovingAcrossXAxis_LowerYHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackBeetle, at: Position(x: -2, y: 2, z: 0)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 2, y: 0, z: -2)),
			Movement.move(unit: state.blackBeetle, to: Position(x: -1, y: 1, z: 0)),
			Movement.move(unit: state.whiteBeetle, to: Position(x: 1, y: 0, z: -1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .origin
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: 0, y: 1, z: -1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertFalse(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	func testWhenMovingAcrossXAxis_LowerYHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: -1, y: 1, z: 0)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 1, y: 0, z: -1)),
			Movement.place(unit: state.blackBeetle, at: Position(x: -2, y: 2, z: 0)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 2, y: 0, z: -2)),
			Movement.move(unit: state.blackBeetle, to: Position(x: -1, y: 1, z: 0)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .origin
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: 0, y: 1, z: -1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertTrue(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	func testWhenMovingAcrossXAxis_HigherYHigherHeight_HigherOnBothSides_NoFreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position(x: -2, y: 0, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 2, y: -2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position(x: -1, y: 0, z: 1)),
			Movement.move(unit: state.whiteBeetle, to: Position(x: 1, y: -1, z: 0)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .origin
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: 0, y: -1, z: 1)
		let secondPositionHeight = 1

		XCTAssertFalse(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertFalse(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	func testWhenMovingAcrossXAxis_HigherYHigherHeight_HigherOnOneSide_FreedomOfMovement() {
		let state = stateProvider.initialGameState
		state.internalOptions.insert(.unrestrictOpening)
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: -1, y: 0, z: 1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackBeetle, at: Position(x: -2, y: 0, z: 2)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 2, y: -2, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position(x: -1, y: 0, z: 1)),
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let firstPosition: Position = .origin
		let firstPositionHeight = 2
		let secondPosition: Position = Position(x: 0, y: -1, z: 1)
		let secondPositionHeight = 1

		XCTAssertTrue(firstPosition.freedomOfMovement(
			to: secondPosition,
			startingHeight: firstPositionHeight,
			endingHeight: secondPositionHeight,
			in: state
		))
		XCTAssertTrue(secondPosition.freedomOfMovement(
			to: firstPosition,
			startingHeight: secondPositionHeight,
			endingHeight: firstPositionHeight,
			in: state
		))
	}

	// MARK: - Extensions

	func testPositionComparable_IsCorrect() {
		XCTAssertTrue(.origin < Position(x: 0, y: 0, z: 1))
		XCTAssertTrue(.origin < Position(x: 0, y: 1, z: 0))
		XCTAssertTrue(.origin < Position(x: 1, y: 0, z: 0))
	}

	func testPositionDescription_IsCorrect() {
		let position: Position = Position(x: 0, y: 1, z: -1)
		XCTAssertEqual("(0, 1, -1)", position.description)
	}
}
