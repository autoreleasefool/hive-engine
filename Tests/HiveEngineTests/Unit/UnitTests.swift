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

	func testWhenSurrounded_IsSurrounded_IsTrue() {
		XCTFail("Not implemented")
	}

	func testWhenNotSurrounded_IsSurrounded_IsFalse() {
		XCTFail("Not implemented")
	}

	func testWhenTopOfStack_IsTopOfStack_IsTrue() {
		XCTFail("Not implemented")
	}

	func testWhenBottomOfStack_IsTopOfStack_IsFalse() {
		XCTFail("Not implemented")
	}

	func testStackPosition_IsCorrect() {
		XCTFail("Not implemented")
	}

	func testWhenTopOfStackNotOneHive_CanMove_IsFalse() {
		XCTFail("Not implemented")
	}

	func testWhenBottomOfStackOneHive_CanMove_IsFalse() {
		XCTFail("Not implemented")
	}

	func testWhenBottomOfStackNotOneHive_CanMove_IsFalse() {
		XCTFail("Not implemented")
	}

	func testWhenTopOfStackOneHive_CanMove_IsTrue() {
		XCTFail("Not implemented")
	}

	static var allTests = [
		("testGetMovementToPositionInPlay_IsCorrect", testGetMovementToPositionInPlay_IsCorrect),
		("testGetMovementToPositionInHand_IsNil", testGetMovementToPositionInHand_IsNil),

		("testWhenSurrounded_IsSurrounded_IsTrue", testWhenSurrounded_IsSurrounded_IsTrue),
		("testWhenNotSurrounded_IsSurrounded_IsFalse", testWhenNotSurrounded_IsSurrounded_IsFalse),

		("testWhenTopOfStack_IsTopOfStack_IsTrue", testWhenTopOfStack_IsTopOfStack_IsTrue),
		("testWhenBottomOfStack_IsTopOfStack_IsFalse", testWhenBottomOfStack_IsTopOfStack_IsFalse),

		("testStackPosition_IsCorrect", testStackPosition_IsCorrect),

		("testWhenTopOfStackNotOneHive_CanMove_IsFalse", testWhenTopOfStackNotOneHive_CanMove_IsFalse),
		("testWhenBottomOfStackOneHive_CanMove_IsFalse", testWhenBottomOfStackOneHive_CanMove_IsFalse),
		("testWhenBottomOfStackNotOneHive_CanMove_IsFalse", testWhenBottomOfStackNotOneHive_CanMove_IsFalse),
		("testWhenTopOfStackOneHive_CanMove_IsTrue", testWhenTopOfStackOneHive_CanMove_IsTrue)
	]
}
