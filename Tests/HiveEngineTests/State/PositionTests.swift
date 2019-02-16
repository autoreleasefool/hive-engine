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

	// TODO: add testing for freedomOfMovement

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
		("testCodingInHandPosition", testCodingInHandPosition)
	]
}
