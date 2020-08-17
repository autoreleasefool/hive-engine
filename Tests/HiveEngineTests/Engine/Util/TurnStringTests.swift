//
//  TurnStringTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-16.
//

import XCTest
@testable import HiveEngine

final class TurnStringTests: HiveEngineTestCase {
	func testTurnString_ParsesCorrectly() {
		XCTAssertEqual(TurnString(player: .black, turn: 24), TurnString(from: "Black[24]"))
		XCTAssertEqual(TurnString(player: .white, turn: 1), TurnString(from: "White[1]"))
	}

	func testTurnString_Description_IsCorrect() {
		let turnString = "White[1]"
		guard let turn = TurnString(from: turnString) else {
			XCTFail("Turn could not be parsed")
			return
		}

		XCTAssertEqual(turnString, turn.description)
	}

	func testTurnString_RequiresIntTurns() {
		XCTAssertNil(TurnString(from: "White[a]"))
	}

	static var allTests = [
		("testTurnString_ParsesCorrectly", testTurnString_ParsesCorrectly),
		("testTurnString_Description_IsCorrect", testTurnString_Description_IsCorrect),
		("testTurnString_RequiresIntTurns", testTurnString_RequiresIntTurns),
	]
}
