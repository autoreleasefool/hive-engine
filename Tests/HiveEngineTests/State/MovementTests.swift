//
//  MovementTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import XCTest
import HiveEngine

final class MovementTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testCodingMoveMovement() {
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let position: Position = Position(x: 1, y: -1, z: 0)
		let movement: Movement = .move(unit: unit, to: position)
		XCTAssertEncodable(movement)
		XCTAssertDecodable(movement)
	}

	func testCodingYoinkMovement() throws {
		let pillBug = Unit(class: .pillBug, owner: .black, index: 0)
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let position: Position = Position(x: 1, y: -1, z: 0)
		let movement: Movement = .yoink(pillBug: pillBug, unit: unit, to: position)
		XCTAssertEncodable(movement)
		XCTAssertDecodable(movement)
	}

	func testCodingPlaceMovement() throws {
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let position: Position = Position(x: 1, y: -1, z: 0)
		let movement: Movement = .place(unit: unit, at: position)
		XCTAssertEncodable(movement)
		XCTAssertDecodable(movement)
	}

	func testCodingPassMovement() throws {
		let movement: Movement = .pass
		XCTAssertEncodable(movement)
		XCTAssertDecodable(movement)
	}

	func testMovedUnit_IsCorrect() {
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let position: Position = Position(x: 1, y: -1, z: 0)

		var movement: Movement = .place(unit: unit, at: position)
		XCTAssertEqual(unit, movement.movedUnit)

		movement = .move(unit: unit, to: position)
		XCTAssertEqual(unit, movement.movedUnit)

		movement = .yoink(pillBug: unit, unit: unit, to: position)
		XCTAssertEqual(unit, movement.movedUnit)

		movement = .pass
		XCTAssertNil(movement.movedUnit)
	}

	func testTargetPosition_IsCorrect() {
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let position: Position = Position(x: 1, y: -1, z: 0)

		var movement: Movement = .place(unit: unit, at: position)
		XCTAssertEqual(position, movement.targetPosition)

		movement = .move(unit: unit, to: position)
		XCTAssertEqual(position, movement.targetPosition)

		movement = .yoink(pillBug: unit, unit: unit, to: position)
		XCTAssertEqual(position, movement.targetPosition)

		movement = .pass
		XCTAssertNil(movement.targetPosition)
	}

	func testPlaceDescription_IsCorrect() {
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let position: Position = Position(x: 1, y: -1, z: 0)
		let movement: Movement = .place(unit: unit, at: position)

		XCTAssertEqual("Place White Ant (0) at (1, -1, 0)", movement.description)
	}

	func testMoveDescription_IsCorrect() {
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let position: Position = Position(x: 1, y: -1, z: 0)
		let movement: Movement = .move(unit: unit, to: position)

		XCTAssertEqual("Move White Ant (0) to (1, -1, 0)", movement.description)
	}

	func testYoinkDescription_IsCorrect() {
		let pillBug = Unit(class: .pillBug, owner: .black, index: 0)
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let position: Position = Position(x: 1, y: -1, z: 0)
		let movement: Movement = .yoink(pillBug: pillBug, unit: unit, to: position)

		XCTAssertEqual("Yoink White Ant (0) to (1, -1, 0)", movement.description)
	}

	func testPassDescription_IsCorrect() {
		let movement: Movement = .pass
		XCTAssertEqual("Pass", movement.description)
	}

	func testMovementToRelativeMovement_WhenPlaced_IsCorrect() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
		]

		stateProvider.apply(moves: setupMoves, to: state)

		let movement: Movement = .place(unit: state.blackAnt, at: Position(x: -1, y: 1, z: 0))

		let unit = Unit(class: .ant, owner: .black, index: 1)
		let adjacentUnit = Unit(class: .queen, owner: .white, index: 1)
		let direction: Direction = .northWest

		let relativeMovement = movement.relative(in: state)
		XCTAssertEqual(RelativeMovement(unit: unit, adjacentTo: (adjacentUnit, direction)), relativeMovement)
	}

	func testMovementToRelativeMovement_WhenMoved_IsCorrect() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackAnt, at: Position(x: -1, y: 1, z: 0)),
		]

		stateProvider.apply(moves: setupMoves, to: state)

		let movement: Movement = .move(unit: state.whiteQueen, to: Position(x: -1, y: 0, z: 1))

		let unit = Unit(class: .queen, owner: .white, index: 1)
		let adjacentUnit = Unit(class: .ant, owner: .black, index: 1)
		let direction: Direction = .south

		let relativeMovement = movement.relative(in: state)
		XCTAssertEqual(RelativeMovement(unit: unit, adjacentTo: (adjacentUnit, direction)), relativeMovement)
	}

	static var allTests = [
		("testCodingMoveMovement", testCodingMoveMovement),
		("testCodingYoinkMovement", testCodingYoinkMovement),
		("testCodingPlaceMovement", testCodingPlaceMovement),
		("testCodingPassMovement", testCodingPassMovement),
		("testMovedUnit_IsCorrect", testMovedUnit_IsCorrect),
		("testTargetPosition_IsCorrect", testTargetPosition_IsCorrect),

		("testPlaceDescription_IsCorrect", testPlaceDescription_IsCorrect),
		("testMoveDescription_IsCorrect", testMoveDescription_IsCorrect),
		("testYoinkDescription_IsCorrect", testYoinkDescription_IsCorrect),
		("testPassDescription_IsCorrect", testPassDescription_IsCorrect),

		("testMovementToRelativeMovement_WhenPlaced_IsCorrect", testMovementToRelativeMovement_WhenPlaced_IsCorrect),
		("testMovementToRelativeMovement_WhenMoved_IsCorrect", testMovementToRelativeMovement_WhenMoved_IsCorrect),
	]
}
