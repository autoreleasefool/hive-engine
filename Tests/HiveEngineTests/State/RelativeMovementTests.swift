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

	func testRelativeMovementDescription_IsCorrect() {
		let unit = Unit(class: .ant, owner: .white, index: 0)
		let adjacentUnit = Unit(class: .queen, owner: .black, index: 0)
		let direction = Direction.northWest

		let movement = RelativeMovement(unit: unit, adjacentTo: (adjacentUnit, direction))
		XCTAssertEqual("Move White Ant (0) North West of Black Queen (0)", movement.description)

		let movementWithoutAdjacent = RelativeMovement(unit: unit, adjacentTo: nil)
		XCTAssertEqual("Place White Ant (0) at origin", movementWithoutAdjacent.description)
	}

	static var allTests = [
		("testRelativeMovementDescription_IsCorrect", testRelativeMovementDescription_IsCorrect)
	]
}