//
//  UHPCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import XCTest
@testable import HiveEngine

final class UHPCommandTests: HiveEngineTestCase {
	func testInfoCommand() {
		var state: GameState?

		let result = InfoCommand().invoke("", state: &state)
		XCTAssertEqual(.output("id Hive Engine v2.0.0\nMosquito;Ladybug;Pillbug"), result)
	}

	static var allTests = [
		("testInfoCommand", testInfoCommand),
	]
}
