//
//  MovementTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import XCTest
@testable import HiveEngine

final class MovementTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testCodingMoveMovement() {
		let unit = stateProvider.initialGameState.whiteAnt
		let position: Position = .inPlay(x: 1, y: -1, z: 0)
		let movement: Movement = .move(unit: unit, to: position)
		XCTAssertEncodable(movement)
		XCTAssertDecodable(movement)
	}

	func testCodingYoinkMovement() throws {
		let pillBug = stateProvider.initialGameState.whitePillBug
		let unit = stateProvider.initialGameState.whiteAnt
		let position: Position = .inPlay(x: 1, y: -1, z: 0)
		let movement: Movement = .yoink(pillBug: pillBug, unit: unit, to: position)
		XCTAssertEncodable(movement)
		XCTAssertDecodable(movement)
	}

	func testCodingPlaceMovement() throws {
		let unit = stateProvider.initialGameState.whiteAnt
		let position: Position = .inPlay(x: 1, y: -1, z: 0)
		let movement: Movement = .place(unit: unit, at: position)
		XCTAssertEncodable(movement)
		XCTAssertDecodable(movement)
	}

	func testMovedUnit_IsCorrect() {
		let unit = stateProvider.initialGameState.whiteAnt
		let position: Position = .inPlay(x: 1, y: -1, z: 0)

		var movement: Movement = .place(unit: unit, at: position)
		XCTAssertEqual(unit, movement.movedUnit)

		movement = .move(unit: unit, to: position)
		XCTAssertEqual(unit, movement.movedUnit)

		movement = .yoink(pillBug: unit, unit: unit, to: position)
		XCTAssertEqual(unit, movement.movedUnit)
	}

	func testTargetPosition_IsCorrect() {
		let unit = stateProvider.initialGameState.whiteAnt
		let position: Position = .inPlay(x: 1, y: -1, z: 0)

		var movement: Movement = .place(unit: unit, at: position)
		XCTAssertEqual(position, movement.targetPosition)

		movement = .move(unit: unit, to: position)
		XCTAssertEqual(position, movement.targetPosition)

		movement = .yoink(pillBug: unit, unit: unit, to: position)
		XCTAssertEqual(position, movement.targetPosition)
	}

	static var allTests = [
		("testCodingMoveMovement", testCodingMoveMovement),
		("testCodingYoinkMovement", testCodingYoinkMovement),
		("testCodingPlaceMovement", testCodingPlaceMovement),
		("testMovedUnit_IsCorrect", testMovedUnit_IsCorrect),
		("testTargetPosition_IsCorrect", testTargetPosition_IsCorrect)
	]
}
