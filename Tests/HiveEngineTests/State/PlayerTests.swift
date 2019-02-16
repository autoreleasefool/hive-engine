//
//  PlayerTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-14.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
@testable import HiveEngine

final class PlayerTests: HiveEngineTestCase {

	func testPlayerNextPlayer() {
		XCTAssertEqual(Player.black, Player.white.next)
		XCTAssertEqual(Player.white, Player.black.next)
	}

	static var allTests = [
		("testPlayerNextPlayer", testPlayerNextPlayer)
	]
}
