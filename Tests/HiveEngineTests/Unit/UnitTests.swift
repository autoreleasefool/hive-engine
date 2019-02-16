//
//  UnitTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-16.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
@testable import HiveEngine

final class UnitTests: HiveEngineTestCase {

	func testGetMovementToPositionInPlay_IsCorrect() {
		let unit = Unit(class: .ant, owner: .white, identifier: UUID(uuidString: "AACA052C-280E-4925-8488-518770A2A912")!)
		let position: Position = .inPlay(x: 0, y: 2, z: -2)
		let expectedMovement: Movement = .move(unit: unit, to: position)

		XCTAssertEqual(expectedMovement, unit.movement(to: position))
	}

	func testGetMovementToPositionInHand_IsNil() {
		let unit = Unit(class: .ant, owner: .white, identifier: UUID(uuidString: "AACA052C-280E-4925-8488-518770A2A912")!)
		let position: Position = .inHand

		XCTAssertNil(unit.movement(to: position))
	}

	static var allTests = [
		("testGetMovementToPositionInPlay_IsCorrect", testGetMovementToPositionInPlay_IsCorrect),
		("testGetMovementToPositionInHand_IsNil", testGetMovementToPositionInHand_IsNil)
	]
}
