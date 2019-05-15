//
//  PlayerTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-14.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
import HiveEngine

final class PlayerTests: HiveEngineTestCase {

	func testPlayer_NextPlayer_IsCorrect() {
		XCTAssertEqual(Player.black, Player.white.next)
		XCTAssertEqual(Player.white, Player.black.next)
	}

	func testPlayerComparable_IsCorrect() {
		XCTAssertTrue(Player.white == Player.white)
		XCTAssertTrue(Player.black == Player.black)
		XCTAssertTrue(Player.white != Player.black)
		XCTAssertTrue(Player.black != Player.white)
		XCTAssertTrue(Player.white < Player.black)
		XCTAssertTrue(Player.black > Player.white)

		XCTAssertFalse(Player.white == Player.black)
		XCTAssertFalse(Player.black == Player.white)
		XCTAssertFalse(Player.white != Player.white)
		XCTAssertFalse(Player.black != Player.black)
		XCTAssertFalse(Player.white > Player.black)
		XCTAssertFalse(Player.black < Player.white)
	}

	func testPlayerDescription_IsCorrect() {
		XCTAssertEqual("White", Player.white.description)
		XCTAssertEqual("Black", Player.black.description)
	}

	static var allTests = [
		("testPlayer_NextPlayer_IsCorrect", testPlayer_NextPlayer_IsCorrect),
		("testPlayerComparable_IsCorrect", testPlayerComparable_IsCorrect),
		("testPlayerDescription_IsCorrect", testPlayerDescription_IsCorrect)
	]
}
