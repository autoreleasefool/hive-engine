//
//  RelativeMovementTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-05-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import XCTest
import HiveEngine

final class RelativeMovementTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testRelativeMovementDescription_IsCorrect() {
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let adjacentUnit = Unit(class: .queen, owner: .black, index: 0)
		let direction: Direction = .northWest

		let movement = RelativeMovement(unit: unit, adjacentTo: (adjacentUnit, direction))
		XCTAssertEqual("Move White Ant (0) North West of Black Queen (0)", movement.description)

		let movementWithoutAdjacent = RelativeMovement(unit: unit, adjacentTo: nil)
		XCTAssertEqual("Place White Ant (0) at origin", movementWithoutAdjacent.description)
	}

	func testRelativeMovementToMovement_WhenPlaced_IsCorrect() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
		]
		stateProvider.apply(moves: setupMoves, to: state)

		let unit = Unit(class: .ant, owner: .black, index: 1)
		let adjacentUnit = Unit(class: .queen, owner: .white, index: 1)
		let direction: Direction = .northWest

		let relativeMovement = RelativeMovement(unit: unit, adjacentTo: (adjacentUnit, direction))
		let movement = relativeMovement.movement(in: state)

		XCTAssertEqual(.place(unit: state.blackAnt, at: Position(x: -1, y: 1, z: 0)), movement)
	}

	func testRelativeMovementToMovement_WhenMoved_IsCorrect() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackAnt, at: Position(x: 0, y: 1, z: -1)),
		]
		stateProvider.apply(moves: setupMoves, to: state)

		let unit = Unit(class: .queen, owner: .white, index: 1)
		let adjacentUnit = Unit(class: .ant, owner: .black, index: 1)
		let direction: Direction = .southEast

		let relativeMovement = RelativeMovement(unit: unit, adjacentTo: (adjacentUnit, direction))
		let movement = relativeMovement.movement(in: state)

		XCTAssertEqual(.move(unit: state.whiteQueen, to: Position(x: 1, y: 0, z: -1)), movement)
	}

	func testRelativeMovementNotation_ParsesOriginPlacementCorrectly() {
		let expected = RelativeMovement(unit: Unit(class: .ant, owner: .white, index: 1), adjacentTo: nil)
		XCTAssertEqual(expected, RelativeMovement(notation: "wA1"))
	}

	func testRelativeMovementNotation_ParsingRequiresIndex() {
		XCTAssertEqual(nil, RelativeMovement(notation: "wA"))
	}

	func testRelativeMovementNotation_ParsingQueenDoesntRequireIndex() {
		let expected = RelativeMovement(unit: Unit(class: .queen, owner: .black, index: 1), adjacentTo: nil)
		XCTAssertEqual(expected, RelativeMovement(notation: "bQ"))
	}

	func testRelativeMovementNotation_ParsesAdjacentUnit() {
		let expected = RelativeMovement(
			unit: Unit(class: .queen, owner: .black, index: 1),
			adjacentTo: (Unit(class: .ant, owner: .white, index: 2), .southEast)
		)
		XCTAssertEqual(expected, RelativeMovement(notation: "bQ1 wA2-"))
	}

	func testRelativeMovementNotation_ParsesNotationToOriginal() {
		let state = GameState(options: [.ladyBug, .mosquito, .pillBug])

		let allUnits = state.unitsInHand[.white]!.union( state.unitsInHand[.black]!)
		allUnits.forEach { unit in
			let movement = RelativeMovement(unit: unit, adjacentTo: nil)
			XCTAssertEqual(movement, RelativeMovement(notation: movement.notation))
		}
		zip(allUnits, allUnits).forEach { (unit, adjacentUnit) in
			Direction.allCases.forEach { direction in
				let movement = RelativeMovement(unit: unit, adjacentTo: (adjacentUnit, direction))
				XCTAssertEqual(movement, RelativeMovement(notation: movement.notation))
			}
		}
	}

	static var allTests = [
		("testRelativeMovementDescription_IsCorrect", testRelativeMovementDescription_IsCorrect),
		("testRelativeMovementToMovement_WhenPlaced_IsCorrect", testRelativeMovementToMovement_WhenPlaced_IsCorrect),
		("testRelativeMovementToMovement_WhenMoved_IsCorrect", testRelativeMovementToMovement_WhenMoved_IsCorrect),
		("testRelativeMovementNotation_ParsesOriginPlacementCorrectly",
			testRelativeMovementNotation_ParsesOriginPlacementCorrectly),
		("testRelativeMovementNotation_ParsingRequiresIndex", testRelativeMovementNotation_ParsingRequiresIndex),
		("testRelativeMovementNotation_ParsingQueenDoesntRequireIndex",
			testRelativeMovementNotation_ParsingQueenDoesntRequireIndex),
		("testRelativeMovementNotation_ParsesAdjacentUnit", testRelativeMovementNotation_ParsesAdjacentUnit),
		("testRelativeMovementNotation_ParsesNotationToOriginal", testRelativeMovementNotation_ParsesNotationToOriginal),
	]
}
